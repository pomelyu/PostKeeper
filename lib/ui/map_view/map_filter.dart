import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/style.dart';

class MapFilter extends StatelessWidget {
  const MapFilter({
    super.key,
    required this.countryCode,
    required this.freeBrowse,
    required this.countries,
    required this.onChanged,
  });

  final String? countryCode;
  final bool freeBrowse;
  final List<String> countries;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        const Icon(
          Icons.filter_alt_outlined,
          color: surfacePrimaryColor,
          size: 28,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 240),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: const ValueKey('map-country-dropdown'),
                value: freeBrowse ? null : countryCode ?? '*',
                hint: const SizedBox.shrink(),
                isExpanded: true,
                items: [
                  DropdownMenuItem<String>(
                    value: '*',
                    child: Text(l10n.mapAllCountries),
                  ),
                  for (final code in countries)
                    DropdownMenuItem(
                      value: code,
                      child: Text(
                        getCountryName(code, l10n),
                        key: ValueKey('map-country-$code'),
                      ),
                    ),
                ],
                onChanged: (code) => onChanged(code == '*' ? null : code),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
