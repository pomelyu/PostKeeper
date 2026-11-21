import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

class ContactListViewModel extends ChangeNotifier {
  ContactListViewModel({required PersonRepository repository})
    : _repository = repository,
      contacts = repository.getAllUsers().then(
        (users) => users.where((user) => user.id != myId).toList(),
      );

  final PersonRepository _repository;
  Future<List<Person>> contacts;

  void refresh() {
    contacts = _repository.getAllUsers().then(
      (users) => users.where((user) => user.id != myId).toList(),
    );
    notifyListeners();
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({super.key, required this.viewModel});

  final ContactListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryViewLayout(
      title: l10n.userContacts,
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => FutureBuilder<List<Person>>(
          future: viewModel.contacts,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(l10n.contactLoadError));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final contacts = snapshot.data!;
            if (contacts.isEmpty) return Center(child: Text(l10n.contactEmpty));
            return ListView.separated(
              key: const ValueKey('contact-list'),
              itemCount: contacts.length,
              separatorBuilder: (_, _) => sectionVerticalSpace,
              itemBuilder: (context, index) {
                final person = contacts[index];
                return Card(
                  color: surfaceMutedColor,
                  child: ListTile(
                    key: ValueKey('contact-${person.id}'),
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      person.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await context.push(contactViewURI, extra: person);
                      if (context.mounted) viewModel.refresh();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
