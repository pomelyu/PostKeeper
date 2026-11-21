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

  bool busy = false;
  bool _disposed = false;

  Future<Person?> create(String name) async {
    if (busy || name.trim().isEmpty) return null;
    busy = true;
    notifyListeners();
    try {
      final person = await _repository.createPerson(name);
      if (!_disposed) refresh();
      return person;
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<DeletePersonResult> delete(String id) async {
    busy = true;
    notifyListeners();
    try {
      final result = await _repository.deletePerson(id);
      if (!_disposed && result == DeletePersonResult.deleted) refresh();
      return result;
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

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

  Future<void> _createContact(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    var name = '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.contactAdd),
          content: TextField(
            key: const ValueKey('contact-new-name'),
            autofocus: true,
            onChanged: (value) => setState(() => name = value),
            decoration: InputDecoration(labelText: l10n.contactName),
          ),
          actions: [
            TextButton(
              key: const ValueKey('contact-new-cancel'),
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.contactCancel),
            ),
            TextButton(
              key: const ValueKey('contact-new-confirm'),
              onPressed: name.trim().isEmpty
                  ? null
                  : () => Navigator.pop(context, name.trim()),
              child: Text(l10n.contactCreate),
            ),
          ],
        ),
      ),
    );
    if (result == null || !context.mounted) return;
    try {
      final person = await viewModel.create(result);
      if (person == null || !context.mounted) return;
      await context.push(contactViewURI, extra: person);
      if (context.mounted) viewModel.refresh();
    } catch (_) {
      if (context.mounted) _showMessage(context, l10n.contactSaveError);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteContact(BuildContext context, Person person) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contactDelete),
        content: Text(l10n.contactDeleteConfirmation(person.name)),
        actions: [
          TextButton(
            key: const ValueKey('contact-delete-cancel'),
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.contactCancel),
          ),
          TextButton(
            key: const ValueKey('contact-delete-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.contactDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final result = await viewModel.delete(person.id);
      if (!context.mounted) return;
      if (result == DeletePersonResult.referenced) {
        _showMessage(context, l10n.contactDeleteReferenced);
      } else if (result != DeletePersonResult.deleted) {
        _showMessage(context, l10n.contactDeleteError);
      }
    } catch (_) {
      if (context.mounted) _showMessage(context, l10n.contactDeleteError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryViewLayout(
      title: l10n.userContacts,
      titleActions: [
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => IconButton(
            key: const ValueKey('contact-add-button'),
            onPressed: viewModel.busy ? null : () => _createContact(context),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
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
              separatorBuilder: (_, _) => bodyVerticalSpace,
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
                    trailing: IconButton(
                      key: ValueKey('contact-delete-${person.id}'),
                      icon: const Icon(Icons.delete_outline),
                      onPressed: viewModel.busy
                          ? null
                          : () => _deleteContact(context, person),
                    ),
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
