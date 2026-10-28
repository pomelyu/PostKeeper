import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/collection_view.dart';
import 'package:postkeeper/ui/keeper_view.dart';
import 'package:postkeeper/ui/main_view/main_view.dart';
import 'package:postkeeper/ui/map_view.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';
import 'package:postkeeper/ui/postcard_view.dart';
import 'package:postkeeper/ui/user_view.dart';
import 'package:provider/provider.dart';

const String mainViewURI = '/main';
const String keeperViewURI = '/keeper';
const String mapViewURI = '/map';
const String userViewURI = '/user';
const String postcardViewURI = '/postcard';
const String postcardEditViewURI = '/postcard/edit';
const String collectionViewURI = '/collection';

final appPostcardRepository = MockPostcardRepository();

GoRoute mainViewRoute = GoRoute(
  path: mainViewURI,
  builder: (context, state) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(
        repository: appPostcardRepository,
      )..initialize(),
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

GoRoute userViewRoute = GoRoute(
  path: userViewURI,
  builder: (context, state) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: Builder(
        builder: (context) {
          return UserView(
            key: const ValueKey('user-view'),
            viewModel: context.read<UserViewModel>(),
          );
        },
      ),
    );
  },
);

GoRoute postcardViewRoute = GoRoute(
  path: postcardViewURI,
  builder: (context, state) {
    final postcard = state.extra as Postcard;

    return ChangeNotifierProvider(
      create: (_) => PostcardViewModel(postcard: postcard),
      child: Builder(
        builder: (context) {
          return PostcardView(
            key: const ValueKey('postcard-view'),
            viewModel: context.read<PostcardViewModel>(),
          );
        },
      ),
    );
  },
);

GoRoute postcardEditViewRoute = GoRoute(
  path: postcardEditViewURI,
  builder: (context, state) {
    final postcard = state.extra as Postcard?;

    return ChangeNotifierProvider(
      create: (_) => PostcardEditViewModel(
        repository: appPostcardRepository,
        postcard: postcard,
      ),
      child: Builder(
        builder: (context) {
          return PostcardEditView(
            key: const ValueKey('postcard-edit-view'),
            viewModel: context.read<PostcardEditViewModel>(),
          );
        },
      ),
    );
  },
);

GoRoute collectionViewRoute = GoRoute(
  path: collectionViewURI,
  builder: (context, state) {
    final collection = state.extra as Collection;
    return CollectionView(collection: collection);
  },
);
