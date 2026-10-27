import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardTab extends StatelessWidget {
  const PostcardTab({
    super.key,
    required this.latestReceived,
    required this.latestSent,
  });

  final Postcard? latestReceived;
  final Postcard? latestSent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                key: ValueKey('main-received-tab'),
                text: l10n.mainRecentlyReceived,
              ),
              Tab(
                key: ValueKey('main-sent-tab'),
                text: l10n.mainRecentlySent
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                PostcardSummary(
                  key: const ValueKey('main-received-content'),
                  postcard: latestReceived,
                  type: PostcardType.received,
                ),
                PostcardSummary(
                  key: const ValueKey('main-sent-content'),
                  postcard: latestSent,
                  type: PostcardType.sent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostcardSummary extends StatelessWidget {
  const PostcardSummary({
    super.key,
    required this.postcard,
    required this.type,
  });

  final Postcard? postcard;
  final PostcardType type;

  @override
  Widget build(BuildContext context) {
    if (postcard == null) {
      return PostcardFrame(postcard: postcard);
    }

    final Postcard card = postcard!;
    final String message;
    if (type == PostcardType.received) {
      message =
        'From ${card.sender.name}'
        ' @ ${card.sendFrom.name}, '
        '${card.sentAt == null ? '—' : DateFormat('yyyy.MM.dd').format(card.sentAt!)}';
    } else if (type == PostcardType.sent) {
      message =
        'To ${card.recipient.name}'
        ' @ ${card.sendTo.name}, '
        '${card.sentAt == null ? '—' : DateFormat('yyyy.MM.dd').format(card.sentAt!)}';
    } else {
      throw ArgumentError.value(type, 'type', 'Invalid postcard type');
    }
    final String title;
    if (card.title == null) {
      title = 
        'From ${card.sendFrom.name}'
        'To ${card.sendTo.name}';
    } else {
      title = card.title!;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: PostcardFrame(postcard: postcard),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.left, style: styleSectionTitle),
          const SizedBox(height: 4),
          Text(message, textAlign: TextAlign.left, style: styleBody),
        ],
      ),
    );
  }
}
