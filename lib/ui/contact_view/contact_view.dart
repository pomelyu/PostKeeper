import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';

import 'contact_addresses.dart';
import 'contact_name.dart';

class ContactViewModel extends ChangeNotifier {
  ContactViewModel({required PersonRepository repository, Person? person})
    : _repository = repository,
      isMyInfo = person == null,
      contact = person == null
          ? repository.getMyInfo()
          : repository
                .getPersonById(person.id)
                .then((saved) => saved ?? person) {
    contact = contact.then((person) {
      if (!_disposed) nameController.text = person.name;
      return person;
    });
  }

  final PersonRepository _repository;
  final bool isMyInfo;
  Future<Person> contact;
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  bool editingName = false;
  bool saving = false;

  void editName() {
    if (saving) return;
    editingName = true;
    notifyListeners();
    nameFocusNode.requestFocus();
  }

  Future<bool> saveName() async {
    final saved = await rename(nameController.text);
    final person = saved ? await contact : null;
    if (person != null && !_disposed) {
      nameController.text = person.name;
      editingName = false;
      nameFocusNode.unfocus();
      notifyListeners();
    }
    return saved;
  }

  bool _disposed = false;

  Future<bool> _save(Future<void> Function(Person) operation) async {
    if (saving) return false;
    saving = true;
    notifyListeners();
    try {
      final person = await contact;
      await operation(person);
      final updated = await _repository.getPersonById(person.id);
      if (updated == null) throw StateError('Contact no longer exists');
      contact = Future.value(updated);
      return true;
    } catch (_) {
      return false;
    } finally {
      saving = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> rename(String name) {
    if (name.trim().isEmpty) return Future.value(false);
    return _save((person) => _repository.updateName(person.id, name.trim()));
  }

  Future<bool> addLocation(Location location) =>
      _save((person) => _repository.addLocation(person.id, location));

  Future<bool> removeLocation(String locationId) =>
      _save((person) => _repository.removeLocation(person.id, locationId));

  @override
  void dispose() {
    _disposed = true;
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }
}

class ContactView extends StatelessWidget {
  const ContactView({super.key, required this.viewModel});

  final ContactViewModel viewModel;

  void _showSaveError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).contactSaveError)),
    );
  }

  Future<void> _addAddress(BuildContext context) async {
    final location = await context.push<Location>(locationPickerViewURI);
    if (location == null || !context.mounted) return;
    final saved = await viewModel.addLocation(location);
    if (context.mounted && !saved) _showSaveError(context);
  }

  Future<void> _deleteAddress(BuildContext context, Location location) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contactDeleteAddress),
        content: Text(l10n.contactDeleteAddressConfirmation(location.name)),
        actions: [
          TextButton(
            key: const ValueKey('contact-delete-cancel'),
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.contactCancel),
          ),
          TextButton(
            key: const ValueKey('contact-delete-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.contactDeleteAddress),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final saved = await viewModel.removeLocation(location.id);
    if (context.mounted && !saved) _showSaveError(context);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: viewModel,
    builder: (context, _) => _build(context),
  );

  Widget _build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryViewLayout(
      title: viewModel.isMyInfo ? l10n.userPersonalInfo : l10n.contactTitle,
      child: FutureBuilder<Person>(
        future: viewModel.contact,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.contactLoadError));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final person = snapshot.data!;
          return Column(
            key: const ValueKey('contact-details'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ContactName(
                controller: viewModel.nameController,
                focusNode: viewModel.nameFocusNode,
                editing: viewModel.editingName,
                saving: viewModel.saving,
                onEdit: viewModel.editName,
                onSave: () async {
                  final saved = await viewModel.saveName();
                  if (context.mounted && !saved) _showSaveError(context);
                },
              ),
              sectionVerticalSpace,
              Expanded(
                child: ContactAddresses(
                  locations: person.locations,
                  saving: viewModel.saving,
                  onAdd: () => _addAddress(context),
                  onDelete: (location) => _deleteAddress(context, location),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
