import 'package:postkeeper/l10n/app_localizations.dart';

/// A geographic region and subregion identified by UN M49 codes.
/// Codes are strings so that leading zeroes are preserved.
class GeographicRegion {
  const GeographicRegion({
    required this.regionCode,
    required this.subregionCode,
  });

  final String regionCode;
  final String subregionCode;
}

/// Utilities and geographic mappings for ISO 3166-1 alpha-2 codes.
abstract final class CountryCode {
  /// Normalizes the format without validating the code.
  static String normalizeCountryCode(String countryCode) =>
      countryCode.trim().toUpperCase();

  /// Returns the mapping, or codes of '000' when it is not found.
  static GeographicRegion getRegionInfo(String countryCode) =>
      _regions[normalizeCountryCode(countryCode)] ??
      const GeographicRegion(regionCode: '000', subregionCode: '000');

  /// Returns the M49 region code, or '000' when it is not found.
  static String getRegion(String countryCode) =>
      getRegionInfo(countryCode).regionCode;

  /// Returns the M49 subregion code, or '000' when it is not found.
  static String getSubregion(String countryCode) =>
      getRegionInfo(countryCode).subregionCode;

  /// Resolves an M49 region code using the current app localization.
  static String getRegionName(String code, AppLocalizations l10n) =>
      switch (code) {
        '002' => l10n.geoAfrica,
        '019' => l10n.geoAmericas,
        '142' => l10n.geoAsia,
        '150' => l10n.geoEurope,
        '009' => l10n.geoOceania,
        '000' => l10n.geoUnknown,
        _ => l10n.geoUnknown,
      };

  /// Resolves an M49 subregion code using the current app localization.
  static String getSubregionName(String code, AppLocalizations l10n) =>
      switch (code) {
        '014' => l10n.geoEasternAfrica,
        '017' => l10n.geoMiddleAfrica,
        '015' => l10n.geoNorthernAfrica,
        '018' => l10n.geoSouthernAfrica,
        '011' => l10n.geoWesternAfrica,
        '029' => l10n.geoCaribbean,
        '013' => l10n.geoCentralAmerica,
        '005' => l10n.geoSouthAmerica,
        '021' => l10n.geoNorthernAmerica,
        '143' => l10n.geoCentralAsia,
        '030' => l10n.geoEasternAsia,
        '034' => l10n.geoSouthernAsia,
        '035' => l10n.geoSouthEasternAsia,
        '145' => l10n.geoWesternAsia,
        '151' => l10n.geoEasternEurope,
        '154' => l10n.geoNorthernEurope,
        '039' => l10n.geoSouthernEurope,
        '155' => l10n.geoWesternEurope,
        '053' => l10n.geoAustraliaNewZealand,
        '054' => l10n.geoMelanesia,
        '057' => l10n.geoMicronesia,
        '061' => l10n.geoPolynesia,
        '000' => l10n.geoUnknown,
        _ => l10n.geoUnknown,
      };

  // UN M49 overview, accessed 2026-10-29. See docs/country_code.md.
  // dart format off
  static const Map<String, GeographicRegion> _regions = {
    'AD': GeographicRegion(regionCode: '150', subregionCode: '039'), // Andorra
    'AE': GeographicRegion(regionCode: '142', subregionCode: '145'), // United Arab Emirates
    'AF': GeographicRegion(regionCode: '142', subregionCode: '034'), // Afghanistan
    'AG': GeographicRegion(regionCode: '019', subregionCode: '029'), // Antigua and Barbuda
    'AI': GeographicRegion(regionCode: '019', subregionCode: '029'), // Anguilla
    'AL': GeographicRegion(regionCode: '150', subregionCode: '039'), // Albania
    'AM': GeographicRegion(regionCode: '142', subregionCode: '145'), // Armenia
    'AO': GeographicRegion(regionCode: '002', subregionCode: '017'), // Angola
    'AR': GeographicRegion(regionCode: '019', subregionCode: '005'), // Argentina
    'AS': GeographicRegion(regionCode: '009', subregionCode: '061'), // American Samoa
    'AT': GeographicRegion(regionCode: '150', subregionCode: '155'), // Austria
    'AU': GeographicRegion(regionCode: '009', subregionCode: '053'), // Australia
    'AW': GeographicRegion(regionCode: '019', subregionCode: '029'), // Aruba
    'AX': GeographicRegion(regionCode: '150', subregionCode: '154'), // Åland Islands
    'AZ': GeographicRegion(regionCode: '142', subregionCode: '145'), // Azerbaijan
    'BA': GeographicRegion(regionCode: '150', subregionCode: '039'), // Bosnia and Herzegovina
    'BB': GeographicRegion(regionCode: '019', subregionCode: '029'), // Barbados
    'BD': GeographicRegion(regionCode: '142', subregionCode: '034'), // Bangladesh
    'BE': GeographicRegion(regionCode: '150', subregionCode: '155'), // Belgium
    'BF': GeographicRegion(regionCode: '002', subregionCode: '011'), // Burkina Faso
    'BG': GeographicRegion(regionCode: '150', subregionCode: '151'), // Bulgaria
    'BH': GeographicRegion(regionCode: '142', subregionCode: '145'), // Bahrain
    'BI': GeographicRegion(regionCode: '002', subregionCode: '014'), // Burundi
    'BJ': GeographicRegion(regionCode: '002', subregionCode: '011'), // Benin
    'BL': GeographicRegion(regionCode: '019', subregionCode: '029'), // Saint Barthélemy
    'BM': GeographicRegion(regionCode: '019', subregionCode: '021'), // Bermuda
    'BN': GeographicRegion(regionCode: '142', subregionCode: '035'), // Brunei Darussalam
    'BO': GeographicRegion(regionCode: '019', subregionCode: '005'), // Bolivia (Plurinational State of)
    'BQ': GeographicRegion(regionCode: '019', subregionCode: '029'), // Bonaire, Sint Eustatius and Saba
    'BR': GeographicRegion(regionCode: '019', subregionCode: '005'), // Brazil
    'BS': GeographicRegion(regionCode: '019', subregionCode: '029'), // Bahamas
    'BT': GeographicRegion(regionCode: '142', subregionCode: '034'), // Bhutan
    'BV': GeographicRegion(regionCode: '019', subregionCode: '005'), // Bouvet Island
    'BW': GeographicRegion(regionCode: '002', subregionCode: '018'), // Botswana
    'BY': GeographicRegion(regionCode: '150', subregionCode: '151'), // Belarus
    'BZ': GeographicRegion(regionCode: '019', subregionCode: '013'), // Belize
    'CA': GeographicRegion(regionCode: '019', subregionCode: '021'), // Canada
    'CC': GeographicRegion(regionCode: '009', subregionCode: '053'), // Cocos (Keeling) Islands
    'CD': GeographicRegion(regionCode: '002', subregionCode: '017'), // Democratic Republic of the Congo
    'CF': GeographicRegion(regionCode: '002', subregionCode: '017'), // Central African Republic
    'CG': GeographicRegion(regionCode: '002', subregionCode: '017'), // Congo
    'CH': GeographicRegion(regionCode: '150', subregionCode: '155'), // Switzerland
    'CI': GeographicRegion(regionCode: '002', subregionCode: '011'), // Côte d’Ivoire
    'CK': GeographicRegion(regionCode: '009', subregionCode: '061'), // Cook Islands
    'CL': GeographicRegion(regionCode: '019', subregionCode: '005'), // Chile
    'CM': GeographicRegion(regionCode: '002', subregionCode: '017'), // Cameroon
    'CN': GeographicRegion(regionCode: '142', subregionCode: '030'), // China
    'CO': GeographicRegion(regionCode: '019', subregionCode: '005'), // Colombia
    'CR': GeographicRegion(regionCode: '019', subregionCode: '013'), // Costa Rica
    'CU': GeographicRegion(regionCode: '019', subregionCode: '029'), // Cuba
    'CV': GeographicRegion(regionCode: '002', subregionCode: '011'), // Cabo Verde
    'CW': GeographicRegion(regionCode: '019', subregionCode: '029'), // Curaçao
    'CX': GeographicRegion(regionCode: '009', subregionCode: '053'), // Christmas Island
    'CY': GeographicRegion(regionCode: '142', subregionCode: '145'), // Cyprus
    'CZ': GeographicRegion(regionCode: '150', subregionCode: '151'), // Czechia
    'DE': GeographicRegion(regionCode: '150', subregionCode: '155'), // Germany
    'DJ': GeographicRegion(regionCode: '002', subregionCode: '014'), // Djibouti
    'DK': GeographicRegion(regionCode: '150', subregionCode: '154'), // Denmark
    'DM': GeographicRegion(regionCode: '019', subregionCode: '029'), // Dominica
    'DO': GeographicRegion(regionCode: '019', subregionCode: '029'), // Dominican Republic
    'DZ': GeographicRegion(regionCode: '002', subregionCode: '015'), // Algeria
    'EC': GeographicRegion(regionCode: '019', subregionCode: '005'), // Ecuador
    'EE': GeographicRegion(regionCode: '150', subregionCode: '154'), // Estonia
    'EG': GeographicRegion(regionCode: '002', subregionCode: '015'), // Egypt
    'EH': GeographicRegion(regionCode: '002', subregionCode: '015'), // Western Sahara
    'ER': GeographicRegion(regionCode: '002', subregionCode: '014'), // Eritrea
    'ES': GeographicRegion(regionCode: '150', subregionCode: '039'), // Spain
    'ET': GeographicRegion(regionCode: '002', subregionCode: '014'), // Ethiopia
    'FI': GeographicRegion(regionCode: '150', subregionCode: '154'), // Finland
    'FJ': GeographicRegion(regionCode: '009', subregionCode: '054'), // Fiji
    'FK': GeographicRegion(regionCode: '019', subregionCode: '005'), // Falkland Islands (Malvinas)
    'FM': GeographicRegion(regionCode: '009', subregionCode: '057'), // Micronesia (Federated States of)
    'FO': GeographicRegion(regionCode: '150', subregionCode: '154'), // Faroe Islands
    'FR': GeographicRegion(regionCode: '150', subregionCode: '155'), // France
    'GA': GeographicRegion(regionCode: '002', subregionCode: '017'), // Gabon
    'GB': GeographicRegion(regionCode: '150', subregionCode: '154'), // United Kingdom of Great Britain and Northern Ireland
    'GD': GeographicRegion(regionCode: '019', subregionCode: '029'), // Grenada
    'GE': GeographicRegion(regionCode: '142', subregionCode: '145'), // Georgia
    'GF': GeographicRegion(regionCode: '019', subregionCode: '005'), // French Guiana
    'GG': GeographicRegion(regionCode: '150', subregionCode: '154'), // Guernsey
    'GH': GeographicRegion(regionCode: '002', subregionCode: '011'), // Ghana
    'GI': GeographicRegion(regionCode: '150', subregionCode: '039'), // Gibraltar
    'GL': GeographicRegion(regionCode: '019', subregionCode: '021'), // Greenland
    'GM': GeographicRegion(regionCode: '002', subregionCode: '011'), // Gambia
    'GN': GeographicRegion(regionCode: '002', subregionCode: '011'), // Guinea
    'GP': GeographicRegion(regionCode: '019', subregionCode: '029'), // Guadeloupe
    'GQ': GeographicRegion(regionCode: '002', subregionCode: '017'), // Equatorial Guinea
    'GR': GeographicRegion(regionCode: '150', subregionCode: '039'), // Greece
    'GS': GeographicRegion(regionCode: '019', subregionCode: '005'), // South Georgia and the South Sandwich Islands
    'GT': GeographicRegion(regionCode: '019', subregionCode: '013'), // Guatemala
    'GU': GeographicRegion(regionCode: '009', subregionCode: '057'), // Guam
    'GW': GeographicRegion(regionCode: '002', subregionCode: '011'), // Guinea-Bissau
    'GY': GeographicRegion(regionCode: '019', subregionCode: '005'), // Guyana
    'HK': GeographicRegion(regionCode: '142', subregionCode: '030'), // China, Hong Kong Special Administrative Region
    'HM': GeographicRegion(regionCode: '009', subregionCode: '053'), // Heard Island and McDonald Islands
    'HN': GeographicRegion(regionCode: '019', subregionCode: '013'), // Honduras
    'HR': GeographicRegion(regionCode: '150', subregionCode: '039'), // Croatia
    'HT': GeographicRegion(regionCode: '019', subregionCode: '029'), // Haiti
    'HU': GeographicRegion(regionCode: '150', subregionCode: '151'), // Hungary
    'ID': GeographicRegion(regionCode: '142', subregionCode: '035'), // Indonesia
    'IE': GeographicRegion(regionCode: '150', subregionCode: '154'), // Ireland
    'IL': GeographicRegion(regionCode: '142', subregionCode: '145'), // Israel
    'IM': GeographicRegion(regionCode: '150', subregionCode: '154'), // Isle of Man
    'IN': GeographicRegion(regionCode: '142', subregionCode: '034'), // India
    'IO': GeographicRegion(regionCode: '002', subregionCode: '014'), // British Indian Ocean Territory
    'IQ': GeographicRegion(regionCode: '142', subregionCode: '145'), // Iraq
    'IR': GeographicRegion(regionCode: '142', subregionCode: '034'), // Iran (Islamic Republic of)
    'IS': GeographicRegion(regionCode: '150', subregionCode: '154'), // Iceland
    'IT': GeographicRegion(regionCode: '150', subregionCode: '039'), // Italy
    'JE': GeographicRegion(regionCode: '150', subregionCode: '154'), // Jersey
    'JM': GeographicRegion(regionCode: '019', subregionCode: '029'), // Jamaica
    'JO': GeographicRegion(regionCode: '142', subregionCode: '145'), // Jordan
    'JP': GeographicRegion(regionCode: '142', subregionCode: '030'), // Japan
    'KE': GeographicRegion(regionCode: '002', subregionCode: '014'), // Kenya
    'KG': GeographicRegion(regionCode: '142', subregionCode: '143'), // Kyrgyzstan
    'KH': GeographicRegion(regionCode: '142', subregionCode: '035'), // Cambodia
    'KI': GeographicRegion(regionCode: '009', subregionCode: '057'), // Kiribati
    'KM': GeographicRegion(regionCode: '002', subregionCode: '014'), // Comoros
    'KN': GeographicRegion(regionCode: '019', subregionCode: '029'), // Saint Kitts and Nevis
    'KP': GeographicRegion(regionCode: '142', subregionCode: '030'), // Democratic People's Republic of Korea
    'KR': GeographicRegion(regionCode: '142', subregionCode: '030'), // Republic of Korea
    'KW': GeographicRegion(regionCode: '142', subregionCode: '145'), // Kuwait
    'KY': GeographicRegion(regionCode: '019', subregionCode: '029'), // Cayman Islands
    'KZ': GeographicRegion(regionCode: '142', subregionCode: '143'), // Kazakhstan
    'LA': GeographicRegion(regionCode: '142', subregionCode: '035'), // Lao People's Democratic Republic
    'LB': GeographicRegion(regionCode: '142', subregionCode: '145'), // Lebanon
    'LC': GeographicRegion(regionCode: '019', subregionCode: '029'), // Saint Lucia
    'LI': GeographicRegion(regionCode: '150', subregionCode: '155'), // Liechtenstein
    'LK': GeographicRegion(regionCode: '142', subregionCode: '034'), // Sri Lanka
    'LR': GeographicRegion(regionCode: '002', subregionCode: '011'), // Liberia
    'LS': GeographicRegion(regionCode: '002', subregionCode: '018'), // Lesotho
    'LT': GeographicRegion(regionCode: '150', subregionCode: '154'), // Lithuania
    'LU': GeographicRegion(regionCode: '150', subregionCode: '155'), // Luxembourg
    'LV': GeographicRegion(regionCode: '150', subregionCode: '154'), // Latvia
    'LY': GeographicRegion(regionCode: '002', subregionCode: '015'), // Libya
    'MA': GeographicRegion(regionCode: '002', subregionCode: '015'), // Morocco
    'MC': GeographicRegion(regionCode: '150', subregionCode: '155'), // Monaco
    'MD': GeographicRegion(regionCode: '150', subregionCode: '151'), // Republic of Moldova
    'ME': GeographicRegion(regionCode: '150', subregionCode: '039'), // Montenegro
    'MF': GeographicRegion(regionCode: '019', subregionCode: '029'), // Saint Martin (French Part)
    'MG': GeographicRegion(regionCode: '002', subregionCode: '014'), // Madagascar
    'MH': GeographicRegion(regionCode: '009', subregionCode: '057'), // Marshall Islands
    'MK': GeographicRegion(regionCode: '150', subregionCode: '039'), // North Macedonia
    'ML': GeographicRegion(regionCode: '002', subregionCode: '011'), // Mali
    'MM': GeographicRegion(regionCode: '142', subregionCode: '035'), // Myanmar
    'MN': GeographicRegion(regionCode: '142', subregionCode: '030'), // Mongolia
    'MO': GeographicRegion(regionCode: '142', subregionCode: '030'), // China, Macao Special Administrative Region
    'MP': GeographicRegion(regionCode: '009', subregionCode: '057'), // Northern Mariana Islands
    'MQ': GeographicRegion(regionCode: '019', subregionCode: '029'), // Martinique
    'MR': GeographicRegion(regionCode: '002', subregionCode: '011'), // Mauritania
    'MS': GeographicRegion(regionCode: '019', subregionCode: '029'), // Montserrat
    'MT': GeographicRegion(regionCode: '150', subregionCode: '039'), // Malta
    'MU': GeographicRegion(regionCode: '002', subregionCode: '014'), // Mauritius
    'MV': GeographicRegion(regionCode: '142', subregionCode: '034'), // Maldives
    'MW': GeographicRegion(regionCode: '002', subregionCode: '014'), // Malawi
    'MX': GeographicRegion(regionCode: '019', subregionCode: '013'), // Mexico
    'MY': GeographicRegion(regionCode: '142', subregionCode: '035'), // Malaysia
    'MZ': GeographicRegion(regionCode: '002', subregionCode: '014'), // Mozambique
    'NA': GeographicRegion(regionCode: '002', subregionCode: '018'), // Namibia
    'NC': GeographicRegion(regionCode: '009', subregionCode: '054'), // New Caledonia
    'NE': GeographicRegion(regionCode: '002', subregionCode: '011'), // Niger
    'NF': GeographicRegion(regionCode: '009', subregionCode: '053'), // Norfolk Island
    'NG': GeographicRegion(regionCode: '002', subregionCode: '011'), // Nigeria
    'NI': GeographicRegion(regionCode: '019', subregionCode: '013'), // Nicaragua
    'NL': GeographicRegion(regionCode: '150', subregionCode: '155'), // Netherlands (Kingdom of the)
    'NO': GeographicRegion(regionCode: '150', subregionCode: '154'), // Norway
    'NP': GeographicRegion(regionCode: '142', subregionCode: '034'), // Nepal
    'NR': GeographicRegion(regionCode: '009', subregionCode: '057'), // Naoero
    'NU': GeographicRegion(regionCode: '009', subregionCode: '061'), // Niue
    'NZ': GeographicRegion(regionCode: '009', subregionCode: '053'), // New Zealand
    'OM': GeographicRegion(regionCode: '142', subregionCode: '145'), // Oman
    'PA': GeographicRegion(regionCode: '019', subregionCode: '013'), // Panama
    'PE': GeographicRegion(regionCode: '019', subregionCode: '005'), // Peru
    'PF': GeographicRegion(regionCode: '009', subregionCode: '061'), // French Polynesia
    'PG': GeographicRegion(regionCode: '009', subregionCode: '054'), // Papua New Guinea
    'PH': GeographicRegion(regionCode: '142', subregionCode: '035'), // Philippines
    'PK': GeographicRegion(regionCode: '142', subregionCode: '034'), // Pakistan
    'PL': GeographicRegion(regionCode: '150', subregionCode: '151'), // Poland
    'PM': GeographicRegion(regionCode: '019', subregionCode: '021'), // Saint Pierre and Miquelon
    'PN': GeographicRegion(regionCode: '009', subregionCode: '061'), // Pitcairn
    'PR': GeographicRegion(regionCode: '019', subregionCode: '029'), // Puerto Rico
    'PS': GeographicRegion(regionCode: '142', subregionCode: '145'), // State of Palestine
    'PT': GeographicRegion(regionCode: '150', subregionCode: '039'), // Portugal
    'PW': GeographicRegion(regionCode: '009', subregionCode: '057'), // Palau
    'PY': GeographicRegion(regionCode: '019', subregionCode: '005'), // Paraguay
    'QA': GeographicRegion(regionCode: '142', subregionCode: '145'), // Qatar
    'RE': GeographicRegion(regionCode: '002', subregionCode: '014'), // Réunion
    'RO': GeographicRegion(regionCode: '150', subregionCode: '151'), // Romania
    'RS': GeographicRegion(regionCode: '150', subregionCode: '039'), // Serbia
    'RU': GeographicRegion(regionCode: '150', subregionCode: '151'), // Russian Federation
    'RW': GeographicRegion(regionCode: '002', subregionCode: '014'), // Rwanda
    'SA': GeographicRegion(regionCode: '142', subregionCode: '145'), // Saudi Arabia
    'SB': GeographicRegion(regionCode: '009', subregionCode: '054'), // Solomon Islands
    'SC': GeographicRegion(regionCode: '002', subregionCode: '014'), // Seychelles
    'SD': GeographicRegion(regionCode: '002', subregionCode: '015'), // Sudan
    'SE': GeographicRegion(regionCode: '150', subregionCode: '154'), // Sweden
    'SG': GeographicRegion(regionCode: '142', subregionCode: '035'), // Singapore
    'SH': GeographicRegion(regionCode: '002', subregionCode: '011'), // Saint Helena
    'SI': GeographicRegion(regionCode: '150', subregionCode: '039'), // Slovenia
    'SJ': GeographicRegion(regionCode: '150', subregionCode: '154'), // Svalbard and Jan Mayen Islands
    'SK': GeographicRegion(regionCode: '150', subregionCode: '151'), // Slovakia
    'SL': GeographicRegion(regionCode: '002', subregionCode: '011'), // Sierra Leone
    'SM': GeographicRegion(regionCode: '150', subregionCode: '039'), // San Marino
    'SN': GeographicRegion(regionCode: '002', subregionCode: '011'), // Senegal
    'SO': GeographicRegion(regionCode: '002', subregionCode: '014'), // Somalia
    'SR': GeographicRegion(regionCode: '019', subregionCode: '005'), // Suriname
    'SS': GeographicRegion(regionCode: '002', subregionCode: '014'), // South Sudan
    'ST': GeographicRegion(regionCode: '002', subregionCode: '017'), // Sao Tome and Principe
    'SV': GeographicRegion(regionCode: '019', subregionCode: '013'), // El Salvador
    'SX': GeographicRegion(regionCode: '019', subregionCode: '029'), // Sint Maarten (Dutch part)
    'SY': GeographicRegion(regionCode: '142', subregionCode: '145'), // Syrian Arab Republic
    'SZ': GeographicRegion(regionCode: '002', subregionCode: '018'), // Eswatini
    'TC': GeographicRegion(regionCode: '019', subregionCode: '029'), // Turks and Caicos Islands
    'TD': GeographicRegion(regionCode: '002', subregionCode: '017'), // Chad
    'TF': GeographicRegion(regionCode: '002', subregionCode: '014'), // French Southern Territories
    'TG': GeographicRegion(regionCode: '002', subregionCode: '011'), // Togo
    'TH': GeographicRegion(regionCode: '142', subregionCode: '035'), // Thailand
    'TJ': GeographicRegion(regionCode: '142', subregionCode: '143'), // Tajikistan
    'TK': GeographicRegion(regionCode: '009', subregionCode: '061'), // Tokelau
    'TL': GeographicRegion(regionCode: '142', subregionCode: '035'), // Timor-Leste
    'TM': GeographicRegion(regionCode: '142', subregionCode: '143'), // Turkmenistan
    'TN': GeographicRegion(regionCode: '002', subregionCode: '015'), // Tunisia
    'TO': GeographicRegion(regionCode: '009', subregionCode: '061'), // Tonga
    'TR': GeographicRegion(regionCode: '142', subregionCode: '145'), // Türkiye
    'TT': GeographicRegion(regionCode: '019', subregionCode: '029'), // Trinidad and Tobago
    'TV': GeographicRegion(regionCode: '009', subregionCode: '061'), // Tuvalu
    'TW': GeographicRegion(regionCode: '142', subregionCode: '030'), // Taiwan: app-defined addition
    'TZ': GeographicRegion(regionCode: '002', subregionCode: '014'), // United Republic of Tanzania
    'UA': GeographicRegion(regionCode: '150', subregionCode: '151'), // Ukraine
    'UG': GeographicRegion(regionCode: '002', subregionCode: '014'), // Uganda
    'UM': GeographicRegion(regionCode: '009', subregionCode: '057'), // United States Minor Outlying Islands
    'US': GeographicRegion(regionCode: '019', subregionCode: '021'), // United States of America
    'UY': GeographicRegion(regionCode: '019', subregionCode: '005'), // Uruguay
    'UZ': GeographicRegion(regionCode: '142', subregionCode: '143'), // Uzbekistan
    'VA': GeographicRegion(regionCode: '150', subregionCode: '039'), // Holy See
    'VC': GeographicRegion(regionCode: '019', subregionCode: '029'), // Saint Vincent and the Grenadines
    'VE': GeographicRegion(regionCode: '019', subregionCode: '005'), // Venezuela (Bolivarian Republic of)
    'VG': GeographicRegion(regionCode: '019', subregionCode: '029'), // British Virgin Islands
    'VI': GeographicRegion(regionCode: '019', subregionCode: '029'), // United States Virgin Islands
    'VN': GeographicRegion(regionCode: '142', subregionCode: '035'), // Viet Nam
    'VU': GeographicRegion(regionCode: '009', subregionCode: '054'), // Vanuatu
    'WF': GeographicRegion(regionCode: '009', subregionCode: '061'), // Wallis and Futuna Islands
    'WS': GeographicRegion(regionCode: '009', subregionCode: '061'), // Samoa
    'YE': GeographicRegion(regionCode: '142', subregionCode: '145'), // Yemen
    'YT': GeographicRegion(regionCode: '002', subregionCode: '014'), // Mayotte
    'ZA': GeographicRegion(regionCode: '002', subregionCode: '018'), // South Africa
    'ZM': GeographicRegion(regionCode: '002', subregionCode: '014'), // Zambia
    'ZW': GeographicRegion(regionCode: '002', subregionCode: '014'), // Zimbabwe
  };
  // dart format on
}
