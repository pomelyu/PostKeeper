import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/data/services/google_places_service.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/locale_controller.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/style.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    PostKeeperApp(
      postcardRepository: MockPostcardRepository(),
      personRepository: MockPersonRepository(),
      locationRepository: const GoogleLocationRepository(
        service: GooglePlacesService(),
      ),
    ),
  );
}

class PostKeeperApp extends StatefulWidget {
  const PostKeeperApp({
    super.key,
    required this.postcardRepository,
    required this.personRepository,
    required this.locationRepository,
  });

  final PostcardRepository postcardRepository;
  final PersonRepository personRepository;
  final LocationRepository locationRepository;

  @override
  State<PostKeeperApp> createState() => _PostKeeperAppState();
}

class _PostKeeperAppState extends State<PostKeeperApp> {
  final _localeController = LocaleController();
  late final _router = createAppRouter(
    postcardRepository: widget.postcardRepository,
    personRepository: widget.personRepository,
    locationRepository: widget.locationRepository,
  );

  @override
  void dispose() {
    _router.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _localeController,
      child: ListenableBuilder(
        listenable: _localeController,
        builder: (context, child) => MaterialApp.router(
          title: 'PostKeeper',
          theme: buildAppTheme(),
          locale: _localeController.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (deviceLocale?.languageCode == 'zh') {
              return const Locale.fromSubtags(
                languageCode: 'zh',
                scriptCode: 'Hant',
                countryCode: 'TW',
              );
            }
            return supportedLocales
                    .where(
                      (locale) =>
                          locale.languageCode == deviceLocale?.languageCode,
                    )
                    .firstOrNull ??
                const Locale('en');
          },
          routerConfig: _router,
        ),
      ),
    );
  }
}
