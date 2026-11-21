import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardEditPureTextField extends StatelessWidget {
  const PostcardEditPureTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.controller,
  });
  final String fieldKey;
  final String label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) =>
      _DetailField(fieldKey: fieldKey, label: label, controller: controller);
}

class PostcardEditPeopleField extends StatelessWidget {
  const PostcardEditPeopleField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.people,
    required this.onSelected,
    required this.onChanged,
  });
  final String fieldKey;
  final TextEditingController controller;
  final List<Person> people;
  final ValueChanged<Person> onSelected;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => _DetailField(
    fieldKey: fieldKey,
    leadingIcon: Icons.person_outline,
    controller: controller,
    onChanged: onChanged,
    suffix: PopupMenuButton<Person>(
      key: ValueKey('postcard-edit-$fieldKey-menu'),
      enabled: people.isNotEmpty,
      onOpened: () => FocusManager.instance.primaryFocus?.unfocus(),
      icon: const Icon(Icons.expand_more, size: 22),
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final person in people)
          PopupMenuItem(
            value: person,
            key: ValueKey('person-option-$fieldKey-${person.id}'),
            child: Text(person.name),
          ),
      ],
    ),
  );
}

class PostcardEditDateField extends StatelessWidget {
  const PostcardEditDateField({
    super.key,
    required this.fieldKey,
    required this.value,
    required this.onSelected,
  });
  final String fieldKey;
  final DateTime? value;
  final ValueChanged<DateTime> onSelected;
  @override
  Widget build(BuildContext context) => _DetailField(
    fieldKey: fieldKey,
    leadingIcon: Icons.access_time,
    value: value == null ? '' : DateFormat('yyyy.MM.dd').format(value!),
    readOnly: true,
    suffix: IconButton(
      key: ValueKey('postcard-edit-$fieldKey-calendar'),
      icon: const Icon(Icons.calendar_month_outlined, size: 22),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final initialDate = value ?? DateTime.now();
        final selected = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(
            initialDate.year < 1800 ? initialDate.year : 1800,
          ),
          lastDate: DateTime(
            initialDate.year > 2200 ? initialDate.year : 2200,
            12,
            31,
          ),
        );
        if (selected != null && context.mounted) onSelected(selected);
      },
    ),
  );
}

class PostcardEditLocationField extends StatelessWidget {
  const PostcardEditLocationField({
    super.key,
    required this.fieldKey,
    required this.value,
    required this.locations,
    required this.onSelected,
    required this.onMap,
  });
  final String fieldKey;
  final Location? value;
  final List<Location> locations;
  final ValueChanged<Location> onSelected;
  final VoidCallback onMap;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String name(Location location) => location.id == dummyLocationId
        ? l10n.geoUnknown
        : [
            getCountryName(location.countryCode, l10n),
            location.name,
          ].where((part) => part.isNotEmpty).join(' · ');
    return _DetailField(
      fieldKey: fieldKey,
      leadingIcon: Icons.location_on_outlined,
      value: value == null ? '' : name(value!),
      readOnly: true,
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<Location>(
            key: ValueKey('postcard-edit-$fieldKey-menu'),
            enabled: locations.isNotEmpty,
            onOpened: () => FocusManager.instance.primaryFocus?.unfocus(),
            icon: const Icon(Icons.expand_more, size: 22),
            onSelected: onSelected,
            itemBuilder: (_) => [
              for (final location in locations)
                PopupMenuItem(
                  value: location,
                  key: ValueKey('location-option-$fieldKey-${location.id}'),
                  child: Text(name(location)),
                ),
            ],
          ),
          const SizedBox(height: 24, child: VerticalDivider(width: 1)),
          IconButton(
            key: ValueKey('postcard-edit-$fieldKey-map'),
            onPressed: onMap,
            icon: const Icon(Icons.map_outlined, size: 22),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.fieldKey,
    this.label = '',
    this.value = '',
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.suffix,
    this.leadingIcon,
  });
  final IconData? leadingIcon;
  final String fieldKey;
  final String label;
  final String value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.zero,
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey(
              'postcard-edit-$fieldKey${readOnly ? '-$value' : ''}',
            ),
            controller: controller,
            initialValue: controller == null ? value : null,
            onChanged: onChanged,
            readOnly: readOnly,
            textInputAction: TextInputAction.done,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            style: bodyTextStyle,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: leadingIcon == null ? null : InputBorder.none,
              enabledBorder: leadingIcon == null ? null : InputBorder.none,
              focusedBorder: leadingIcon == null ? null : InputBorder.none,
              filled: leadingIcon == null,
              prefixIcon: SizedBox(
                width: leadingIcon == null ? 90 : 72,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    heightFactor: 1,
                    child: leadingIcon == null
                        ? Text(label, style: sectionTextStyle)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(leadingIcon, size: 24),
                              const SizedBox(
                                height: 24,
                                child: VerticalDivider(width: 1),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints(minHeight: 40),
              prefixIconConstraints: const BoxConstraints(minHeight: 40),
            ),
          ),
        ),
      ],
    ),
  );
}
