// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome! Get inspired and design your ideal space in 3D`
  String get welcome {
    return Intl.message(
      'Welcome! Get inspired and design your ideal space in 3D',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message('Log In', name: 'login', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `You must accept the terms to continue`
  String get acceptTermsError {
    return Intl.message(
      'You must accept the terms to continue',
      name: 'acceptTermsError',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get accountCreated {
    return Intl.message(
      'Account created successfully',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Error while registering`
  String get registerError {
    return Intl.message(
      'Error while registering',
      name: 'registerError',
      desc: '',
      args: [],
    );
  }

  /// `Step 1 of 1`
  String get step1of1 {
    return Intl.message('Step 1 of 1', name: 'step1of1', desc: '', args: []);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Join RyzeAI and start decorating`
  String get joinRyzeAI {
    return Intl.message(
      'Join RyzeAI and start decorating',
      name: 'joinRyzeAI',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Enter your first name`
  String get enterFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Enter your last name`
  String get enterLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Create a secure password`
  String get enterPassword {
    return Intl.message(
      'Create a secure password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmPasswordHint {
    return Intl.message(
      'Confirm your password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `By signing up you accept the `
  String get termsIntro {
    return Intl.message(
      'By signing up you accept the ',
      name: 'termsIntro',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// ` and the `
  String get andThe {
    return Intl.message(' and the ', name: 'andThe', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccountButton {
    return Intl.message(
      'Create Account',
      name: 'createAccountButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get helloUser {
    return Intl.message('Hello', name: 'helloUser', desc: '', args: []);
  }

  /// `Decorate with AI`
  String get decorate {
    return Intl.message(
      'Decorate with AI',
      name: 'decorate',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo and visualize furniture in 3D`
  String get decorateDesc {
    return Intl.message(
      'Take a photo and visualize furniture in 3D',
      name: 'decorateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Open AI Camera`
  String get openCamera {
    return Intl.message(
      'Open AI Camera',
      name: 'openCamera',
      desc: '',
      args: [],
    );
  }

  /// `Recent Projects`
  String get recentProjects {
    return Intl.message(
      'Recent Projects',
      name: 'recentProjects',
      desc: '',
      args: [],
    );
  }

  /// `Explore Styles`
  String get exploreStyles {
    return Intl.message(
      'Explore Styles',
      name: 'exploreStyles',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get projects {
    return Intl.message('Projects', name: 'projects', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `New`
  String get newBadge {
    return Intl.message('New', name: 'newBadge', desc: '', args: []);
  }

  /// `Take a photo of your space and visualize furniture in 3D instantly`
  String get decorateDesc2 {
    return Intl.message(
      'Take a photo of your space and visualize furniture in 3D instantly',
      name: 'decorateDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Modified`
  String get modifiedAgo {
    return Intl.message('Modified', name: 'modifiedAgo', desc: '', args: []);
  }

  /// `2h ago`
  String get hoursAgo {
    return Intl.message('2h ago', name: 'hoursAgo', desc: '', args: []);
  }

  /// `yesterday`
  String get yesterday {
    return Intl.message('yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Living Room`
  String get livingRoom {
    return Intl.message('Living Room', name: 'livingRoom', desc: '', args: []);
  }

  /// `Bedroom`
  String get bedroom {
    return Intl.message('Bedroom', name: 'bedroom', desc: '', args: []);
  }

  /// `Modern`
  String get modern {
    return Intl.message('Modern', name: 'modern', desc: '', args: []);
  }

  /// `Natural`
  String get natural {
    return Intl.message('Natural', name: 'natural', desc: '', args: []);
  }

  /// `Minimal`
  String get minimal {
    return Intl.message('Minimal', name: 'minimal', desc: '', args: []);
  }

  /// `Colorful`
  String get colorful {
    return Intl.message('Colorful', name: 'colorful', desc: '', args: []);
  }

  /// `+1 this month`
  String get thisMonth {
    return Intl.message('+1 this month', name: 'thisMonth', desc: '', args: []);
  }

  /// `5 new`
  String get newItems {
    return Intl.message('5 new', name: 'newItems', desc: '', args: []);
  }

  /// `Incorrect email or password`
  String get loginError {
    return Intl.message(
      'Incorrect email or password',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter both email and password`
  String get emptyFieldsError {
    return Intl.message(
      'Please enter both email and password',
      name: 'emptyFieldsError',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Welcome back!`
  String get loginSuccess {
    return Intl.message(
      'Welcome back!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message('Privacy', name: 'privacy', desc: '', args: []);
  }

  /// `Help & Support`
  String get helpSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Home User`
  String get homeUser {
    return Intl.message('Home User', name: 'homeUser', desc: '', args: []);
  }

  /// `Rooms`
  String get rooms {
    return Intl.message('Rooms', name: 'rooms', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacyTitle {
    return Intl.message('Privacy', name: 'privacyTitle', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `We will send you an email to reset your password`
  String get changePasswordDesc {
    return Intl.message(
      'We will send you an email to reset your password',
      name: 'changePasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Email`
  String get sendResetEmail {
    return Intl.message(
      'Send Reset Email',
      name: 'sendResetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `This action is permanent and cannot be undone`
  String get deleteAccountDesc {
    return Intl.message(
      'This action is permanent and cannot be undone',
      name: 'deleteAccountDesc',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountConfirm {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Email sent! Check your inbox`
  String get emailSent {
    return Intl.message(
      'Email sent! Check your inbox',
      name: 'emailSent',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get accountDeleted {
    return Intl.message(
      'Account deleted successfully',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `New Email`
  String get newEmail {
    return Intl.message('New Email', name: 'newEmail', desc: '', args: []);
  }

  /// `Enter your new email`
  String get enterNewEmail {
    return Intl.message(
      'Enter your new email',
      name: 'enterNewEmail',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Enter your current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `A verification email will be sent to the new address`
  String get emailChangeInfo {
    return Intl.message(
      'A verification email will be sent to the new address',
      name: 'emailChangeInfo',
      desc: '',
      args: [],
    );
  }

  /// `Verification email sent, please check your inbox`
  String get emailChanged {
    return Intl.message(
      'Verification email sent, please check your inbox',
      name: 'emailChanged',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Project Notifications`
  String get projectNotifications {
    return Intl.message(
      'Project Notifications',
      name: 'projectNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Updates about your decoration projects`
  String get projectNotificationsDesc {
    return Intl.message(
      'Updates about your decoration projects',
      name: 'projectNotificationsDesc',
      desc: '',
      args: [],
    );
  }

  /// `App Updates`
  String get appUpdates {
    return Intl.message('App Updates', name: 'appUpdates', desc: '', args: []);
  }

  /// `New features and improvements`
  String get appUpdatesDesc {
    return Intl.message(
      'New features and improvements',
      name: 'appUpdatesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Preferences saved`
  String get notificationsSaved {
    return Intl.message(
      'Preferences saved',
      name: 'notificationsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpSupportTitle {
    return Intl.message(
      'Help & Support',
      name: 'helpSupportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Asked Questions`
  String get faq {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `How do I create a project?`
  String get faqQ1 {
    return Intl.message(
      'How do I create a project?',
      name: 'faqQ1',
      desc: '',
      args: [],
    );
  }

  /// `Go to the Projects tab and tap the New button to start a new decoration project.`
  String get faqA1 {
    return Intl.message(
      'Go to the Projects tab and tap the New button to start a new decoration project.',
      name: 'faqA1',
      desc: '',
      args: [],
    );
  }

  /// `How does the AI camera work?`
  String get faqQ2 {
    return Intl.message(
      'How does the AI camera work?',
      name: 'faqQ2',
      desc: '',
      args: [],
    );
  }

  /// `Point your camera at any space and our AI will detect objects and suggest furniture in 3D.`
  String get faqA2 {
    return Intl.message(
      'Point your camera at any space and our AI will detect objects and suggest furniture in 3D.',
      name: 'faqA2',
      desc: '',
      args: [],
    );
  }

  /// `Can I change my email?`
  String get faqQ3 {
    return Intl.message(
      'Can I change my email?',
      name: 'faqQ3',
      desc: '',
      args: [],
    );
  }

  /// `Yes, go to Profile → Edit Profile and expand the email section to change it.`
  String get faqA3 {
    return Intl.message(
      'Yes, go to Profile → Edit Profile and expand the email section to change it.',
      name: 'faqA3',
      desc: '',
      args: [],
    );
  }

  /// `How do I delete my account?`
  String get faqQ4 {
    return Intl.message(
      'How do I delete my account?',
      name: 'faqQ4',
      desc: '',
      args: [],
    );
  }

  /// `Go to Profile → Privacy → Delete Account. This action is permanent.`
  String get faqA4 {
    return Intl.message(
      'Go to Profile → Privacy → Delete Account. This action is permanent.',
      name: 'faqA4',
      desc: '',
      args: [],
    );
  }

  /// `By using RyzeAI you agree to use the app responsibly. We are not responsible for decoration decisions made based on AI suggestions. All content is for inspiration purposes only.`
  String get termsContent {
    return Intl.message(
      'By using RyzeAI you agree to use the app responsibly. We are not responsible for decoration decisions made based on AI suggestions. All content is for inspiration purposes only.',
      name: 'termsContent',
      desc: '',
      args: [],
    );
  }

  /// `We collect your name, email and usage data to improve your experience. We never sell your data to third parties. You can delete your account and all associated data at any time.`
  String get privacyContent {
    return Intl.message(
      'We collect your name, email and usage data to improve your experience. We never sell your data to third parties. You can delete your account and all associated data at any time.',
      name: 'privacyContent',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
