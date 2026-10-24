import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/ui/keeper_view.dart';
import 'package:postkeeper/ui/main_view.dart';
import 'package:postkeeper/ui/map_view.dart';
import 'package:postkeeper/ui/setting_view.dart';
import 'package:provider/provider.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const PostKeeperApp());
}

class PostKeeperApp extends StatelessWidget {
  const PostKeeperApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: createAppRouter(),
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
            label: '首頁'
          ),
          NavigationDestination(
            key: ValueKey('nav-keeper'),
            icon: Icon(Icons.collections_bookmark_outlined),
            label: '收藏'
          ),
          NavigationDestination(
            key: ValueKey('nav-map'),
            icon: Icon(Icons.map_outlined),
            label: '地圖'
          ),
          NavigationDestination(
            key: ValueKey('nav-setting'),
            icon: Icon(Icons.settings_outlined),
            label: '設定'
          ),
        ],
      ),
    );
  }
}

GoRouter createAppRouter() {
  GoRoute mainViewRoute = GoRoute(
    path: mainViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => MainViewModel(),
        child: Builder(
          builder: (context) {
            return MainView(
              key: const ValueKey('main-view'),
              viewModel: context.read<MainViewModel>(),
            );
          },
        ),
      );
    },
  );

  GoRoute keeperViewRoute = GoRoute(
    path: keeperViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => KeeperViewModel(),
        child: Builder(
          builder: (context) {
            return KeeperView(
              key: const ValueKey('keeper-view'),
              viewModel: context.read<KeeperViewModel>(),
            );
          },
        ),
      );
    },
  );

  GoRoute mapViewRoute = GoRoute(
    path: mapViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(),
        child: Builder(
          builder: (context) {
            return MapView(
              key: const ValueKey('map-view'),
              viewModel: context.read<MapViewModel>(),
            );
          },
        ),
      );
    },
  );

  GoRoute settingViewRoute = GoRoute(
    path: settingViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => SettingViewModel(),
        child: Builder(
          builder: (context) {
            return SettingView(
              key: const ValueKey('setting-view'),
              viewModel: context.read<SettingViewModel>(),
            );
          },
        ),
      );
    },
  );

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
