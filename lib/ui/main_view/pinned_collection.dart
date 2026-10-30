import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/core/utils.dart';
import 'package:postkeeper/ui/style.dart';

class PinnedCollection extends StatelessWidget {
  const PinnedCollection({
    super.key,
    this.collections1,
    this.collections2,
  });
  final Collection? collections1;
  final Collection? collections2;

  @override
  Widget build(BuildContext context) {
    final List<CollectionFrame> children = [];
    if (collections1 != null) {
      children.add(CollectionFrame(collection: collections1!));
    }
    if (collections2 != null) {
      children.add(CollectionFrame(collection: collections2!));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }
}

class CollectionFrame extends StatelessWidget {
  const CollectionFrame({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => context.push(collectionViewURI, extra: collection),
          child: Icon(Icons.folder),
        ),
        Text(decodeCollectionName(collection, AppLocalizations.of(context)), style: styleBody),
      ],
    );
  }
}
