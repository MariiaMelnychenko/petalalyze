// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Petalalyze';

  @override
  String get home => 'Home';

  @override
  String get homeTitle =>
      'Scan your bouquet and find out what flowers are in it ❀ ';

  @override
  String get catalog => 'Catalog';

  @override
  String get flowers => 'Flowers';

  @override
  String get detections => 'History';

  @override
  String get history => 'Detection History';

  @override
  String get settings => 'Settings';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Network error. Check your connection.';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get search => 'Search...';

  @override
  String get howItWorks => 'How it works';

  @override
  String get photo => 'Photo';

  @override
  String get import => 'Import';

  @override
  String get historySection => 'History';

  @override
  String get step1Title => 'Scan bouquet';

  @override
  String get step1Text =>
      'Take a photo of your bouquet or upload one from your gallery.';

  @override
  String get step2Title => 'Flower recognition';

  @override
  String get step2Text =>
      'The model analyzes the photo and identifies all the flowers in the bouquet.';

  @override
  String get step3Title => 'Explore flower details';

  @override
  String get step3Text =>
      'See flower names, confidence levels and learn more about every species.';

  @override
  String get noDetectionsYet =>
      'No detections yet. Take a photo of your bouquet to get started!';
}
