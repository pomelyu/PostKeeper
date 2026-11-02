import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/locale_controller.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';
import 'package:provider/provider.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel();
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Card(
                child: ListTile(
                  key: const ValueKey('user-collection-overview'),
                  leading: const Icon(Icons.collections_outlined),
                  title: Text(l10n.userCollectionOverview),
                  subtitle: Text(l10n.textCommingSoon),
                ),
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
                    _ComingSoonItem(
                      itemKey: const ValueKey('user-contacts'),
                      icon: Icons.contacts_outlined,
                      title: l10n.userContacts,
                      subtitle: l10n.textCommingSoon,
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
