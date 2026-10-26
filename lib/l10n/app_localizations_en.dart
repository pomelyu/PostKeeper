// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navKeeper => 'Collection';

  @override
  String get navMap => 'Map';

  @override
  String get navSettings => 'Settings';

  @override
  String get textCommingSoon => 'Coming soon';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get mainTitle => 'My Postcards';

  @override
  String get mainSubtitle => 'Treasure every view you receive';

  @override
  String get mainAddPostcard => 'Add Postcard';

  @override
  String get mainRecentlyReceived => 'Recently Received';

  @override
  String get mainRecentlySent => 'Recently Sent';

  @override
  String get mainNoPostcards => 'No postcards yet';

  @override
  String get postcardTitle => 'Postcard';

  @override
  String get postcardEditImagesTitle => 'Postcard Images';

  @override
  String get postcardEditDetailsTitle => 'Postcard Details';

  @override
  String get postcardEditImagesStep => 'Images';

  @override
  String get postcardEditDetailsStep => 'Details';

  @override
  String get postcardEditSave => 'Save';

  @override
  String get postcardEditNext => 'Next';
}
