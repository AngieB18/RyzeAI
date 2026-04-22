import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class PromptInputSheet extends StatefulWidget {
  final String title;
  final String hint;
  final void Function(String prompt) onGenerate;

  const PromptInputSheet({
    super.key,
    required this.title,
    required this.hint,
    required this.onGenerate,
  });

  @override
  State<PromptInputSheet> createState() => _PromptInputSheetState();
}

class _PromptInputSheetState extends State<PromptInputSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            widget.title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Campo de texto
          TextField(
            controller: _controller,
            maxLines: 3,
            style: TextStyle(color: AppColors.textPrimary(context)),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: AppColors.textSecondary(context)),
              filled: true,
              fillColor: AppColors.background(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Botón generar
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  Navigator.pop(context);
                  widget.onGenerate(text);
                }
              },
              child: const Text(
                'Generar diseño ✨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}