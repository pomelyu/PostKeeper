import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/style.dart';

class ContactAddresses extends StatelessWidget {
  const ContactAddresses({
    super.key,
    required this.locations,
    required this.saving,
    required this.onAdd,
    required this.onDelete,
  });

  final List<Location> locations;
  final bool saving;
  final VoidCallback onAdd;
  final ValueChanged<Location> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      key: const ValueKey('contact-address-list'),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.contactAddresses, style: sectionTextStyle),
            ),
            IconButton(
              key: const ValueKey('contact-add-address'),
              onPressed: saving ? null : onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        sectionVerticalSpace,
        if (locations.isEmpty) Text(l10n.contactNoAddresses),
        for (final location in locations)
          Card(
            color: surfaceMutedColor,
            child: ListTile(
              key: ValueKey('contact-location-${location.id}'),
              trailing: IconButton(
                key: ValueKey('contact-delete-address-${location.id}'),
                onPressed: saving ? null : () => onDelete(location),
                icon: const Icon(Icons.delete_outline),
              ),
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
  }
}
