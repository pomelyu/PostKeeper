import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('zh'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navKeeper.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navKeeper;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get navUser;

  /// No description provided for @textCommingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get textCommingSoon;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @mainTitle.
  ///
  /// In en, this message translates to:
  /// **'My Postcards'**
  String get mainTitle;

  /// No description provided for @mainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Treasure every view you receive'**
  String get mainSubtitle;

  /// No description provided for @mainAddPostcard.
  ///
  /// In en, this message translates to:
  /// **'Scan Postcard'**
  String get mainAddPostcard;

  /// No description provided for @mainRecentlyReceived.
  ///
  /// In en, this message translates to:
  /// **'Recently Received'**
  String get mainRecentlyReceived;

  /// No description provided for @mainRecentlySent.
  ///
  /// In en, this message translates to:
  /// **'Recently Sent'**
  String get mainRecentlySent;

  /// No description provided for @mainNoPostcards.
  ///
  /// In en, this message translates to:
  /// **'No postcards yet'**
  String get mainNoPostcards;

  /// No description provided for @postcardTitle.
  ///
  /// In en, this message translates to:
  /// **'Postcard'**
  String get postcardTitle;

  /// No description provided for @postcardEditImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Postcard Images'**
  String get postcardEditImagesTitle;

  /// No description provided for @postcardEditDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Postcard Details'**
  String get postcardEditDetailsTitle;

  /// No description provided for @postcardEditImagesStep.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get postcardEditImagesStep;

  /// No description provided for @postcardEditDetailsStep.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get postcardEditDetailsStep;

  /// No description provided for @postcardEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get postcardEditSave;

  /// No description provided for @postcardEditNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get postcardEditNext;

  /// No description provided for @geoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get geoUnknown;

  /// No description provided for @geoAfrica.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get geoAfrica;

  /// No description provided for @geoAmericas.
  ///
  /// In en, this message translates to:
  /// **'Americas'**
  String get geoAmericas;

  /// No description provided for @geoAsia.
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get geoAsia;

  /// No description provided for @geoEurope.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get geoEurope;

  /// No description provided for @geoOceania.
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get geoOceania;

  /// No description provided for @geoEasternAfrica.
  ///
  /// In en, this message translates to:
  /// **'Eastern Africa'**
  String get geoEasternAfrica;

  /// No description provided for @geoMiddleAfrica.
  ///
  /// In en, this message translates to:
  /// **'Middle Africa'**
  String get geoMiddleAfrica;

  /// No description provided for @geoNorthernAfrica.
  ///
  /// In en, this message translates to:
  /// **'Northern Africa'**
  String get geoNorthernAfrica;

  /// No description provided for @geoSouthernAfrica.
  ///
  /// In en, this message translates to:
  /// **'Southern Africa'**
  String get geoSouthernAfrica;

  /// No description provided for @geoWesternAfrica.
  ///
  /// In en, this message translates to:
  /// **'Western Africa'**
  String get geoWesternAfrica;

  /// No description provided for @geoCaribbean.
  ///
  /// In en, this message translates to:
  /// **'Caribbean'**
  String get geoCaribbean;

  /// No description provided for @geoCentralAmerica.
  ///
  /// In en, this message translates to:
  /// **'Central America'**
  String get geoCentralAmerica;

  /// No description provided for @geoSouthAmerica.
  ///
  /// In en, this message translates to:
  /// **'South America'**
  String get geoSouthAmerica;

  /// No description provided for @geoNorthernAmerica.
  ///
  /// In en, this message translates to:
  /// **'Northern America'**
  String get geoNorthernAmerica;

  /// No description provided for @geoCentralAsia.
  ///
  /// In en, this message translates to:
  /// **'Central Asia'**
  String get geoCentralAsia;

  /// No description provided for @geoEasternAsia.
  ///
  /// In en, this message translates to:
  /// **'Eastern Asia'**
  String get geoEasternAsia;

  /// No description provided for @geoSouthernAsia.
  ///
  /// In en, this message translates to:
  /// **'Southern Asia'**
  String get geoSouthernAsia;

  /// No description provided for @geoSouthEasternAsia.
  ///
  /// In en, this message translates to:
  /// **'South-Eastern Asia'**
  String get geoSouthEasternAsia;

  /// No description provided for @geoWesternAsia.
  ///
  /// In en, this message translates to:
  /// **'Western Asia'**
  String get geoWesternAsia;

  /// No description provided for @geoEasternEurope.
  ///
  /// In en, this message translates to:
  /// **'Eastern Europe'**
  String get geoEasternEurope;

  /// No description provided for @geoNorthernEurope.
  ///
  /// In en, this message translates to:
  /// **'Northern Europe'**
  String get geoNorthernEurope;

  /// No description provided for @geoSouthernEurope.
  ///
  /// In en, this message translates to:
  /// **'Southern Europe'**
  String get geoSouthernEurope;

  /// No description provided for @geoWesternEurope.
  ///
  /// In en, this message translates to:
  /// **'Western Europe'**
  String get geoWesternEurope;

  /// No description provided for @geoAustraliaNewZealand.
  ///
  /// In en, this message translates to:
  /// **'Australia and New Zealand'**
  String get geoAustraliaNewZealand;

  /// No description provided for @geoMelanesia.
  ///
  /// In en, this message translates to:
  /// **'Melanesia'**
  String get geoMelanesia;

  /// No description provided for @geoMicronesia.
  ///
  /// In en, this message translates to:
  /// **'Micronesia'**
  String get geoMicronesia;

  /// No description provided for @geoPolynesia.
  ///
  /// In en, this message translates to:
  /// **'Polynesia'**
  String get geoPolynesia;

  /// No description provided for @keeperTitle.
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get keeperTitle;

  /// No description provided for @keeperSearch.
  ///
  /// In en, this message translates to:
  /// **'Search collections'**
  String get keeperSearch;

  /// No description provided for @keeperRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get keeperRegion;

  /// No description provided for @keeperYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get keeperYear;

  /// No description provided for @keeperCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get keeperCollections;

  /// No description provided for @keeperFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get keeperFavorite;

  /// No description provided for @keeperReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get keeperReceived;

  /// No description provided for @keeperSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get keeperSent;

  /// No description provided for @keeperCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 postcard} other{{count} postcards}}'**
  String keeperCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
