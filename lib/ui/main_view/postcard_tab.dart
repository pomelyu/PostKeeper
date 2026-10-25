import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                key: ValueKey('main-received-tab'),
                text: '最近收到',
              ),
              Tab(
                key: ValueKey('main-sent-tab'),
                text: '最近寄出',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                latestReceived == null
                    ? const Center(
                        key: ValueKey('main-received-content'),
                        child: Text('尚無資料'),
                      )
                    : PostcardFrame(
                        key: const ValueKey('main-received-content'),
                        postcard: latestReceived!,
                      ),
                latestSent == null
                    ? const Center(
                        key: ValueKey('main-sent-content'),
                        child: Text('尚無資料'),
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
