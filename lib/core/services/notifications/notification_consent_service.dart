import 'package:shared_preferences/shared_preferences.dart';

class NotificationConsentService {
  static const _consentKey = 'notifications_consent_accepted';

  static Future<bool> hasAcceptedNotificationConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  static Future<void> setAcceptedNotificationConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, value);
  }
}
