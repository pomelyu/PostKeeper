import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/location_repository.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/collection_view.dart';
import 'package:postkeeper/ui/contact_list_view.dart';
import 'package:postkeeper/ui/contact_view.dart';
import 'package:postkeeper/ui/keeper_view.dart';
import 'package:postkeeper/ui/location_picker_view/location_picker_view.dart';
import 'package:postkeeper/ui/location_picker_view/location_picker_view_model.dart';
import 'package:postkeeper/ui/main_view/main_view.dart';
import 'package:postkeeper/ui/map_view/map_view.dart';
import 'package:postkeeper/ui/postcard_edit_view/postcard_edit_view.dart';
import 'package:postkeeper/ui/postcard_view/postcard_view.dart';
import 'package:postkeeper/ui/user_view/user_view.dart';
import 'package:provider/provider.dart';

const String mainViewURI = '/main';
const String keeperViewURI = '/keeper';
const String mapViewURI = '/map';
const String userViewURI = '/user';
const String postcardViewURI = '/postcard';
const String locationPickerViewURI = '/location-picker';
const String postcardEditViewURI = '/postcard/edit';
const String collectionViewURI = '/collection';
const String contactListViewURI = '/contacts';
const String contactViewURI = '/contact';

GoRouter createAppRouter({
  required PostcardRepository postcardRepository,
  required PersonRepository personRepository,
  required LocationRepository locationRepository,
}) {
  final mainViewRoute = GoRoute(
    path: mainViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) =>
            MainViewModel(repository: postcardRepository)..initialize(),
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

  final keeperViewRoute = GoRoute(
    path: keeperViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) =>
            KeeperViewModel(repository: postcardRepository)..initialize(),
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

  final mapViewRoute = GoRoute(
    path: mapViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => MapViewModel(
          repository: postcardRepository,
          personRepository: personRepository,
        )..initialize(),
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

  final userViewRoute = GoRoute(
    path: userViewURI,
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (_) => UserViewModel(
          personRepository: personRepository,
          postcardRepository: postcardRepository,
        ),
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

  final postcardViewRoute = GoRoute(
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

  final postcardEditViewRoute = GoRoute(
    path: postcardEditViewURI,
    builder: (context, state) {
      final postcard = state.extra as Postcard?;

      return ChangeNotifierProvider(
        create: (_) => PostcardEditViewModel(
          repository: postcardRepository,
          personRepository: personRepository,
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

  final collectionViewRoute = GoRoute(
    path: collectionViewURI,
    builder: (context, state) {
      final collection = state.extra as Collection;
      return CollectionView(
        key: const ValueKey('collection-view'),
        collection: collection,
      );
    },
  );

  final contactListViewRoute = GoRoute(
    path: contactListViewURI,
    builder: (context, state) => Provider(
      create: (_) => ContactListViewModel(repository: personRepository),
      child: Builder(
        builder: (context) => ContactListView(
          key: const ValueKey('contact-list-view'),
          viewModel: context.read<ContactListViewModel>(),
        ),
      ),
    ),
  );

  final contactViewRoute = GoRoute(
    path: contactViewURI,
    builder: (context, state) => Provider(
      create: (_) => ContactViewModel(
        repository: personRepository,
        person: state.extra as Person?,
      ),
      child: Builder(
        builder: (context) => ContactView(
          key: const ValueKey('contact-view'),
          viewModel: context.read<ContactViewModel>(),
        ),
      ),
    ),
  );

  final locationPickerViewRoute = GoRoute(
    path: locationPickerViewURI,
    builder: (context, state) => ChangeNotifierProvider(
      create: (_) => LocationPickerViewModel(repository: locationRepository),
      child: Builder(
        builder: (context) => LocationPickerView(
          key: const ValueKey('location-picker-view'),
          viewModel: context.read<LocationPickerViewModel>(),
        ),
      ),
    ),
  );

  return GoRouter(
    initialLocation: mainViewURI,
    routes: [
      ShellRoute(
        builder: (context, state, child) => PostKeeperScaffold(child: child),
        routes: [mainViewRoute, keeperViewRoute, mapViewRoute, userViewRoute],
      ),
      postcardViewRoute,
      postcardEditViewRoute,
      collectionViewRoute,
      contactListViewRoute,
      contactViewRoute,
      locationPickerViewRoute,
    ],
  );
}

class PostKeeperScaffold extends StatelessWidget {
  const PostKeeperScaffold({super.key, required this.child});

  final Widget child;

  static const _paths = [mainViewURI, keeperViewURI, mapViewURI, userViewURI];

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
            key: ValueKey('nav-user'),
            icon: Icon(Icons.person_outline),
            label: l10n.navUser,
          ),
        ],
      ),
    );
  }
}
