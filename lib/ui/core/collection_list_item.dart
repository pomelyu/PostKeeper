import 'package:flutter/material.dart';
import 'package:postkeeper/ui/style.dart';

/// Displays a collection summary and delegates navigation to its caller.
class CollectionListItem extends StatelessWidget {
  const CollectionListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.artwork,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? artwork;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: styleSectionTitle),
        subtitle: Text(subtitle),
        trailing: artwork == null
            ? const Icon(Icons.chevron_right)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [artwork!, const Icon(Icons.chevron_right)],
              ),
        onTap: onTap,
      ),
    );
  }
}
