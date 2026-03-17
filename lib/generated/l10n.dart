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
