// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appTitle": MessageLookupByLibrary.simpleMessage("Petalalyze"),
    "catalog": MessageLookupByLibrary.simpleMessage("Catalog"),
    "detections": MessageLookupByLibrary.simpleMessage("History"),
    "errorGeneric": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "Network error. Check your connection.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Not found"),
    "flowers": MessageLookupByLibrary.simpleMessage("Flowers"),
    "history": MessageLookupByLibrary.simpleMessage("Detection History"),
    "historySection": MessageLookupByLibrary.simpleMessage("History"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeTitle": MessageLookupByLibrary.simpleMessage(
      "Scan your bouquet and find out what flowers are in it ❀ ",
    ),
    "howItWorks": MessageLookupByLibrary.simpleMessage("How it works"),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "noCameraAccess": MessageLookupByLibrary.simpleMessage(
      "No camera access. Enable in settings.",
    ),
    "noDetectionsYet": MessageLookupByLibrary.simpleMessage(
      "No detections yet. Take a photo of your bouquet to get started!",
    ),
    "noGalleryAccess": MessageLookupByLibrary.simpleMessage(
      "No gallery access. Enable in settings.",
    ),
    "photo": MessageLookupByLibrary.simpleMessage("Photo"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "search": MessageLookupByLibrary.simpleMessage("Search..."),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "step1Text": MessageLookupByLibrary.simpleMessage(
      "Take a photo of your bouquet or upload one from your gallery.",
    ),
    "step1Title": MessageLookupByLibrary.simpleMessage("Scan bouquet"),
    "step2Text": MessageLookupByLibrary.simpleMessage(
      "The model analyzes the photo and identifies all the flowers in the bouquet.",
    ),
    "step2Title": MessageLookupByLibrary.simpleMessage("Flower recognition"),
    "step3Text": MessageLookupByLibrary.simpleMessage(
      "See flower names, confidence levels and learn more about every species.",
    ),
    "step3Title": MessageLookupByLibrary.simpleMessage(
      "Explore flower details",
    ),
  };
}
