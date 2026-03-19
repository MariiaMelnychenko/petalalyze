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

  /// `Petalalyze`
  String get appTitle {
    return Intl.message('Petalalyze', name: 'appTitle', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Scan your bouquet and find out what flowers are in it ❀ `
  String get homeTitle {
    return Intl.message(
      'Scan your bouquet and find out what flowers are in it ❀ ',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Catalog`
  String get catalog {
    return Intl.message('Catalog', name: 'catalog', desc: '', args: []);
  }

  /// `Flowers`
  String get flowers {
    return Intl.message('Flowers', name: 'flowers', desc: '', args: []);
  }

  /// `History`
  String get detections {
    return Intl.message('History', name: 'detections', desc: '', args: []);
  }

  /// `Detection History`
  String get history {
    return Intl.message(
      'Detection History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Something went wrong. Please try again.`
  String get errorGeneric {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'errorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Check your connection.`
  String get errorNetwork {
    return Intl.message(
      'Network error. Check your connection.',
      name: 'errorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Not found`
  String get errorNotFound {
    return Intl.message('Not found', name: 'errorNotFound', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `How it works`
  String get howItWorks {
    return Intl.message('How it works', name: 'howItWorks', desc: '', args: []);
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `Import`
  String get import {
    return Intl.message('Import', name: 'import', desc: '', args: []);
  }

  /// `History`
  String get historySection {
    return Intl.message('History', name: 'historySection', desc: '', args: []);
  }

  /// `Scan bouquet`
  String get step1Title {
    return Intl.message('Scan bouquet', name: 'step1Title', desc: '', args: []);
  }

  /// `Take a photo of your bouquet or upload one from your gallery.`
  String get step1Text {
    return Intl.message(
      'Take a photo of your bouquet or upload one from your gallery.',
      name: 'step1Text',
      desc: '',
      args: [],
    );
  }

  /// `Flower recognition`
  String get step2Title {
    return Intl.message(
      'Flower recognition',
      name: 'step2Title',
      desc: '',
      args: [],
    );
  }

  /// `The model analyzes the photo and identifies all the flowers in the bouquet.`
  String get step2Text {
    return Intl.message(
      'The model analyzes the photo and identifies all the flowers in the bouquet.',
      name: 'step2Text',
      desc: '',
      args: [],
    );
  }

  /// `Explore flower details`
  String get step3Title {
    return Intl.message(
      'Explore flower details',
      name: 'step3Title',
      desc: '',
      args: [],
    );
  }

  /// `See flower names, confidence levels and learn more about every species.`
  String get step3Text {
    return Intl.message(
      'See flower names, confidence levels and learn more about every species.',
      name: 'step3Text',
      desc: '',
      args: [],
    );
  }

  /// `No detections yet. Take a photo of your bouquet to get started!`
  String get noDetectionsYet {
    return Intl.message(
      'No detections yet. Take a photo of your bouquet to get started!',
      name: 'noDetectionsYet',
      desc: '',
      args: [],
    );
  }

  /// `No gallery access. Enable in settings.`
  String get noGalleryAccess {
    return Intl.message(
      'No gallery access. Enable in settings.',
      name: 'noGalleryAccess',
      desc: '',
      args: [],
    );
  }

  /// `No camera access. Enable in settings.`
  String get noCameraAccess {
    return Intl.message(
      'No camera access. Enable in settings.',
      name: 'noCameraAccess',
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
      Locale.fromSubtags(languageCode: 'uk'),
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
