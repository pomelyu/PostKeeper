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

  @override
  String get mapAllCountries => 'All countries';

  @override
  String get countryAD => 'Andorra';

  @override
  String get countryAE => 'United Arab Emirates';

  @override
  String get countryAF => 'Afghanistan';

  @override
  String get countryAG => 'Antigua & Barbuda';

  @override
  String get countryAI => 'Anguilla';

  @override
  String get countryAL => 'Albania';

  @override
  String get countryAM => 'Armenia';

  @override
  String get countryAO => 'Angola';

  @override
  String get countryAQ => 'Antarctica';

  @override
  String get countryAR => 'Argentina';

  @override
  String get countryAS => 'American Samoa';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryAU => 'Australia';

  @override
  String get countryAW => 'Aruba';

  @override
  String get countryAX => 'Åland Islands';

  @override
  String get countryAZ => 'Azerbaijan';

  @override
  String get countryBA => 'Bosnia & Herzegovina';

  @override
  String get countryBB => 'Barbados';

  @override
  String get countryBD => 'Bangladesh';

  @override
  String get countryBE => 'Belgium';

  @override
  String get countryBF => 'Burkina Faso';

  @override
  String get countryBG => 'Bulgaria';

  @override
  String get countryBH => 'Bahrain';

  @override
  String get countryBI => 'Burundi';

  @override
  String get countryBJ => 'Benin';

  @override
  String get countryBL => 'St. Barthélemy';

  @override
  String get countryBM => 'Bermuda';

  @override
  String get countryBN => 'Brunei';

  @override
  String get countryBO => 'Bolivia';

  @override
  String get countryBQ => 'Caribbean Netherlands';

  @override
  String get countryBR => 'Brazil';

  @override
  String get countryBS => 'Bahamas';

  @override
  String get countryBT => 'Bhutan';

  @override
  String get countryBV => 'Bouvet Island';

  @override
  String get countryBW => 'Botswana';

  @override
  String get countryBY => 'Belarus';

  @override
  String get countryBZ => 'Belize';

  @override
  String get countryCA => 'Canada';

  @override
  String get countryCC => 'Cocos (Keeling) Islands';

  @override
  String get countryCD => 'Congo - Kinshasa';

  @override
  String get countryCF => 'Central African Republic';

  @override
  String get countryCG => 'Congo - Brazzaville';

  @override
  String get countryCH => 'Switzerland';

  @override
  String get countryCI => 'Côte d’Ivoire';

  @override
  String get countryCK => 'Cook Islands';

  @override
  String get countryCL => 'Chile';

  @override
  String get countryCM => 'Cameroon';

  @override
  String get countryCN => 'China mainland';

  @override
  String get countryCO => 'Colombia';

  @override
  String get countryCR => 'Costa Rica';

  @override
  String get countryCU => 'Cuba';

  @override
  String get countryCV => 'Cape Verde';

  @override
  String get countryCW => 'Curaçao';

  @override
  String get countryCX => 'Christmas Island';

  @override
  String get countryCY => 'Cyprus';

  @override
  String get countryCZ => 'Czechia';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryDJ => 'Djibouti';

  @override
  String get countryDK => 'Denmark';

  @override
  String get countryDM => 'Dominica';

  @override
  String get countryDO => 'Dominican Republic';

  @override
  String get countryDZ => 'Algeria';

  @override
  String get countryEC => 'Ecuador';

  @override
  String get countryEE => 'Estonia';

  @override
  String get countryEG => 'Egypt';

  @override
  String get countryEH => 'Western Sahara';

  @override
  String get countryER => 'Eritrea';

  @override
  String get countryES => 'Spain';

  @override
  String get countryET => 'Ethiopia';

  @override
  String get countryFI => 'Finland';

  @override
  String get countryFJ => 'Fiji';

  @override
  String get countryFK => 'Falkland Islands';

  @override
  String get countryFM => 'Micronesia';

  @override
  String get countryFO => 'Faroe Islands';

  @override
  String get countryFR => 'France';

  @override
  String get countryGA => 'Gabon';

  @override
  String get countryGB => 'United Kingdom';

  @override
  String get countryGD => 'Grenada';

  @override
  String get countryGE => 'Georgia';

  @override
  String get countryGF => 'French Guiana';

  @override
  String get countryGG => 'Guernsey';

  @override
  String get countryGH => 'Ghana';

  @override
  String get countryGI => 'Gibraltar';

  @override
  String get countryGL => 'Greenland';

  @override
  String get countryGM => 'Gambia';

  @override
  String get countryGN => 'Guinea';

  @override
  String get countryGP => 'Guadeloupe';

  @override
  String get countryGQ => 'Equatorial Guinea';

  @override
  String get countryGR => 'Greece';

  @override
  String get countryGS => 'So. Georgia & So. Sandwich Isl.';

  @override
  String get countryGT => 'Guatemala';

  @override
  String get countryGU => 'Guam';

  @override
  String get countryGW => 'Guinea-Bissau';

  @override
  String get countryGY => 'Guyana';

  @override
  String get countryHK => 'Hong Kong';

  @override
  String get countryHM => 'Heard & McDonald Islands';

  @override
  String get countryHN => 'Honduras';

  @override
  String get countryHR => 'Croatia';

  @override
  String get countryHT => 'Haiti';

  @override
  String get countryHU => 'Hungary';

  @override
  String get countryID => 'Indonesia';

  @override
  String get countryIE => 'Ireland';

  @override
  String get countryIL => 'Israel';

  @override
  String get countryIM => 'Isle of Man';

  @override
  String get countryIN => 'India';

  @override
  String get countryIO => 'Chagos Archipelago';

  @override
  String get countryIQ => 'Iraq';

  @override
  String get countryIR => 'Iran';

  @override
  String get countryIS => 'Iceland';

  @override
  String get countryIT => 'Italy';

  @override
  String get countryJE => 'Jersey';

  @override
  String get countryJM => 'Jamaica';

  @override
  String get countryJO => 'Jordan';

  @override
  String get countryJP => 'Japan';

  @override
  String get countryKE => 'Kenya';

  @override
  String get countryKG => 'Kyrgyzstan';

  @override
  String get countryKH => 'Cambodia';

  @override
  String get countryKI => 'Kiribati';

  @override
  String get countryKM => 'Comoros';

  @override
  String get countryKN => 'St. Kitts & Nevis';

  @override
  String get countryKP => 'North Korea';

  @override
  String get countryKR => 'South Korea';

  @override
  String get countryKW => 'Kuwait';

  @override
  String get countryKY => 'Cayman Islands';

  @override
  String get countryKZ => 'Kazakhstan';

  @override
  String get countryLA => 'Laos';

  @override
  String get countryLB => 'Lebanon';

  @override
  String get countryLC => 'St. Lucia';

  @override
  String get countryLI => 'Liechtenstein';

  @override
  String get countryLK => 'Sri Lanka';

  @override
  String get countryLR => 'Liberia';

  @override
  String get countryLS => 'Lesotho';

  @override
  String get countryLT => 'Lithuania';

  @override
  String get countryLU => 'Luxembourg';

  @override
  String get countryLV => 'Latvia';

  @override
  String get countryLY => 'Libya';

  @override
  String get countryMA => 'Morocco';

  @override
  String get countryMC => 'Monaco';

  @override
  String get countryMD => 'Moldova';

  @override
  String get countryME => 'Montenegro';

  @override
  String get countryMF => 'St. Martin';

  @override
  String get countryMG => 'Madagascar';

  @override
  String get countryMH => 'Marshall Islands';

  @override
  String get countryMK => 'North Macedonia';

  @override
  String get countryML => 'Mali';

  @override
  String get countryMM => 'Myanmar (Burma)';

  @override
  String get countryMN => 'Mongolia';

  @override
  String get countryMO => 'Macao';

  @override
  String get countryMP => 'Northern Mariana Islands';

  @override
  String get countryMQ => 'Martinique';

  @override
  String get countryMR => 'Mauritania';

  @override
  String get countryMS => 'Montserrat';

  @override
  String get countryMT => 'Malta';

  @override
  String get countryMU => 'Mauritius';

  @override
  String get countryMV => 'Maldives';

  @override
  String get countryMW => 'Malawi';

  @override
  String get countryMX => 'Mexico';

  @override
  String get countryMY => 'Malaysia';

  @override
  String get countryMZ => 'Mozambique';

  @override
  String get countryNA => 'Namibia';

  @override
  String get countryNC => 'New Caledonia';

  @override
  String get countryNE => 'Niger';

  @override
  String get countryNF => 'Norfolk Island';

  @override
  String get countryNG => 'Nigeria';

  @override
  String get countryNI => 'Nicaragua';

  @override
  String get countryNL => 'Netherlands';

  @override
  String get countryNO => 'Norway';

  @override
  String get countryNP => 'Nepal';

  @override
  String get countryNR => 'Nauru';

  @override
  String get countryNU => 'Niue';

  @override
  String get countryNZ => 'New Zealand';

  @override
  String get countryOM => 'Oman';

  @override
  String get countryPA => 'Panama';

  @override
  String get countryPE => 'Peru';

  @override
  String get countryPF => 'French Polynesia';

  @override
  String get countryPG => 'Papua New Guinea';

  @override
  String get countryPH => 'Philippines';

  @override
  String get countryPK => 'Pakistan';

  @override
  String get countryPL => 'Poland';

  @override
  String get countryPM => 'St. Pierre & Miquelon';

  @override
  String get countryPN => 'Pitcairn Islands';

  @override
  String get countryPR => 'Puerto Rico';

  @override
  String get countryPS => 'Palestinian Territories';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryPW => 'Palau';

  @override
  String get countryPY => 'Paraguay';

  @override
  String get countryQA => 'Qatar';

  @override
  String get countryRE => 'Réunion';

  @override
  String get countryRO => 'Romania';

  @override
  String get countryRS => 'Serbia';

  @override
  String get countryRU => 'Russia';

  @override
  String get countryRW => 'Rwanda';

  @override
  String get countrySA => 'Saudi Arabia';

  @override
  String get countrySB => 'Solomon Islands';

  @override
  String get countrySC => 'Seychelles';

  @override
  String get countrySD => 'Sudan';

  @override
  String get countrySE => 'Sweden';

  @override
  String get countrySG => 'Singapore';

  @override
  String get countrySH => 'St. Helena';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countrySJ => 'Svalbard & Jan Mayen';

  @override
  String get countrySK => 'Slovakia';

  @override
  String get countrySL => 'Sierra Leone';

  @override
  String get countrySM => 'San Marino';

  @override
  String get countrySN => 'Senegal';

  @override
  String get countrySO => 'Somalia';

  @override
  String get countrySR => 'Suriname';

  @override
  String get countrySS => 'South Sudan';

  @override
  String get countryST => 'São Tomé & Príncipe';

  @override
  String get countrySV => 'El Salvador';

  @override
  String get countrySX => 'Sint Maarten';

  @override
  String get countrySY => 'Syria';

  @override
  String get countrySZ => 'Eswatini';

  @override
  String get countryTC => 'Turks & Caicos Islands';

  @override
  String get countryTD => 'Chad';

  @override
  String get countryTF => 'French Southern Territories';

  @override
  String get countryTG => 'Togo';

  @override
  String get countryTH => 'Thailand';

  @override
  String get countryTJ => 'Tajikistan';

  @override
  String get countryTK => 'Tokelau';

  @override
  String get countryTL => 'Timor-Leste';

  @override
  String get countryTM => 'Turkmenistan';

  @override
  String get countryTN => 'Tunisia';

  @override
  String get countryTO => 'Tonga';

  @override
  String get countryTR => 'Türkiye';

  @override
  String get countryTT => 'Trinidad & Tobago';

  @override
  String get countryTV => 'Tuvalu';

  @override
  String get countryTW => 'Taiwan';

  @override
  String get countryTZ => 'Tanzania';

  @override
  String get countryUA => 'Ukraine';

  @override
  String get countryUG => 'Uganda';

  @override
  String get countryUM => 'U.S. Outlying Islands';

  @override
  String get countryUS => 'United States';

  @override
  String get countryUY => 'Uruguay';

  @override
  String get countryUZ => 'Uzbekistan';

  @override
  String get countryVA => 'Vatican City';

  @override
  String get countryVC => 'St. Vincent & Grenadines';

  @override
  String get countryVE => 'Venezuela';

  @override
  String get countryVG => 'British Virgin Islands';

  @override
  String get countryVI => 'U.S. Virgin Islands';

  @override
  String get countryVN => 'Vietnam';

  @override
  String get countryVU => 'Vanuatu';

  @override
  String get countryWF => 'Wallis & Futuna';

  @override
  String get countryWS => 'Samoa';

  @override
  String get countryYE => 'Yemen';

  @override
  String get countryYT => 'Mayotte';

  @override
  String get countryZA => 'South Africa';

  @override
  String get countryZM => 'Zambia';

  @override
  String get countryZW => 'Zimbabwe';
}
