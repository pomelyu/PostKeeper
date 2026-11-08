import 'package:flutter/material.dart';
import 'package:postkeeper/data/repositories/person_repository.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/style.dart';

class ContactViewModel {
  ContactViewModel({required PersonRepository repository, Person? person})
    : isMyInfo = person == null,
      contact = person == null ? repository.getMyInfo() : Future.value(person);

  final bool isMyInfo;
  final Future<Person> contact;
}

class ContactView extends StatelessWidget {
  const ContactView({super.key, required this.viewModel});

  final ContactViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryViewLayout(
      title: viewModel.isMyInfo ? l10n.userPersonalInfo : l10n.contactTitle,
      titleActions: [
        IconButton(
          key: const ValueKey('contact-edit-button'),
          tooltip: l10n.contactEdit,
          onPressed: null,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
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
          return ListView(
            key: const ValueKey('contact-details'),
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: surfaceMutedColor,
                child: ListTile(
                  key: const ValueKey('contact-name'),
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.contactName),
                  subtitle: Text(person.name),
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.contactAddresses, style: styleSectionTitle),
              const SizedBox(height: 12),
              if (person.locations.isEmpty) Text(l10n.contactNoAddresses),
              for (final location in person.locations)
                Card(
                  color: surfaceMutedColor,
                  child: ListTile(
                    key: ValueKey('contact-location-${location.id}'),
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(location.name),
                    subtitle: Text(
                      [
                        getCountryName(location.countryCode, l10n),
                        if (location.address?.trim().isNotEmpty ?? false)
                          location.address!,
                      ].join('\n'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
