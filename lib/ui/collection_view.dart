import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/postcard_grid.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/core/utils.dart';

class CollectionView extends StatelessWidget {
  const CollectionView({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return SecondaryViewLayout(
      title: decodeCollectionName(collection, AppLocalizations.of(context)),
      child: PostcardGrid(postcards: collection.postcards),
    );
  }
}
