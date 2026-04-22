import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/user_service.dart';
import '../../../../generated/l10n.dart';

class ProfileWidgetsEditSheet extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onRefresh;

  const ProfileWidgetsEditSheet({
    super.key,
    required this.userData,
    required this.onRefresh,
  });

  static void show(BuildContext context, {required Map<String, dynamic>? userData, required VoidCallback onRefresh}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ProfileWidgetsEditSheet(userData: userData, onRefresh: onRefresh),
    );
  }

  @override
  State<ProfileWidgetsEditSheet> createState() => _ProfileWidgetsEditSheetState();
}

class _ProfileWidgetsEditSheetState extends State<ProfileWidgetsEditSheet> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _newEmailController;
  late TextEditingController _passwordController;
  
  bool _showEmailFields = false;
  bool _obscurePassword = true;
  late String _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    final firstName = widget.userData?['firstName'] ?? widget.userData?['first_name'] ?? '';
    final lastName = widget.userData?['lastName'] ?? widget.userData?['last_name'] ?? '';
    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _newEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _currentPhotoUrl = widget.userData?['photoUrl'] ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _newEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildSheetTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBorder(context).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder(context).withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: AppColors.textPrimary(context), fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary(context).withOpacity(0.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final currentEmail = widget.userData?['email'] ?? Supabase.instance.client.auth.currentUser?.email ?? '';
    final defaultAvatars = AppAssets.defaultAvatars;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.editProfile,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Selecciona tu Avatar',
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: defaultAvatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final avatarUrl = defaultAvatars[index];
                  final isSelected = _currentPhotoUrl == avatarUrl;

                  return GestureDetector(
                    onTap: () async {
                      setState(() => _currentPhotoUrl = avatarUrl);
                      final successUrl = await UserService.uploadProfilePhoto(
                        null,
                        avatarUrl: avatarUrl,
                      );
                      if (successUrl != null) {
                        widget.onRefresh();
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)]
                            : [],
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.inputBorder(context).withOpacity(0.2),
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(l.firstName, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
            const SizedBox(height: 6),
            _buildSheetTextField(context: context, controller: _firstNameController, hint: l.enterFirstName),
            const SizedBox(height: 16),
            Text(l.lastName, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
            const SizedBox(height: 6),
            _buildSheetTextField(context: context, controller: _lastNameController, hint: l.enterLastName),
            const SizedBox(height: 20),
            
            GestureDetector(
              onTap: () => setState(() => _showEmailFields = !_showEmailFields),
              child: Row(
                children: [
                  Icon(
                    _showEmailFields ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l.newEmail,
                    style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (_showEmailFields) ...[
              const SizedBox(height: 12),
              // Email change info container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Flexible(child: Text(l.emailChangeInfo, style: const TextStyle(color: AppColors.primary, fontSize: 12))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(l.email, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.inputBorder(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(currentEmail, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
              ),
              const SizedBox(height: 12),
              Text(l.newEmail, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
              const SizedBox(height: 6),
              _buildSheetTextField(context: context, controller: _newEmailController, hint: l.enterNewEmail, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              Text(l.currentPassword, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
              const SizedBox(height: 6),
              _buildSheetTextField(
                context: context,
                controller: _passwordController,
                hint: l.enterCurrentPassword,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary(context), size: 18),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () async {
                  await UserService.updateUserName(
                    _firstNameController.text.trim(),
                    _lastNameController.text.trim(),
                  );

                  if (_newEmailController.text.isNotEmpty) {
                    try {
                      await Supabase.instance.client.auth.updateUser(
                        UserAttributes(email: _newEmailController.text.trim()),
                      );
                      await UserService.updateUserEmail(_newEmailController.text.trim());
                    } catch (e) {
                      debugPrint('Error updating email: $e');
                    }
                  }

                  widget.onRefresh();
                  if (mounted) Navigator.pop(context);
                },
                child: Text(l.saveChanges, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
