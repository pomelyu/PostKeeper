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

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

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
