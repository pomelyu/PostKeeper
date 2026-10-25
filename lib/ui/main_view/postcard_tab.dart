import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';

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
                latestReceived == null
                    ? Center(
                        key: ValueKey('main-received-content'),
                        child: Text(l10n.mainNoPostcards),
                      )
                    : PostcardFrame(
                        key: const ValueKey('main-received-content'),
                        postcard: latestReceived!,
                      ),
                latestSent == null
                    ? Center(
                        key: ValueKey('main-sent-content'),
                        child: Text(l10n.mainNoPostcards),
                      )
                    : PostcardFrame(
                        key: const ValueKey('main-sent-content'),
                        postcard: latestSent!,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
