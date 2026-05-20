import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @slide_me.
  ///
  /// In en, this message translates to:
  /// **'Slide to start'**
  String get slide_me;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Get inspired and design your ideal space'**
  String get welcome_subtitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Get inspired and design your ideal space'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @acceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms to continue'**
  String get acceptTermsError;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Error while registering'**
  String get registerError;

  /// No description provided for @step1of1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 1'**
  String get step1of1;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinRyzeAI.
  ///
  /// In en, this message translates to:
  /// **'Join RyzeAI and start decorating'**
  String get joinRyzeAI;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a secure password'**
  String get enterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'By signing up you accept the '**
  String get termsIntro;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @andThe.
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get andThe;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get helloUser;

  /// No description provided for @decorate.
  ///
  /// In en, this message translates to:
  /// **'Decorate with AI'**
  String get decorate;

  /// No description provided for @decorateDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a photo and visualize furniture'**
  String get decorateDesc;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open AI Camera'**
  String get openCamera;

  /// No description provided for @recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recentProjects;

  /// No description provided for @exploreStyles.
  ///
  /// In en, this message translates to:
  /// **'Explore Styles'**
  String get exploreStyles;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @publications.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get publications;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBadge;

  /// No description provided for @decorateDesc2.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your space and visualize furniture instantly'**
  String get decorateDesc2;

  /// No description provided for @modifiedAgo.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modifiedAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2h ago'**
  String get hoursAgo;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @livingRoom.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get livingRoom;

  /// No description provided for @bedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get bedroom;

  /// No description provided for @modern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get modern;

  /// No description provided for @natural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get natural;

  /// No description provided for @minimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get minimal;

  /// No description provided for @colorful.
  ///
  /// In en, this message translates to:
  /// **'Colorful'**
  String get colorful;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'+1 this month'**
  String get thisMonth;

  /// No description provided for @newItems.
  ///
  /// In en, this message translates to:
  /// **'5 new'**
  String get newItems;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get loginError;

  /// No description provided for @emptyFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please enter both email and password'**
  String get emptyFieldsError;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginSuccess;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @homeUser.
  ///
  /// In en, this message translates to:
  /// **'Home User'**
  String get homeUser;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'We will send you an email to reset your password'**
  String get changePasswordDesc;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmail;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone'**
  String get deleteAccountDesc;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent! Check your inbox'**
  String get emailSent;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmail;

  /// No description provided for @enterNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your new email'**
  String get enterNewEmail;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @emailChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'A verification email will be sent to the new address'**
  String get emailChangeInfo;

  /// No description provided for @emailChanged.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent, please check your inbox'**
  String get emailChanged;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @projectNotifications.
  ///
  /// In en, this message translates to:
  /// **'Project Notifications'**
  String get projectNotifications;

  /// No description provided for @projectNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates about your decoration projects'**
  String get projectNotificationsDesc;

  /// No description provided for @appUpdates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// No description provided for @appUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'New features and improvements'**
  String get appUpdatesDesc;

  /// No description provided for @notificationsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get notificationsSaved;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a project?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Go to the Projects tab and tap the New button to start a new decoration project.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How does the AI camera work?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at any space and our AI will detect objects and suggest furniture.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'Can I change my email?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Yes, go to Profile → Edit Profile and expand the email section to change it.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Privacy → Delete Account. This action is permanent.'**
  String get faqA4;

  /// No description provided for @termsContent.
  ///
  /// In en, this message translates to:
  /// **'By using RyzeAI you agree to use the app responsibly. We are not responsible for decoration decisions made based on AI suggestions. All content is for inspiration purposes only.'**
  String get termsContent;

  /// No description provided for @privacyContent.
  ///
  /// In en, this message translates to:
  /// **'We collect your name, email and usage data to improve your experience. We never sell your data to third parties. You can delete your account and all associated data at any time.'**
  String get privacyContent;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RyzeAI! 🎉'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us your style so we can personalize your experience'**
  String get welcomeSubtitle;

  /// No description provided for @selectStyles.
  ///
  /// In en, this message translates to:
  /// **'What styles do you like?'**
  String get selectStyles;

  /// No description provided for @selectStylesHint.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get selectStylesHint;

  /// No description provided for @styleModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get styleModern;

  /// No description provided for @styleNatural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get styleNatural;

  /// No description provided for @styleMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get styleMinimal;

  /// No description provided for @styleColorful.
  ///
  /// In en, this message translates to:
  /// **'Colorful'**
  String get styleColorful;

  /// No description provided for @styleRustic.
  ///
  /// In en, this message translates to:
  /// **'Rustic'**
  String get styleRustic;

  /// No description provided for @styleScandinavian.
  ///
  /// In en, this message translates to:
  /// **'Scandinavian'**
  String get styleScandinavian;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @myStyles.
  ///
  /// In en, this message translates to:
  /// **'My Styles'**
  String get myStyles;

  /// No description provided for @noStylesSelected.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t selected any styles yet'**
  String get noStylesSelected;

  /// No description provided for @acceptAndClose.
  ///
  /// In en, this message translates to:
  /// **'Accept & Close'**
  String get acceptAndClose;

  /// No description provided for @chooseSpace.
  ///
  /// In en, this message translates to:
  /// **'Choose a Space'**
  String get chooseSpace;

  /// No description provided for @chooseSpaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to apply this style?'**
  String get chooseSpaceDesc;

  /// No description provided for @spaceHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get spaceHome;

  /// No description provided for @spaceOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get spaceOffice;

  /// No description provided for @spaceRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant / Café'**
  String get spaceRestaurant;

  /// No description provided for @spaceStore.
  ///
  /// In en, this message translates to:
  /// **'Store / Shop'**
  String get spaceStore;

  /// No description provided for @spaceCustom.
  ///
  /// In en, this message translates to:
  /// **'Other Space'**
  String get spaceCustom;

  /// No description provided for @spaceCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your space...'**
  String get spaceCustomHint;

  /// No description provided for @spaceRoom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get spaceRoom;

  /// No description provided for @spaceLiving.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get spaceLiving;

  /// No description provided for @spaceBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get spaceBathroom;

  /// No description provided for @spaceKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get spaceKitchen;

  /// No description provided for @spaceReception.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get spaceReception;

  /// No description provided for @spaceMeeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting Room'**
  String get spaceMeeting;

  /// No description provided for @spaceCafeteria.
  ///
  /// In en, this message translates to:
  /// **'Cafeteria'**
  String get spaceCafeteria;

  /// No description provided for @spaceShop.
  ///
  /// In en, this message translates to:
  /// **'Shop Floor'**
  String get spaceShop;

  /// No description provided for @spaceStorefront.
  ///
  /// In en, this message translates to:
  /// **'Storefront'**
  String get spaceStorefront;

  /// No description provided for @spaceBar.
  ///
  /// In en, this message translates to:
  /// **'Bar Area'**
  String get spaceBar;

  /// No description provided for @spaceDiningRoom.
  ///
  /// In en, this message translates to:
  /// **'Dining Room'**
  String get spaceDiningRoom;

  /// No description provided for @generateIdeas.
  ///
  /// In en, this message translates to:
  /// **'Generate Ideas'**
  String get generateIdeas;

  /// No description provided for @generatingIdeas.
  ///
  /// In en, this message translates to:
  /// **'Generating ideas...'**
  String get generatingIdeas;

  /// No description provided for @inspirationFor.
  ///
  /// In en, this message translates to:
  /// **'Inspiration for'**
  String get inspirationFor;

  /// No description provided for @noIdeasYet.
  ///
  /// In en, this message translates to:
  /// **'Select a style and space to generate ideas'**
  String get noIdeasYet;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive instructions'**
  String get enterYourEmail;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get emailNotFound;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @emailSentFull.
  ///
  /// In en, this message translates to:
  /// **'Email sent successfully! Check your inbox or spam for the password reset instructions.'**
  String get emailSentFull;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully changed 🎉. You can now log in with your new password.'**
  String get passwordChangedSuccess;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @styleTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional'**
  String get styleTraditional;

  /// No description provided for @styleJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get styleJapanese;

  /// No description provided for @styleContemporary.
  ///
  /// In en, this message translates to:
  /// **'Contemporary'**
  String get styleContemporary;

  /// No description provided for @styleBohemian.
  ///
  /// In en, this message translates to:
  /// **'Bohemian'**
  String get styleBohemian;

  /// No description provided for @styleFarmhouse.
  ///
  /// In en, this message translates to:
  /// **'Farmhouse'**
  String get styleFarmhouse;

  /// No description provided for @styleVintage.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get styleVintage;

  /// No description provided for @styleIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial'**
  String get styleIndustrial;

  /// No description provided for @styleRetro.
  ///
  /// In en, this message translates to:
  /// **'Retro'**
  String get styleRetro;

  /// No description provided for @styleCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get styleCyberpunk;

  /// No description provided for @styleChristmas.
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get styleChristmas;

  /// No description provided for @styleTropical.
  ///
  /// In en, this message translates to:
  /// **'Tropical'**
  String get styleTropical;

  /// No description provided for @styleBrutalist.
  ///
  /// In en, this message translates to:
  /// **'Brutalist'**
  String get styleBrutalist;

  /// No description provided for @styleSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get styleSouthwest;

  /// No description provided for @styleBaroque.
  ///
  /// In en, this message translates to:
  /// **'Baroque'**
  String get styleBaroque;

  /// No description provided for @styleFuturistic.
  ///
  /// In en, this message translates to:
  /// **'Futuristic'**
  String get styleFuturistic;

  /// No description provided for @styleColonial.
  ///
  /// In en, this message translates to:
  /// **'Colonial'**
  String get styleColonial;

  /// No description provided for @styleRococo.
  ///
  /// In en, this message translates to:
  /// **'Rococo'**
  String get styleRococo;

  /// No description provided for @styleValentine.
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day'**
  String get styleValentine;

  /// No description provided for @myDesigns.
  ///
  /// In en, this message translates to:
  /// **'My Designs'**
  String get myDesigns;

  /// No description provided for @noDesignsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t generated any designs yet'**
  String get noDesignsYet;

  /// No description provided for @savedToDesigns.
  ///
  /// In en, this message translates to:
  /// **'Saved to My Designs'**
  String get savedToDesigns;

  /// No description provided for @generateDesign.
  ///
  /// In en, this message translates to:
  /// **'Generate Design'**
  String get generateDesign;

  /// No description provided for @generatingDesign.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generatingDesign;

  /// No description provided for @chooseRoomType.
  ///
  /// In en, this message translates to:
  /// **'Choose Room Type'**
  String get chooseRoomType;

  /// No description provided for @chooseStyle.
  ///
  /// In en, this message translates to:
  /// **'Choose Style'**
  String get chooseStyle;

  /// No description provided for @chooseColorPalette.
  ///
  /// In en, this message translates to:
  /// **'Choose Color Palette'**
  String get chooseColorPalette;

  /// No description provided for @addFeatures.
  ///
  /// In en, this message translates to:
  /// **'Add Features'**
  String get addFeatures;

  /// No description provided for @lighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting & Atmosphere'**
  String get lighting;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architectural Elements'**
  String get architecture;

  /// No description provided for @decoration.
  ///
  /// In en, this message translates to:
  /// **'Decoration & Details'**
  String get decoration;

  /// No description provided for @ambientLight.
  ///
  /// In en, this message translates to:
  /// **'Ambient Lighting'**
  String get ambientLight;

  /// No description provided for @naturalLight.
  ///
  /// In en, this message translates to:
  /// **'Natural Light'**
  String get naturalLight;

  /// No description provided for @cozyAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Cozy Atmosphere'**
  String get cozyAtmosphere;

  /// No description provided for @accentWall.
  ///
  /// In en, this message translates to:
  /// **'Accent Wall'**
  String get accentWall;

  /// No description provided for @builtInShelves.
  ///
  /// In en, this message translates to:
  /// **'Built-in Shelves'**
  String get builtInShelves;

  /// No description provided for @exposedBeams.
  ///
  /// In en, this message translates to:
  /// **'Exposed Beams'**
  String get exposedBeams;

  /// No description provided for @arches.
  ///
  /// In en, this message translates to:
  /// **'Arches'**
  String get arches;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants & Vegetation'**
  String get plants;

  /// No description provided for @mirrors.
  ///
  /// In en, this message translates to:
  /// **'Mirrors'**
  String get mirrors;

  /// No description provided for @texturedWalls.
  ///
  /// In en, this message translates to:
  /// **'Textured Walls'**
  String get texturedWalls;

  /// No description provided for @rugs.
  ///
  /// In en, this message translates to:
  /// **'Area Rugs'**
  String get rugs;

  /// No description provided for @colorPaletteNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get colorPaletteNeutral;

  /// No description provided for @colorPaletteWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get colorPaletteWarm;

  /// No description provided for @colorPaletteCool.
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get colorPaletteCool;

  /// No description provided for @colorPaletteEarthy.
  ///
  /// In en, this message translates to:
  /// **'Earthy'**
  String get colorPaletteEarthy;

  /// No description provided for @colorPaletteMonochrome.
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get colorPaletteMonochrome;

  /// No description provided for @colorPaletteVibrant.
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get colorPaletteVibrant;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @projectNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Give your project a name'**
  String get projectNameTitle;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Eg: My primary bedroom...'**
  String get projectNameHint;

  /// No description provided for @roomTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the room type'**
  String get roomTypeTitle;

  /// No description provided for @styleTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the style'**
  String get styleTitle;

  /// No description provided for @colorPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the color palette'**
  String get colorPaletteTitle;

  /// No description provided for @promptTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to change or add?'**
  String get promptTitle;

  /// No description provided for @promptHint.
  ///
  /// In en, this message translates to:
  /// **'Eg: Add a wooden desk, plants and warm light...'**
  String get promptHint;

  /// No description provided for @addFurnitureTitle.
  ///
  /// In en, this message translates to:
  /// **'Add furniture and objects'**
  String get addFurnitureTitle;

  /// No description provided for @addFurnitureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose up to 5 items to suggest in your space'**
  String get addFurnitureSubtitle;

  /// No description provided for @cameraPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera and photo'**
  String get cameraPhotoTitle;

  /// No description provided for @cameraOptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Keep details'**
  String get cameraOptionDetails;

  /// No description provided for @cameraOptionDetailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep existing elements'**
  String get cameraOptionDetailsDesc;

  /// No description provided for @cameraOptionSameAngle.
  ///
  /// In en, this message translates to:
  /// **'Same angle'**
  String get cameraOptionSameAngle;

  /// No description provided for @cameraOptionSameAngleDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep the original perspective'**
  String get cameraOptionSameAngleDesc;

  /// No description provided for @cameraOptionChangeAngle.
  ///
  /// In en, this message translates to:
  /// **'Change angle'**
  String get cameraOptionChangeAngle;

  /// No description provided for @cameraOptionChangeAngleDesc.
  ///
  /// In en, this message translates to:
  /// **'AI chooses a better angle'**
  String get cameraOptionChangeAngleDesc;

  /// No description provided for @projectNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Project name is required'**
  String get projectNameRequiredError;

  /// No description provided for @roomTypeRequiredError.
  ///
  /// In en, this message translates to:
  /// **'You must select a room type'**
  String get roomTypeRequiredError;

  /// No description provided for @colorPaletteRequiredError.
  ///
  /// In en, this message translates to:
  /// **'You must select a color palette'**
  String get colorPaletteRequiredError;

  /// No description provided for @promptRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Describe what you want to change or add'**
  String get promptRequiredError;

  /// No description provided for @styleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'You must select a style'**
  String get styleRequiredError;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User is not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @microphonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get microphonePermissionDenied;

  /// No description provided for @speechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is unavailable'**
  String get speechUnavailable;

  /// No description provided for @speechRecognitionStatus.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition status'**
  String get speechRecognitionStatus;

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error'**
  String get speechRecognitionError;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get listening;

  /// No description provided for @errorUploadingOriginalImage.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the original image'**
  String get errorUploadingOriginalImage;

  /// No description provided for @errorSavingProject.
  ///
  /// In en, this message translates to:
  /// **'Could not save the project'**
  String get errorSavingProject;

  /// No description provided for @errorGeneratingIdea.
  ///
  /// In en, this message translates to:
  /// **'Error generating idea'**
  String get errorGeneratingIdea;

  /// No description provided for @generateProjectError.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the project. Please try again.'**
  String get generateProjectError;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get emailAlreadyExists;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordTooWeak;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get registrationError;

  /// No description provided for @profileCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user profile'**
  String get profileCreationFailed;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @login_tab.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_tab;

  /// No description provided for @signup_tab.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup_tab;

  /// No description provided for @full_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name_label;

  /// No description provided for @forgot_password_link.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password_link;

  /// No description provided for @terms_signup_intro.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you are accepting our '**
  String get terms_signup_intro;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter both passwords'**
  String get passwordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// No description provided for @errorUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Error updating password'**
  String get errorUpdatingPassword;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @projects_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get projects_new;

  /// No description provided for @projects_empty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any projects yet.'**
  String get projects_empty;

  /// No description provided for @projects_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get projects_untitled;

  /// No description provided for @projects_styles_count.
  ///
  /// In en, this message translates to:
  /// **'{count} styles'**
  String projects_styles_count(Object count);

  /// No description provided for @projects_status_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get projects_status_draft;

  /// No description provided for @projects_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projects_status_completed;

  /// No description provided for @projects_status_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get projects_status_in_progress;

  /// No description provided for @projects_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get projects_error_generic;

  /// No description provided for @favorites_empty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any favorite projects yet'**
  String get favorites_empty;

  /// No description provided for @projects_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No saved designs'**
  String get projects_empty_title;

  /// No description provided for @projects_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your generated room designs will appear here. Start creating to see your transformations!'**
  String get projects_empty_subtitle;

  /// No description provided for @projects_empty_step1.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of the room'**
  String get projects_empty_step1;

  /// No description provided for @projects_empty_step2.
  ///
  /// In en, this message translates to:
  /// **'Choose your style'**
  String get projects_empty_step2;

  /// No description provided for @projects_empty_step3.
  ///
  /// In en, this message translates to:
  /// **'Generate and save'**
  String get projects_empty_step3;

  /// No description provided for @projects_empty_button.
  ///
  /// In en, this message translates to:
  /// **'+ Create your first design'**
  String get projects_empty_button;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectOption;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImage;

  /// No description provided for @errorImagePickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorImagePickerLabel;

  /// No description provided for @project_detail_default_room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get project_detail_default_room;

  /// No description provided for @project_detail_default_palette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get project_detail_default_palette;

  /// No description provided for @project_detail_default_feature.
  ///
  /// In en, this message translates to:
  /// **'Object'**
  String get project_detail_default_feature;

  /// No description provided for @project_detail_date_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get project_detail_date_unavailable;

  /// No description provided for @project_detail_now_private.
  ///
  /// In en, this message translates to:
  /// **'The project is now private'**
  String get project_detail_now_private;

  /// No description provided for @project_detail_now_public.
  ///
  /// In en, this message translates to:
  /// **'The project is now public'**
  String get project_detail_now_public;

  /// No description provided for @project_detail_error_update.
  ///
  /// In en, this message translates to:
  /// **'Error updating status: {error}'**
  String project_detail_error_update(String error);

  /// No description provided for @project_detail_section_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get project_detail_section_status;

  /// No description provided for @project_detail_section_room_type.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get project_detail_section_room_type;

  /// No description provided for @project_detail_section_styles.
  ///
  /// In en, this message translates to:
  /// **'Styles'**
  String get project_detail_section_styles;

  /// No description provided for @project_detail_section_palette.
  ///
  /// In en, this message translates to:
  /// **'Color palette'**
  String get project_detail_section_palette;

  /// No description provided for @project_detail_section_features.
  ///
  /// In en, this message translates to:
  /// **'Furniture & objects'**
  String get project_detail_section_features;

  /// No description provided for @project_detail_section_prompt.
  ///
  /// In en, this message translates to:
  /// **'What do you want to change or add?'**
  String get project_detail_section_prompt;

  /// No description provided for @project_detail_section_times.
  ///
  /// In en, this message translates to:
  /// **'Timestamps'**
  String get project_detail_section_times;

  /// No description provided for @project_detail_status_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get project_detail_status_public;

  /// No description provided for @project_detail_status_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get project_detail_status_private;

  /// No description provided for @project_detail_created_at.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get project_detail_created_at;

  /// No description provided for @project_detail_updated_at.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get project_detail_updated_at;

  /// No description provided for @project_detail_btn_publish.
  ///
  /// In en, this message translates to:
  /// **'Publish project'**
  String get project_detail_btn_publish;

  /// No description provided for @project_detail_btn_make_private.
  ///
  /// In en, this message translates to:
  /// **'Make private'**
  String get project_detail_btn_make_private;

  /// No description provided for @project_detail_toggle_original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get project_detail_toggle_original;

  /// No description provided for @project_detail_toggle_generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get project_detail_toggle_generated;

  /// No description provided for @project_detail_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Project updated successfully'**
  String get project_detail_updated_success;

  /// No description provided for @project_detail_error_update_edit.
  ///
  /// In en, this message translates to:
  /// **'Error updating project: {error}'**
  String project_detail_error_update_edit(String error);

  /// No description provided for @project_detail_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get project_detail_edit_title;

  /// No description provided for @project_detail_edit_name_label.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get project_detail_edit_name_label;

  /// No description provided for @project_detail_edit_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get project_detail_edit_name_hint;

  /// No description provided for @project_detail_name_required.
  ///
  /// In en, this message translates to:
  /// **'Project name is required'**
  String get project_detail_name_required;

  /// No description provided for @project_detail_edit_prompt_label.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get project_detail_edit_prompt_label;

  /// No description provided for @project_detail_edit_prompt_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe what to change or add...'**
  String get project_detail_edit_prompt_hint;

  /// No description provided for @project_detail_btn_regenerating.
  ///
  /// In en, this message translates to:
  /// **'Regenerating...'**
  String get project_detail_btn_regenerating;

  /// No description provided for @project_detail_btn_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get project_detail_btn_saving;

  /// No description provided for @project_detail_btn_save_and_regenerate.
  ///
  /// In en, this message translates to:
  /// **'Save and regenerate'**
  String get project_detail_btn_save_and_regenerate;

  /// No description provided for @project_detail_delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete project'**
  String get project_detail_delete_confirm_title;

  /// No description provided for @project_detail_delete_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project? This cannot be undone.'**
  String get project_detail_delete_confirm_message;

  /// No description provided for @project_detail_delete_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get project_detail_delete_confirm_cancel;

  /// No description provided for @project_detail_delete_confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get project_detail_delete_confirm_delete;

  /// No description provided for @project_detail_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully'**
  String get project_detail_deleted_success;

  /// No description provided for @project_detail_error_delete.
  ///
  /// In en, this message translates to:
  /// **'Error deleting project: {error}'**
  String project_detail_error_delete(String error);

  /// No description provided for @project_detail_btn_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit project'**
  String get project_detail_btn_edit;

  /// No description provided for @project_detail_btn_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete project'**
  String get project_detail_btn_delete;

  /// No description provided for @projects_status_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get projects_status_public;

  /// No description provided for @projects_status_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get projects_status_private;

  /// No description provided for @publications_title.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get publications_title;

  /// No description provided for @publications_filter_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get publications_filter_favorites;

  /// No description provided for @publications_empty_favorites.
  ///
  /// In en, this message translates to:
  /// **'You have no favorites yet'**
  String get publications_empty_favorites;

  /// No description provided for @publications_empty_all.
  ///
  /// In en, this message translates to:
  /// **'No publications yet'**
  String get publications_empty_all;

  /// No description provided for @publications_unknown_author.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get publications_unknown_author;

  /// No description provided for @publications_liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get publications_liked;

  /// No description provided for @home_error_image_pick.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String home_error_image_pick(String error);

  /// No description provided for @home_section_stats.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get home_section_stats;

  /// No description provided for @home_stat_this_month.
  ///
  /// In en, this message translates to:
  /// **'+{count} this month'**
  String home_stat_this_month(int count);

  /// No description provided for @home_stat_new.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String home_stat_new(int count);

  /// No description provided for @home_stat_public_label.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get home_stat_public_label;

  /// No description provided for @home_stat_published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get home_stat_published;

  /// No description provided for @home_time_minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String home_time_minutes(int count);

  /// No description provided for @home_time_hours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String home_time_hours(int count);

  /// No description provided for @home_time_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get home_time_yesterday;

  /// No description provided for @home_time_days.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String home_time_days(int count);

  /// No description provided for @home_empty_projects.
  ///
  /// In en, this message translates to:
  /// **'You have no projects yet.\nStart by taking a photo of your space.'**
  String get home_empty_projects;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'es':
      return SEs();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
