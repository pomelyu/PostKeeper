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

  /// No description provided for @mapAllCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get mapAllCountries;

  /// No description provided for @countryAD.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get countryAD;

  /// No description provided for @countryAE.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get countryAE;

  /// No description provided for @countryAF.
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get countryAF;

  /// No description provided for @countryAG.
  ///
  /// In en, this message translates to:
  /// **'Antigua & Barbuda'**
  String get countryAG;

  /// No description provided for @countryAI.
  ///
  /// In en, this message translates to:
  /// **'Anguilla'**
  String get countryAI;

  /// No description provided for @countryAL.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get countryAL;

  /// No description provided for @countryAM.
  ///
  /// In en, this message translates to:
  /// **'Armenia'**
  String get countryAM;

  /// No description provided for @countryAO.
  ///
  /// In en, this message translates to:
  /// **'Angola'**
  String get countryAO;

  /// No description provided for @countryAQ.
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get countryAQ;

  /// No description provided for @countryAR.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryAR;

  /// No description provided for @countryAS.
  ///
  /// In en, this message translates to:
  /// **'American Samoa'**
  String get countryAS;

  /// No description provided for @countryAT.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get countryAT;

  /// No description provided for @countryAU.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAU;

  /// No description provided for @countryAW.
  ///
  /// In en, this message translates to:
  /// **'Aruba'**
  String get countryAW;

  /// No description provided for @countryAX.
  ///
  /// In en, this message translates to:
  /// **'Åland Islands'**
  String get countryAX;

  /// No description provided for @countryAZ.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get countryAZ;

  /// No description provided for @countryBA.
  ///
  /// In en, this message translates to:
  /// **'Bosnia & Herzegovina'**
  String get countryBA;

  /// No description provided for @countryBB.
  ///
  /// In en, this message translates to:
  /// **'Barbados'**
  String get countryBB;

  /// No description provided for @countryBD.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBD;

  /// No description provided for @countryBE.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get countryBE;

  /// No description provided for @countryBF.
  ///
  /// In en, this message translates to:
  /// **'Burkina Faso'**
  String get countryBF;

  /// No description provided for @countryBG.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get countryBG;

  /// No description provided for @countryBH.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get countryBH;

  /// No description provided for @countryBI.
  ///
  /// In en, this message translates to:
  /// **'Burundi'**
  String get countryBI;

  /// No description provided for @countryBJ.
  ///
  /// In en, this message translates to:
  /// **'Benin'**
  String get countryBJ;

  /// No description provided for @countryBL.
  ///
  /// In en, this message translates to:
  /// **'St. Barthélemy'**
  String get countryBL;

  /// No description provided for @countryBM.
  ///
  /// In en, this message translates to:
  /// **'Bermuda'**
  String get countryBM;

  /// No description provided for @countryBN.
  ///
  /// In en, this message translates to:
  /// **'Brunei'**
  String get countryBN;

  /// No description provided for @countryBO.
  ///
  /// In en, this message translates to:
  /// **'Bolivia'**
  String get countryBO;

  /// No description provided for @countryBQ.
  ///
  /// In en, this message translates to:
  /// **'Caribbean Netherlands'**
  String get countryBQ;

  /// No description provided for @countryBR.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;

  /// No description provided for @countryBS.
  ///
  /// In en, this message translates to:
  /// **'Bahamas'**
  String get countryBS;

  /// No description provided for @countryBT.
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get countryBT;

  /// No description provided for @countryBV.
  ///
  /// In en, this message translates to:
  /// **'Bouvet Island'**
  String get countryBV;

  /// No description provided for @countryBW.
  ///
  /// In en, this message translates to:
  /// **'Botswana'**
  String get countryBW;

  /// No description provided for @countryBY.
  ///
  /// In en, this message translates to:
  /// **'Belarus'**
  String get countryBY;

  /// No description provided for @countryBZ.
  ///
  /// In en, this message translates to:
  /// **'Belize'**
  String get countryBZ;

  /// No description provided for @countryCA.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCA;

  /// No description provided for @countryCC.
  ///
  /// In en, this message translates to:
  /// **'Cocos (Keeling) Islands'**
  String get countryCC;

  /// No description provided for @countryCD.
  ///
  /// In en, this message translates to:
  /// **'Congo - Kinshasa'**
  String get countryCD;

  /// No description provided for @countryCF.
  ///
  /// In en, this message translates to:
  /// **'Central African Republic'**
  String get countryCF;

  /// No description provided for @countryCG.
  ///
  /// In en, this message translates to:
  /// **'Congo - Brazzaville'**
  String get countryCG;

  /// No description provided for @countryCH.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get countryCH;

  /// No description provided for @countryCI.
  ///
  /// In en, this message translates to:
  /// **'Côte d’Ivoire'**
  String get countryCI;

  /// No description provided for @countryCK.
  ///
  /// In en, this message translates to:
  /// **'Cook Islands'**
  String get countryCK;

  /// No description provided for @countryCL.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get countryCL;

  /// No description provided for @countryCM.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get countryCM;

  /// No description provided for @countryCN.
  ///
  /// In en, this message translates to:
  /// **'China mainland'**
  String get countryCN;

  /// No description provided for @countryCO.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get countryCO;

  /// No description provided for @countryCR.
  ///
  /// In en, this message translates to:
  /// **'Costa Rica'**
  String get countryCR;

  /// No description provided for @countryCU.
  ///
  /// In en, this message translates to:
  /// **'Cuba'**
  String get countryCU;

  /// No description provided for @countryCV.
  ///
  /// In en, this message translates to:
  /// **'Cape Verde'**
  String get countryCV;

  /// No description provided for @countryCW.
  ///
  /// In en, this message translates to:
  /// **'Curaçao'**
  String get countryCW;

  /// No description provided for @countryCX.
  ///
  /// In en, this message translates to:
  /// **'Christmas Island'**
  String get countryCX;

  /// No description provided for @countryCY.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get countryCY;

  /// No description provided for @countryCZ.
  ///
  /// In en, this message translates to:
  /// **'Czechia'**
  String get countryCZ;

  /// No description provided for @countryDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryDE;

  /// No description provided for @countryDJ.
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get countryDJ;

  /// No description provided for @countryDK.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get countryDK;

  /// No description provided for @countryDM.
  ///
  /// In en, this message translates to:
  /// **'Dominica'**
  String get countryDM;

  /// No description provided for @countryDO.
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get countryDO;

  /// No description provided for @countryDZ.
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get countryDZ;

  /// No description provided for @countryEC.
  ///
  /// In en, this message translates to:
  /// **'Ecuador'**
  String get countryEC;

  /// No description provided for @countryEE.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get countryEE;

  /// No description provided for @countryEG.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEG;

  /// No description provided for @countryEH.
  ///
  /// In en, this message translates to:
  /// **'Western Sahara'**
  String get countryEH;

  /// No description provided for @countryER.
  ///
  /// In en, this message translates to:
  /// **'Eritrea'**
  String get countryER;

  /// No description provided for @countryES.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countryES;

  /// No description provided for @countryET.
  ///
  /// In en, this message translates to:
  /// **'Ethiopia'**
  String get countryET;

  /// No description provided for @countryFI.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get countryFI;

  /// No description provided for @countryFJ.
  ///
  /// In en, this message translates to:
  /// **'Fiji'**
  String get countryFJ;

  /// No description provided for @countryFK.
  ///
  /// In en, this message translates to:
  /// **'Falkland Islands'**
  String get countryFK;

  /// No description provided for @countryFM.
  ///
  /// In en, this message translates to:
  /// **'Micronesia'**
  String get countryFM;

  /// No description provided for @countryFO.
  ///
  /// In en, this message translates to:
  /// **'Faroe Islands'**
  String get countryFO;

  /// No description provided for @countryFR.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFR;

  /// No description provided for @countryGA.
  ///
  /// In en, this message translates to:
  /// **'Gabon'**
  String get countryGA;

  /// No description provided for @countryGB.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryGB;

  /// No description provided for @countryGD.
  ///
  /// In en, this message translates to:
  /// **'Grenada'**
  String get countryGD;

  /// No description provided for @countryGE.
  ///
  /// In en, this message translates to:
  /// **'Georgia'**
  String get countryGE;

  /// No description provided for @countryGF.
  ///
  /// In en, this message translates to:
  /// **'French Guiana'**
  String get countryGF;

  /// No description provided for @countryGG.
  ///
  /// In en, this message translates to:
  /// **'Guernsey'**
  String get countryGG;

  /// No description provided for @countryGH.
  ///
  /// In en, this message translates to:
  /// **'Ghana'**
  String get countryGH;

  /// No description provided for @countryGI.
  ///
  /// In en, this message translates to:
  /// **'Gibraltar'**
  String get countryGI;

  /// No description provided for @countryGL.
  ///
  /// In en, this message translates to:
  /// **'Greenland'**
  String get countryGL;

  /// No description provided for @countryGM.
  ///
  /// In en, this message translates to:
  /// **'Gambia'**
  String get countryGM;

  /// No description provided for @countryGN.
  ///
  /// In en, this message translates to:
  /// **'Guinea'**
  String get countryGN;

  /// No description provided for @countryGP.
  ///
  /// In en, this message translates to:
  /// **'Guadeloupe'**
  String get countryGP;

  /// No description provided for @countryGQ.
  ///
  /// In en, this message translates to:
  /// **'Equatorial Guinea'**
  String get countryGQ;

  /// No description provided for @countryGR.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGR;

  /// No description provided for @countryGS.
  ///
  /// In en, this message translates to:
  /// **'So. Georgia & So. Sandwich Isl.'**
  String get countryGS;

  /// No description provided for @countryGT.
  ///
  /// In en, this message translates to:
  /// **'Guatemala'**
  String get countryGT;

  /// No description provided for @countryGU.
  ///
  /// In en, this message translates to:
  /// **'Guam'**
  String get countryGU;

  /// No description provided for @countryGW.
  ///
  /// In en, this message translates to:
  /// **'Guinea-Bissau'**
  String get countryGW;

  /// No description provided for @countryGY.
  ///
  /// In en, this message translates to:
  /// **'Guyana'**
  String get countryGY;

  /// No description provided for @countryHK.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get countryHK;

  /// No description provided for @countryHM.
  ///
  /// In en, this message translates to:
  /// **'Heard & McDonald Islands'**
  String get countryHM;

  /// No description provided for @countryHN.
  ///
  /// In en, this message translates to:
  /// **'Honduras'**
  String get countryHN;

  /// No description provided for @countryHR.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get countryHR;

  /// No description provided for @countryHT.
  ///
  /// In en, this message translates to:
  /// **'Haiti'**
  String get countryHT;

  /// No description provided for @countryHU.
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get countryHU;

  /// No description provided for @countryID.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryID;

  /// No description provided for @countryIE.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryIE;

  /// No description provided for @countryIL.
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get countryIL;

  /// No description provided for @countryIM.
  ///
  /// In en, this message translates to:
  /// **'Isle of Man'**
  String get countryIM;

  /// No description provided for @countryIN.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIN;

  /// No description provided for @countryIO.
  ///
  /// In en, this message translates to:
  /// **'Chagos Archipelago'**
  String get countryIO;

  /// No description provided for @countryIQ.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get countryIQ;

  /// No description provided for @countryIR.
  ///
  /// In en, this message translates to:
  /// **'Iran'**
  String get countryIR;

  /// No description provided for @countryIS.
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get countryIS;

  /// No description provided for @countryIT.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryIT;

  /// No description provided for @countryJE.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get countryJE;

  /// No description provided for @countryJM.
  ///
  /// In en, this message translates to:
  /// **'Jamaica'**
  String get countryJM;

  /// No description provided for @countryJO.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get countryJO;

  /// No description provided for @countryJP.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJP;

  /// No description provided for @countryKE.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get countryKE;

  /// No description provided for @countryKG.
  ///
  /// In en, this message translates to:
  /// **'Kyrgyzstan'**
  String get countryKG;

  /// No description provided for @countryKH.
  ///
  /// In en, this message translates to:
  /// **'Cambodia'**
  String get countryKH;

  /// No description provided for @countryKI.
  ///
  /// In en, this message translates to:
  /// **'Kiribati'**
  String get countryKI;

  /// No description provided for @countryKM.
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get countryKM;

  /// No description provided for @countryKN.
  ///
  /// In en, this message translates to:
  /// **'St. Kitts & Nevis'**
  String get countryKN;

  /// No description provided for @countryKP.
  ///
  /// In en, this message translates to:
  /// **'North Korea'**
  String get countryKP;

  /// No description provided for @countryKR.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countryKR;

  /// No description provided for @countryKW.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get countryKW;

  /// No description provided for @countryKY.
  ///
  /// In en, this message translates to:
  /// **'Cayman Islands'**
  String get countryKY;

  /// No description provided for @countryKZ.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get countryKZ;

  /// No description provided for @countryLA.
  ///
  /// In en, this message translates to:
  /// **'Laos'**
  String get countryLA;

  /// No description provided for @countryLB.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get countryLB;

  /// No description provided for @countryLC.
  ///
  /// In en, this message translates to:
  /// **'St. Lucia'**
  String get countryLC;

  /// No description provided for @countryLI.
  ///
  /// In en, this message translates to:
  /// **'Liechtenstein'**
  String get countryLI;

  /// No description provided for @countryLK.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countryLK;

  /// No description provided for @countryLR.
  ///
  /// In en, this message translates to:
  /// **'Liberia'**
  String get countryLR;

  /// No description provided for @countryLS.
  ///
  /// In en, this message translates to:
  /// **'Lesotho'**
  String get countryLS;

  /// No description provided for @countryLT.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get countryLT;

  /// No description provided for @countryLU.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get countryLU;

  /// No description provided for @countryLV.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get countryLV;

  /// No description provided for @countryLY.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get countryLY;

  /// No description provided for @countryMA.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get countryMA;

  /// No description provided for @countryMC.
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get countryMC;

  /// No description provided for @countryMD.
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get countryMD;

  /// No description provided for @countryME.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get countryME;

  /// No description provided for @countryMF.
  ///
  /// In en, this message translates to:
  /// **'St. Martin'**
  String get countryMF;

  /// No description provided for @countryMG.
  ///
  /// In en, this message translates to:
  /// **'Madagascar'**
  String get countryMG;

  /// No description provided for @countryMH.
  ///
  /// In en, this message translates to:
  /// **'Marshall Islands'**
  String get countryMH;

  /// No description provided for @countryMK.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get countryMK;

  /// No description provided for @countryML.
  ///
  /// In en, this message translates to:
  /// **'Mali'**
  String get countryML;

  /// No description provided for @countryMM.
  ///
  /// In en, this message translates to:
  /// **'Myanmar (Burma)'**
  String get countryMM;

  /// No description provided for @countryMN.
  ///
  /// In en, this message translates to:
  /// **'Mongolia'**
  String get countryMN;

  /// No description provided for @countryMO.
  ///
  /// In en, this message translates to:
  /// **'Macao'**
  String get countryMO;

  /// No description provided for @countryMP.
  ///
  /// In en, this message translates to:
  /// **'Northern Mariana Islands'**
  String get countryMP;

  /// No description provided for @countryMQ.
  ///
  /// In en, this message translates to:
  /// **'Martinique'**
  String get countryMQ;

  /// No description provided for @countryMR.
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get countryMR;

  /// No description provided for @countryMS.
  ///
  /// In en, this message translates to:
  /// **'Montserrat'**
  String get countryMS;

  /// No description provided for @countryMT.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get countryMT;

  /// No description provided for @countryMU.
  ///
  /// In en, this message translates to:
  /// **'Mauritius'**
  String get countryMU;

  /// No description provided for @countryMV.
  ///
  /// In en, this message translates to:
  /// **'Maldives'**
  String get countryMV;

  /// No description provided for @countryMW.
  ///
  /// In en, this message translates to:
  /// **'Malawi'**
  String get countryMW;

  /// No description provided for @countryMX.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMX;

  /// No description provided for @countryMY.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get countryMY;

  /// No description provided for @countryMZ.
  ///
  /// In en, this message translates to:
  /// **'Mozambique'**
  String get countryMZ;

  /// No description provided for @countryNA.
  ///
  /// In en, this message translates to:
  /// **'Namibia'**
  String get countryNA;

  /// No description provided for @countryNC.
  ///
  /// In en, this message translates to:
  /// **'New Caledonia'**
  String get countryNC;

  /// No description provided for @countryNE.
  ///
  /// In en, this message translates to:
  /// **'Niger'**
  String get countryNE;

  /// No description provided for @countryNF.
  ///
  /// In en, this message translates to:
  /// **'Norfolk Island'**
  String get countryNF;

  /// No description provided for @countryNG.
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get countryNG;

  /// No description provided for @countryNI.
  ///
  /// In en, this message translates to:
  /// **'Nicaragua'**
  String get countryNI;

  /// No description provided for @countryNL.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNL;

  /// No description provided for @countryNO.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get countryNO;

  /// No description provided for @countryNP.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNP;

  /// No description provided for @countryNR.
  ///
  /// In en, this message translates to:
  /// **'Nauru'**
  String get countryNR;

  /// No description provided for @countryNU.
  ///
  /// In en, this message translates to:
  /// **'Niue'**
  String get countryNU;

  /// No description provided for @countryNZ.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get countryNZ;

  /// No description provided for @countryOM.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get countryOM;

  /// No description provided for @countryPA.
  ///
  /// In en, this message translates to:
  /// **'Panama'**
  String get countryPA;

  /// No description provided for @countryPE.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPE;

  /// No description provided for @countryPF.
  ///
  /// In en, this message translates to:
  /// **'French Polynesia'**
  String get countryPF;

  /// No description provided for @countryPG.
  ///
  /// In en, this message translates to:
  /// **'Papua New Guinea'**
  String get countryPG;

  /// No description provided for @countryPH.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPH;

  /// No description provided for @countryPK.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPK;

  /// No description provided for @countryPL.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get countryPL;

  /// No description provided for @countryPM.
  ///
  /// In en, this message translates to:
  /// **'St. Pierre & Miquelon'**
  String get countryPM;

  /// No description provided for @countryPN.
  ///
  /// In en, this message translates to:
  /// **'Pitcairn Islands'**
  String get countryPN;

  /// No description provided for @countryPR.
  ///
  /// In en, this message translates to:
  /// **'Puerto Rico'**
  String get countryPR;

  /// No description provided for @countryPS.
  ///
  /// In en, this message translates to:
  /// **'Palestinian Territories'**
  String get countryPS;

  /// No description provided for @countryPT.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryPT;

  /// No description provided for @countryPW.
  ///
  /// In en, this message translates to:
  /// **'Palau'**
  String get countryPW;

  /// No description provided for @countryPY.
  ///
  /// In en, this message translates to:
  /// **'Paraguay'**
  String get countryPY;

  /// No description provided for @countryQA.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get countryQA;

  /// No description provided for @countryRE.
  ///
  /// In en, this message translates to:
  /// **'Réunion'**
  String get countryRE;

  /// No description provided for @countryRO.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRO;

  /// No description provided for @countryRS.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get countryRS;

  /// No description provided for @countryRU.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRU;

  /// No description provided for @countryRW.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get countryRW;

  /// No description provided for @countrySA.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get countrySA;

  /// No description provided for @countrySB.
  ///
  /// In en, this message translates to:
  /// **'Solomon Islands'**
  String get countrySB;

  /// No description provided for @countrySC.
  ///
  /// In en, this message translates to:
  /// **'Seychelles'**
  String get countrySC;

  /// No description provided for @countrySD.
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get countrySD;

  /// No description provided for @countrySE.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get countrySE;

  /// No description provided for @countrySG.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get countrySG;

  /// No description provided for @countrySH.
  ///
  /// In en, this message translates to:
  /// **'St. Helena'**
  String get countrySH;

  /// No description provided for @countrySI.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countrySI;

  /// No description provided for @countrySJ.
  ///
  /// In en, this message translates to:
  /// **'Svalbard & Jan Mayen'**
  String get countrySJ;

  /// No description provided for @countrySK.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get countrySK;

  /// No description provided for @countrySL.
  ///
  /// In en, this message translates to:
  /// **'Sierra Leone'**
  String get countrySL;

  /// No description provided for @countrySM.
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get countrySM;

  /// No description provided for @countrySN.
  ///
  /// In en, this message translates to:
  /// **'Senegal'**
  String get countrySN;

  /// No description provided for @countrySO.
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get countrySO;

  /// No description provided for @countrySR.
  ///
  /// In en, this message translates to:
  /// **'Suriname'**
  String get countrySR;

  /// No description provided for @countrySS.
  ///
  /// In en, this message translates to:
  /// **'South Sudan'**
  String get countrySS;

  /// No description provided for @countryST.
  ///
  /// In en, this message translates to:
  /// **'São Tomé & Príncipe'**
  String get countryST;

  /// No description provided for @countrySV.
  ///
  /// In en, this message translates to:
  /// **'El Salvador'**
  String get countrySV;

  /// No description provided for @countrySX.
  ///
  /// In en, this message translates to:
  /// **'Sint Maarten'**
  String get countrySX;

  /// No description provided for @countrySY.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get countrySY;

  /// No description provided for @countrySZ.
  ///
  /// In en, this message translates to:
  /// **'Eswatini'**
  String get countrySZ;

  /// No description provided for @countryTC.
  ///
  /// In en, this message translates to:
  /// **'Turks & Caicos Islands'**
  String get countryTC;

  /// No description provided for @countryTD.
  ///
  /// In en, this message translates to:
  /// **'Chad'**
  String get countryTD;

  /// No description provided for @countryTF.
  ///
  /// In en, this message translates to:
  /// **'French Southern Territories'**
  String get countryTF;

  /// No description provided for @countryTG.
  ///
  /// In en, this message translates to:
  /// **'Togo'**
  String get countryTG;

  /// No description provided for @countryTH.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryTH;

  /// No description provided for @countryTJ.
  ///
  /// In en, this message translates to:
  /// **'Tajikistan'**
  String get countryTJ;

  /// No description provided for @countryTK.
  ///
  /// In en, this message translates to:
  /// **'Tokelau'**
  String get countryTK;

  /// No description provided for @countryTL.
  ///
  /// In en, this message translates to:
  /// **'Timor-Leste'**
  String get countryTL;

  /// No description provided for @countryTM.
  ///
  /// In en, this message translates to:
  /// **'Turkmenistan'**
  String get countryTM;

  /// No description provided for @countryTN.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get countryTN;

  /// No description provided for @countryTO.
  ///
  /// In en, this message translates to:
  /// **'Tonga'**
  String get countryTO;

  /// No description provided for @countryTR.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get countryTR;

  /// No description provided for @countryTT.
  ///
  /// In en, this message translates to:
  /// **'Trinidad & Tobago'**
  String get countryTT;

  /// No description provided for @countryTV.
  ///
  /// In en, this message translates to:
  /// **'Tuvalu'**
  String get countryTV;

  /// No description provided for @countryTW.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get countryTW;

  /// No description provided for @countryTZ.
  ///
  /// In en, this message translates to:
  /// **'Tanzania'**
  String get countryTZ;

  /// No description provided for @countryUA.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get countryUA;

  /// No description provided for @countryUG.
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get countryUG;

  /// No description provided for @countryUM.
  ///
  /// In en, this message translates to:
  /// **'U.S. Outlying Islands'**
  String get countryUM;

  /// No description provided for @countryUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// No description provided for @countryUY.
  ///
  /// In en, this message translates to:
  /// **'Uruguay'**
  String get countryUY;

  /// No description provided for @countryUZ.
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get countryUZ;

  /// No description provided for @countryVA.
  ///
  /// In en, this message translates to:
  /// **'Vatican City'**
  String get countryVA;

  /// No description provided for @countryVC.
  ///
  /// In en, this message translates to:
  /// **'St. Vincent & Grenadines'**
  String get countryVC;

  /// No description provided for @countryVE.
  ///
  /// In en, this message translates to:
  /// **'Venezuela'**
  String get countryVE;

  /// No description provided for @countryVG.
  ///
  /// In en, this message translates to:
  /// **'British Virgin Islands'**
  String get countryVG;

  /// No description provided for @countryVI.
  ///
  /// In en, this message translates to:
  /// **'U.S. Virgin Islands'**
  String get countryVI;

  /// No description provided for @countryVN.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get countryVN;

  /// No description provided for @countryVU.
  ///
  /// In en, this message translates to:
  /// **'Vanuatu'**
  String get countryVU;

  /// No description provided for @countryWF.
  ///
  /// In en, this message translates to:
  /// **'Wallis & Futuna'**
  String get countryWF;

  /// No description provided for @countryWS.
  ///
  /// In en, this message translates to:
  /// **'Samoa'**
  String get countryWS;

  /// No description provided for @countryYE.
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get countryYE;

  /// No description provided for @countryYT.
  ///
  /// In en, this message translates to:
  /// **'Mayotte'**
  String get countryYT;

  /// No description provided for @countryZA.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get countryZA;

  /// No description provided for @countryZM.
  ///
  /// In en, this message translates to:
  /// **'Zambia'**
  String get countryZM;

  /// No description provided for @countryZW.
  ///
  /// In en, this message translates to:
  /// **'Zimbabwe'**
  String get countryZW;
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
