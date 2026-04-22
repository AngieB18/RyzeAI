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

  /// `Slide to start`
  String get slide_me {
    return Intl.message('Slide to start', name: 'slide_me', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome_title {
    return Intl.message('Welcome', name: 'welcome_title', desc: '', args: []);
  }

  /// `Welcome! Get inspired and design your ideal space in 3D`
  String get welcome_subtitle {
    return Intl.message(
      'Welcome! Get inspired and design your ideal space in 3D',
      name: 'welcome_subtitle',
      desc: '',
      args: [],
    );
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

  /// `Welcome back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back!',
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

  /// `Welcome to RyzeAI! 🎉`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to RyzeAI! 🎉',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your style so we can personalize your experience`
  String get welcomeSubtitle {
    return Intl.message(
      'Tell us your style so we can personalize your experience',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `What styles do you like?`
  String get selectStyles {
    return Intl.message(
      'What styles do you like?',
      name: 'selectStyles',
      desc: '',
      args: [],
    );
  }

  /// `Select all that apply`
  String get selectStylesHint {
    return Intl.message(
      'Select all that apply',
      name: 'selectStylesHint',
      desc: '',
      args: [],
    );
  }

  /// `Modern`
  String get styleModern {
    return Intl.message('Modern', name: 'styleModern', desc: '', args: []);
  }

  /// `Natural`
  String get styleNatural {
    return Intl.message('Natural', name: 'styleNatural', desc: '', args: []);
  }

  /// `Minimal`
  String get styleMinimal {
    return Intl.message('Minimal', name: 'styleMinimal', desc: '', args: []);
  }

  /// `Colorful`
  String get styleColorful {
    return Intl.message('Colorful', name: 'styleColorful', desc: '', args: []);
  }

  /// `Rustic`
  String get styleRustic {
    return Intl.message('Rustic', name: 'styleRustic', desc: '', args: []);
  }

  /// `Scandinavian`
  String get styleScandinavian {
    return Intl.message(
      'Scandinavian',
      name: 'styleScandinavian',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `My Styles`
  String get myStyles {
    return Intl.message('My Styles', name: 'myStyles', desc: '', args: []);
  }

  /// `You haven't selected any styles yet`
  String get noStylesSelected {
    return Intl.message(
      'You haven\'t selected any styles yet',
      name: 'noStylesSelected',
      desc: '',
      args: [],
    );
  }

  /// `Accept & Close`
  String get acceptAndClose {
    return Intl.message(
      'Accept & Close',
      name: 'acceptAndClose',
      desc: '',
      args: [],
    );
  }

  /// `Choose a Space`
  String get chooseSpace {
    return Intl.message(
      'Choose a Space',
      name: 'chooseSpace',
      desc: '',
      args: [],
    );
  }

  /// `Where do you want to apply this style?`
  String get chooseSpaceDesc {
    return Intl.message(
      'Where do you want to apply this style?',
      name: 'chooseSpaceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get spaceHome {
    return Intl.message('Home', name: 'spaceHome', desc: '', args: []);
  }

  /// `Office`
  String get spaceOffice {
    return Intl.message('Office', name: 'spaceOffice', desc: '', args: []);
  }

  /// `Restaurant / Café`
  String get spaceRestaurant {
    return Intl.message(
      'Restaurant / Café',
      name: 'spaceRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Store / Shop`
  String get spaceStore {
    return Intl.message('Store / Shop', name: 'spaceStore', desc: '', args: []);
  }

  /// `Other Space`
  String get spaceCustom {
    return Intl.message('Other Space', name: 'spaceCustom', desc: '', args: []);
  }

  /// `Describe your space...`
  String get spaceCustomHint {
    return Intl.message(
      'Describe your space...',
      name: 'spaceCustomHint',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get spaceRoom {
    return Intl.message('Bedroom', name: 'spaceRoom', desc: '', args: []);
  }

  /// `Living Room`
  String get spaceLiving {
    return Intl.message('Living Room', name: 'spaceLiving', desc: '', args: []);
  }

  /// `Bathroom`
  String get spaceBathroom {
    return Intl.message('Bathroom', name: 'spaceBathroom', desc: '', args: []);
  }

  /// `Kitchen`
  String get spaceKitchen {
    return Intl.message('Kitchen', name: 'spaceKitchen', desc: '', args: []);
  }

  /// `Reception`
  String get spaceReception {
    return Intl.message(
      'Reception',
      name: 'spaceReception',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Room`
  String get spaceMeeting {
    return Intl.message(
      'Meeting Room',
      name: 'spaceMeeting',
      desc: '',
      args: [],
    );
  }

  /// `Cafeteria`
  String get spaceCafeteria {
    return Intl.message(
      'Cafeteria',
      name: 'spaceCafeteria',
      desc: '',
      args: [],
    );
  }

  /// `Shop Floor`
  String get spaceShop {
    return Intl.message('Shop Floor', name: 'spaceShop', desc: '', args: []);
  }

  /// `Storefront`
  String get spaceStorefront {
    return Intl.message(
      'Storefront',
      name: 'spaceStorefront',
      desc: '',
      args: [],
    );
  }

  /// `Bar Area`
  String get spaceBar {
    return Intl.message('Bar Area', name: 'spaceBar', desc: '', args: []);
  }

  /// `Dining Room`
  String get spaceDiningRoom {
    return Intl.message(
      'Dining Room',
      name: 'spaceDiningRoom',
      desc: '',
      args: [],
    );
  }

  /// `Generate Ideas`
  String get generateIdeas {
    return Intl.message(
      'Generate Ideas',
      name: 'generateIdeas',
      desc: '',
      args: [],
    );
  }

  /// `Generating ideas...`
  String get generatingIdeas {
    return Intl.message(
      'Generating ideas...',
      name: 'generatingIdeas',
      desc: '',
      args: [],
    );
  }

  /// `Inspiration for`
  String get inspirationFor {
    return Intl.message(
      'Inspiration for',
      name: 'inspirationFor',
      desc: '',
      args: [],
    );
  }

  /// `Select a style and space to generate ideas`
  String get noIdeasYet {
    return Intl.message(
      'Select a style and space to generate ideas',
      name: 'noIdeasYet',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Recover Password`
  String get recoverPassword {
    return Intl.message(
      'Recover Password',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to receive instructions`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email to receive instructions',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get sendEmail {
    return Intl.message('Send Email', name: 'sendEmail', desc: '', args: []);
  }

  /// `No user found with this email`
  String get emailNotFound {
    return Intl.message(
      'No user found with this email',
      name: 'emailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email sent successfully! Check your inbox or spam for the password reset instructions.`
  String get emailSentFull {
    return Intl.message(
      'Email sent successfully! Check your inbox or spam for the password reset instructions.',
      name: 'emailSentFull',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been successfully changed 🎉. You can now log in with your new password.`
  String get passwordChangedSuccess {
    return Intl.message(
      'Your password has been successfully changed 🎉. You can now log in with your new password.',
      name: 'passwordChangedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Traditional`
  String get styleTraditional {
    return Intl.message(
      'Traditional',
      name: 'styleTraditional',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get styleJapanese {
    return Intl.message('Japanese', name: 'styleJapanese', desc: '', args: []);
  }

  /// `Contemporary`
  String get styleContemporary {
    return Intl.message(
      'Contemporary',
      name: 'styleContemporary',
      desc: '',
      args: [],
    );
  }

  /// `Bohemian`
  String get styleBohemian {
    return Intl.message('Bohemian', name: 'styleBohemian', desc: '', args: []);
  }

  /// `Farmhouse`
  String get styleFarmhouse {
    return Intl.message(
      'Farmhouse',
      name: 'styleFarmhouse',
      desc: '',
      args: [],
    );
  }

  /// `Vintage`
  String get styleVintage {
    return Intl.message('Vintage', name: 'styleVintage', desc: '', args: []);
  }

  /// `Industrial`
  String get styleIndustrial {
    return Intl.message(
      'Industrial',
      name: 'styleIndustrial',
      desc: '',
      args: [],
    );
  }

  /// `Retro`
  String get styleRetro {
    return Intl.message('Retro', name: 'styleRetro', desc: '', args: []);
  }

  /// `Cyberpunk`
  String get styleCyberpunk {
    return Intl.message(
      'Cyberpunk',
      name: 'styleCyberpunk',
      desc: '',
      args: [],
    );
  }

  /// `Christmas`
  String get styleChristmas {
    return Intl.message(
      'Christmas',
      name: 'styleChristmas',
      desc: '',
      args: [],
    );
  }

  /// `Tropical`
  String get styleTropical {
    return Intl.message('Tropical', name: 'styleTropical', desc: '', args: []);
  }

  /// `Brutalist`
  String get styleBrutalist {
    return Intl.message(
      'Brutalist',
      name: 'styleBrutalist',
      desc: '',
      args: [],
    );
  }

  /// `Southwest`
  String get styleSouthwest {
    return Intl.message(
      'Southwest',
      name: 'styleSouthwest',
      desc: '',
      args: [],
    );
  }

  /// `Baroque`
  String get styleBaroque {
    return Intl.message('Baroque', name: 'styleBaroque', desc: '', args: []);
  }

  /// `Futuristic`
  String get styleFuturistic {
    return Intl.message(
      'Futuristic',
      name: 'styleFuturistic',
      desc: '',
      args: [],
    );
  }

  /// `Colonial`
  String get styleColonial {
    return Intl.message('Colonial', name: 'styleColonial', desc: '', args: []);
  }

  /// `Rococo`
  String get styleRococo {
    return Intl.message('Rococo', name: 'styleRococo', desc: '', args: []);
  }

  /// `Valentine's Day`
  String get styleValentine {
    return Intl.message(
      'Valentine\'s Day',
      name: 'styleValentine',
      desc: '',
      args: [],
    );
  }

  /// `My Designs`
  String get myDesigns {
    return Intl.message('My Designs', name: 'myDesigns', desc: '', args: []);
  }

  /// `You haven't generated any designs yet`
  String get noDesignsYet {
    return Intl.message(
      'You haven\'t generated any designs yet',
      name: 'noDesignsYet',
      desc: '',
      args: [],
    );
  }

  /// `Saved to My Designs`
  String get savedToDesigns {
    return Intl.message(
      'Saved to My Designs',
      name: 'savedToDesigns',
      desc: '',
      args: [],
    );
  }

  /// `Generate Design`
  String get generateDesign {
    return Intl.message(
      'Generate Design',
      name: 'generateDesign',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get generatingDesign {
    return Intl.message(
      'Generating...',
      name: 'generatingDesign',
      desc: '',
      args: [],
    );
  }

  /// `Choose Room Type`
  String get chooseRoomType {
    return Intl.message(
      'Choose Room Type',
      name: 'chooseRoomType',
      desc: '',
      args: [],
    );
  }

  /// `Choose Style`
  String get chooseStyle {
    return Intl.message(
      'Choose Style',
      name: 'chooseStyle',
      desc: '',
      args: [],
    );
  }

  /// `Choose Color Palette`
  String get chooseColorPalette {
    return Intl.message(
      'Choose Color Palette',
      name: 'chooseColorPalette',
      desc: '',
      args: [],
    );
  }

  /// `Add Features`
  String get addFeatures {
    return Intl.message(
      'Add Features',
      name: 'addFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Lighting & Atmosphere`
  String get lighting {
    return Intl.message(
      'Lighting & Atmosphere',
      name: 'lighting',
      desc: '',
      args: [],
    );
  }

  /// `Architectural Elements`
  String get architecture {
    return Intl.message(
      'Architectural Elements',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `Decoration & Details`
  String get decoration {
    return Intl.message(
      'Decoration & Details',
      name: 'decoration',
      desc: '',
      args: [],
    );
  }

  /// `Ambient Lighting`
  String get ambientLight {
    return Intl.message(
      'Ambient Lighting',
      name: 'ambientLight',
      desc: '',
      args: [],
    );
  }

  /// `Natural Light`
  String get naturalLight {
    return Intl.message(
      'Natural Light',
      name: 'naturalLight',
      desc: '',
      args: [],
    );
  }

  /// `Cozy Atmosphere`
  String get cozyAtmosphere {
    return Intl.message(
      'Cozy Atmosphere',
      name: 'cozyAtmosphere',
      desc: '',
      args: [],
    );
  }

  /// `Accent Wall`
  String get accentWall {
    return Intl.message('Accent Wall', name: 'accentWall', desc: '', args: []);
  }

  /// `Built-in Shelves`
  String get builtInShelves {
    return Intl.message(
      'Built-in Shelves',
      name: 'builtInShelves',
      desc: '',
      args: [],
    );
  }

  /// `Exposed Beams`
  String get exposedBeams {
    return Intl.message(
      'Exposed Beams',
      name: 'exposedBeams',
      desc: '',
      args: [],
    );
  }

  /// `Arches`
  String get arches {
    return Intl.message('Arches', name: 'arches', desc: '', args: []);
  }

  /// `Plants & Vegetation`
  String get plants {
    return Intl.message(
      'Plants & Vegetation',
      name: 'plants',
      desc: '',
      args: [],
    );
  }

  /// `Mirrors`
  String get mirrors {
    return Intl.message('Mirrors', name: 'mirrors', desc: '', args: []);
  }

  /// `Textured Walls`
  String get texturedWalls {
    return Intl.message(
      'Textured Walls',
      name: 'texturedWalls',
      desc: '',
      args: [],
    );
  }

  /// `Area Rugs`
  String get rugs {
    return Intl.message('Area Rugs', name: 'rugs', desc: '', args: []);
  }

  /// `Neutral`
  String get colorPaletteNeutral {
    return Intl.message(
      'Neutral',
      name: 'colorPaletteNeutral',
      desc: '',
      args: [],
    );
  }

  /// `Warm`
  String get colorPaletteWarm {
    return Intl.message('Warm', name: 'colorPaletteWarm', desc: '', args: []);
  }

  /// `Cool`
  String get colorPaletteCool {
    return Intl.message('Cool', name: 'colorPaletteCool', desc: '', args: []);
  }

  /// `Earthy`
  String get colorPaletteEarthy {
    return Intl.message(
      'Earthy',
      name: 'colorPaletteEarthy',
      desc: '',
      args: [],
    );
  }

  /// `Monochrome`
  String get colorPaletteMonochrome {
    return Intl.message(
      'Monochrome',
      name: 'colorPaletteMonochrome',
      desc: '',
      args: [],
    );
  }

  /// `Vibrant`
  String get colorPaletteVibrant {
    return Intl.message(
      'Vibrant',
      name: 'colorPaletteVibrant',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `This email is already registered`
  String get emailAlreadyExists {
    return Intl.message(
      'This email is already registered',
      name: 'emailAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak`
  String get passwordTooWeak {
    return Intl.message(
      'Password is too weak',
      name: 'passwordTooWeak',
      desc: '',
      args: [],
    );
  }

  /// `Registration error`
  String get registrationError {
    return Intl.message(
      'Registration error',
      name: 'registrationError',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create user profile`
  String get profileCreationFailed {
    return Intl.message(
      'Failed to create user profile',
      name: 'profileCreationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Creating account...`
  String get creatingAccount {
    return Intl.message(
      'Creating account...',
      name: 'creatingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_tab {
    return Intl.message('Login', name: 'login_tab', desc: '', args: []);
  }

  /// `Signup`
  String get signup_tab {
    return Intl.message('Signup', name: 'signup_tab', desc: '', args: []);
  }

  /// `Full Name`
  String get full_name_label {
    return Intl.message(
      'Full Name',
      name: 'full_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password_link {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password_link',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account you are accepting our `
  String get terms_signup_intro {
    return Intl.message(
      'By creating an account you are accepting our ',
      name: 'terms_signup_intro',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePassword {
    return Intl.message(
      'Update Password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter both passwords`
  String get passwordRequired {
    return Intl.message(
      'Please enter both passwords',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get passwordUpdated {
    return Intl.message(
      'Password updated successfully',
      name: 'passwordUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating password`
  String get errorUpdatingPassword {
    return Intl.message(
      'Error updating password',
      name: 'errorUpdatingPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get remember_me {
    return Intl.message('Remember me', name: 'remember_me', desc: '', args: []);
  }

  /// `New`
  String get projects_new {
    return Intl.message('New', name: 'projects_new', desc: '', args: []);
  }

  /// `You don't have any projects yet.`
  String get projects_empty {
    return Intl.message(
      'You don\'t have any projects yet.',
      name: 'projects_empty',
      desc: '',
      args: [],
    );
  }

  /// `Untitled`
  String get projects_untitled {
    return Intl.message(
      'Untitled',
      name: 'projects_untitled',
      desc: '',
      args: [],
    );
  }

  /// `{count} styles`
  String projects_styles_count(Object count) {
    return Intl.message(
      '$count styles',
      name: 'projects_styles_count',
      desc: '',
      args: [count],
    );
  }

  /// `Draft`
  String get projects_status_draft {
    return Intl.message(
      'Draft',
      name: 'projects_status_draft',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get projects_status_completed {
    return Intl.message(
      'Completed',
      name: 'projects_status_completed',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get projects_status_in_progress {
    return Intl.message(
      'In progress',
      name: 'projects_status_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get projects_error_generic {
    return Intl.message(
      'Something went wrong',
      name: 'projects_error_generic',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any favorite projects yet`
  String get favorites_empty {
    return Intl.message(
      'You don\'t have any favorite projects yet',
      name: 'favorites_empty',
      desc: '',
      args: [],
    );
  }

  /// `No saved designs`
  String get projects_empty_title {
    return Intl.message(
      'No saved designs',
      name: 'projects_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Your generated room designs will appear here. Start creating to see your transformations!`
  String get projects_empty_subtitle {
    return Intl.message(
      'Your generated room designs will appear here. Start creating to see your transformations!',
      name: 'projects_empty_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo of the room`
  String get projects_empty_step1 {
    return Intl.message(
      'Upload a photo of the room',
      name: 'projects_empty_step1',
      desc: '',
      args: [],
    );
  }

  /// `Choose your style`
  String get projects_empty_step2 {
    return Intl.message(
      'Choose your style',
      name: 'projects_empty_step2',
      desc: '',
      args: [],
    );
  }

  /// `Generate and save`
  String get projects_empty_step3 {
    return Intl.message(
      'Generate and save',
      name: 'projects_empty_step3',
      desc: '',
      args: [],
    );
  }

  /// `+ Create your first design`
  String get projects_empty_button {
    return Intl.message(
      '+ Create your first design',
      name: 'projects_empty_button',
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
