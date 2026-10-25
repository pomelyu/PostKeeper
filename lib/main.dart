import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/locale_controller.dart';
import 'package:postkeeper/router.dart';
import 'package:provider/provider.dart';


void main() {
  debugPaintSizeEnabled = true;
  runApp(const PostKeeperApp());
}

class PostKeeperApp extends StatefulWidget {
  const PostKeeperApp({super.key});

  @override
  State<PostKeeperApp> createState() => _PostKeeperAppState();
}

class _PostKeeperAppState extends State<PostKeeperApp> {
  final _localeController = LocaleController();
  late final _router = createAppRouter();

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
          locale: _localeController.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        ),
      ),
    );
  }
}

class PostKeeperScaffold extends StatelessWidget {
  const PostKeeperScaffold({super.key, required this.child});

  final Widget child;

  static const _paths = [
    mainViewURI,
    keeperViewURI,
    mapViewURI,
    settingViewURI,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final path = GoRouterState.of(context).uri.path;
    final index = _paths.indexOf(path);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (index) {
          context.go(_paths[index]);
        },
        destinations: [
          NavigationDestination(
            key: ValueKey('nav-main'),
            icon: Icon(Icons.home_outlined),
            label: l10n.navHome,
          ),
          NavigationDestination(
            key: ValueKey('nav-keeper'),
            icon: Icon(Icons.collections_bookmark_outlined),
            label: l10n.navKeeper,
          ),
          NavigationDestination(
            key: ValueKey('nav-map'),
            icon: Icon(Icons.map_outlined),
            label: l10n.navMap,
          ),
          NavigationDestination(
            key: ValueKey('nav-setting'),
            icon: Icon(Icons.settings_outlined),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: mainViewURI,
    routes: [
      ShellRoute(
        builder: (context, state, child) => PostKeeperScaffold(child: child),
        routes: [
          mainViewRoute,
          keeperViewRoute,
          mapViewRoute,
          settingViewRoute,
        ],
      ),
    ],
  );
}
