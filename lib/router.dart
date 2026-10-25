import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/ui/keeper_view.dart';
import 'package:postkeeper/ui/main_view/main_view.dart';
import 'package:postkeeper/ui/map_view.dart';
import 'package:postkeeper/ui/setting_view.dart';
import 'package:provider/provider.dart';

const String mainViewURI = '/main';
const String keeperViewURI = '/keeper';
const String mapViewURI = '/map';
const String settingViewURI = '/setting';

GoRoute mainViewRoute = GoRoute(
  path: mainViewURI,
  builder: (context, state) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(
        repository: MockPostcardRepository(),
      )..loadLatestPostcards(),
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

