import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/style.dart';

/// Map placeholder: plain text only until the map implementation is available.
class MapRegion extends StatelessWidget {
  const MapRegion({super.key, required this.postcards});
  final List<Postcard> postcards;

  @override
  Widget build(BuildContext context) => ListView.builder(
    key: const ValueKey('map-placeholder'),
    padding: EdgeInsets.zero,
    itemCount: postcards.length,
    itemBuilder: (context, index) {
      final card = postcards[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          '${card.title ?? '${card.sender.name} → ${card.recipient.name}'}: ${card.sendFrom.name} → ${card.sendTo.name}',
          style: styleBody,
        ),
      );
    },
  );
}
