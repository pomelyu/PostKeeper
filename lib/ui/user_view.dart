import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/locale_controller.dart';
import 'package:postkeeper/ui/core/title.dart';
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitleTextBox(title: l10n.navUser),
          Text(l10n.textCommingSoon),
          DropdownButton<Locale>(
            key: const ValueKey('settings-language-dropdown'),
            value: Locale(Localizations.localeOf(context).languageCode),
            hint: Text(l10n.settingsLanguage),
            items: const [
              DropdownMenuItem(
                value: Locale('zh'),
                child: Text('正體中文', key: ValueKey('language-zh')),
              ),
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English', key: ValueKey('language-en')),
              ),
            ],
            onChanged: (locale) {
              if (locale != null) {
                context.read<LocaleController>().setLocale(locale);
              }
            },
          ),
        ],
      ),
    );
  }
}
