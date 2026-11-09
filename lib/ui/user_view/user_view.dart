import 'package:flutter/material.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/data/repositories/postcard_repository.dart';

import 'user_panel.dart';

import 'package:go_router/go_router.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/locale_controller.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';
import 'package:provider/provider.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel({
    required PersonRepository personRepository,
    required PostcardRepository postcardRepository,
  }) : panel = _load(personRepository, postcardRepository);

  final Future<UserPanelData> panel;

  static Future<UserPanelData> _load(
    PersonRepository people,
    PostcardRepository postcards,
  ) async {
    final person = await people.getMyInfo();
    final all = await postcards.getAllPostcards();
    final received = await postcards.getAllMyReceived();
    final locations = received.postcards
        .map((card) => card.sendFrom.id)
        .where((id) => id.isNotEmpty && id != dummyLocationId)
        .toSet();
    return UserPanelData(
      person: person,
      postcardCount: all.postcards.length,
      locationCount: locations.length,
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key, required this.viewModel});

  final UserViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PrimaryViewLayout(
      title: l10n.navUser,
      children: [
        Expanded(
          child: ListView(
            children: [
              FutureBuilder<UserPanelData>(
                future: viewModel.panel,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(l10n.contactLoadError);
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return UserPanel(data: snapshot.data!);
                },
              ),
              Card(
                child: Column(
                  children: [
                    _ComingSoonItem(
                      itemKey: const ValueKey('user-backup'),
                      icon: Icons.cloud_outlined,
                      title: l10n.userBackupRestore,
                      subtitle: l10n.textCommingSoon,
                    ),
                    ListTile(
                      key: const ValueKey('user-contacts'),
                      leading: const Icon(Icons.contacts_outlined),
                      title: Text(l10n.userContacts),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(contactListViewURI),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      key: const ValueKey('user-language'),
                      leading: const Icon(Icons.language),
                      title: Text(l10n.settingsLanguage),
                      trailing: DropdownButton<Locale>(
                        key: const ValueKey('settings-language-dropdown'),
                        value: Locale(
                          Localizations.localeOf(context).languageCode,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: Locale('zh'),
                            child: Text('正體中文', key: ValueKey('language-zh')),
                          ),
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text(
                              'English',
                              key: ValueKey('language-en'),
                            ),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            context.read<LocaleController>().setLocale(locale);
                          }
                        },
                      ),
                    ),
                    _ComingSoonItem(
                      itemKey: const ValueKey('user-help'),
                      icon: Icons.menu_book_outlined,
                      title: l10n.userHelp,
                      subtitle: l10n.textCommingSoon,
                    ),
                    _ComingSoonItem(
                      itemKey: const ValueKey('user-about'),
                      icon: Icons.info_outline,
                      title: l10n.userAbout,
                      subtitle: l10n.textCommingSoon,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComingSoonItem extends StatelessWidget {
  const _ComingSoonItem({
    required this.itemKey,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Key itemKey;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    key: itemKey,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}
