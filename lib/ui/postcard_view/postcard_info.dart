import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/geography_names.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardInfo extends StatelessWidget {
  const PostcardInfo({super.key, required this.postcard});
  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String location(Location value) => value.id == dummyLocationId
        ? l10n.geoUnknown
        : [
            getCountryName(value.countryCode, l10n),
            value.name,
          ].where((part) => part.isNotEmpty).join(' · ');
    String date(DateTime? value) =>
        value == null ? '—' : DateFormat('yyyy.MM.dd').format(value);
    return Column(
      children: [
        const Divider(),
        _InfoRow(
          icon: Icons.send_outlined,
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                postcard.sender.name.isEmpty
                    ? l10n.geoUnknown
                    : postcard.sender.name,
              ),
              const Text('/'),
              Text(location(postcard.sendFrom)),
              const Text('/'),
              Text(date(postcard.sentAt)),
            ],
          ),
        ),
        const Divider(),
        _InfoRow(
          icon: Icons.mail_outline,
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                postcard.recipient.name.isEmpty
                    ? l10n.geoUnknown
                    : postcard.recipient.name,
              ),
              const Text('/'),
              Text(location(postcard.sendTo)),
              const Text('/'),
              Text(date(postcard.receivedAt)),
            ],
          ),
        ),
        const Divider(),
        _InfoRow(icon: Icons.comment_rounded, child: Text(postcard.notes)),
        const Divider(),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.child});
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectionColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: DefaultTextStyle(style: styleBody, child: child),
        ),
      ),
    ],
  );
}

class PostcardInfoScroll extends StatelessWidget {
  const PostcardInfoScroll({super.key, required this.postcard});
  final Postcard postcard;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey('postcard-info-scroll'),
    child: PostcardInfo(postcard: postcard),
  );
}
