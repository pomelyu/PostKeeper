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
  String get navUser => 'User';

  @override
  String get textCommingSoon => 'Coming soon';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get mainTitle => 'My Postcards';

  @override
  String get mainSubtitle => 'Treasure every view you receive';

  @override
  String get mainAddPostcard => 'Scan Postcard';

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

  @override
  String get geoUnknown => 'Unknown';

  @override
  String get geoAfrica => 'Africa';

  @override
  String get geoAmericas => 'Americas';

  @override
  String get geoAsia => 'Asia';

  @override
  String get geoEurope => 'Europe';

  @override
  String get geoOceania => 'Oceania';

  @override
  String get geoEasternAfrica => 'Eastern Africa';

  @override
  String get geoMiddleAfrica => 'Middle Africa';

  @override
  String get geoNorthernAfrica => 'Northern Africa';

  @override
  String get geoSouthernAfrica => 'Southern Africa';

  @override
  String get geoWesternAfrica => 'Western Africa';

  @override
  String get geoCaribbean => 'Caribbean';

  @override
  String get geoCentralAmerica => 'Central America';

  @override
  String get geoSouthAmerica => 'South America';

  @override
  String get geoNorthernAmerica => 'Northern America';

  @override
  String get geoCentralAsia => 'Central Asia';

  @override
  String get geoEasternAsia => 'Eastern Asia';

  @override
  String get geoSouthernAsia => 'Southern Asia';

  @override
  String get geoSouthEasternAsia => 'South-Eastern Asia';

  @override
  String get geoWesternAsia => 'Western Asia';

  @override
  String get geoEasternEurope => 'Eastern Europe';

  @override
  String get geoNorthernEurope => 'Northern Europe';

  @override
  String get geoSouthernEurope => 'Southern Europe';

  @override
  String get geoWesternEurope => 'Western Europe';

  @override
  String get geoAustraliaNewZealand => 'Australia and New Zealand';

  @override
  String get geoMelanesia => 'Melanesia';

  @override
  String get geoMicronesia => 'Micronesia';

  @override
  String get geoPolynesia => 'Polynesia';

  @override
  String get keeperTitle => 'My Collection';

  @override
  String get keeperSearch => 'Search collections';

  @override
  String get keeperRegion => 'Region';

  @override
  String get keeperYear => 'Year';

  @override
  String get keeperCollections => 'Collections';

  @override
  String get keeperFavorite => 'Favorites';

  @override
  String get keeperReceived => 'Received';

  @override
  String get keeperSent => 'Sent';

  @override
  String keeperCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postcards',
      one: '1 postcard',
    );
    return '$_temp0';
  }
}
