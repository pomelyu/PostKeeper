import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/illustration.dart';
import 'package:postkeeper/ui/style.dart';

class UserPanelData {
  const UserPanelData({
    required this.person,
    required this.postcardCount,
    required this.locationCount,
  });
  final Person person;
  final int postcardCount;
  final int locationCount;
}

class UserPanel extends StatelessWidget {
  const UserPanel({super.key, required this.data});
  final UserPanelData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      key: const ValueKey('user-panel'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: selectionColor,
              child: ClipOval(
                child: Illustration('tiger', width: 88, height: 88),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(data.person.name, style: styleDisplayTitle)),
            IconButton(
              key: const ValueKey('user-personal-info'),
              tooltip: l10n.userPersonalInfo,
              onPressed: () => context.push(contactViewURI),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 40,
                  color: surfacePrimaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Statistic(
                    value: l10n.userLocationAmount(data.locationCount),
                    label: l10n.userLocationCountLabel,
                  ),
                ),
                const SizedBox(
                  height: 44,
                  child: VerticalDivider(width: 24, thickness: 1),
                ),
                Expanded(
                  child: _Statistic(
                    value: l10n.userPostcardAmount(data.postcardCount),
                    label: l10n.userPostcardCountLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: styleDisplayTitle),
      Text(label, style: styleLabel),
    ],
  );
}
