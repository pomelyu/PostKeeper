import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/primary_view_layout.dart';
import 'package:postkeeper/ui/core/secondary_view_layout.dart';
import 'package:postkeeper/ui/core/utils.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/style.dart';

class CollectionView extends StatelessWidget {
  const CollectionView({super.key, required this.collection});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return SecondaryViewLayout(
      title: decodeCollectionName(collection, AppLocalizations.of(context)),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: collection.postcards.length,
        itemBuilder: (context, index) {
          return PostcardItem(postcard: collection.postcards[index]);
        },
      ),
    );
  }
}

class PostcardItem extends StatelessWidget {
  const PostcardItem({super.key, required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    final String title;
    if (postcard.title == null) {
      title = "${postcard.sender.name} to ${postcard.recipient.name}";
    } else {
      title = postcard.title!;
    }
    return Column(
      children: [
        Expanded(
          child: ClipRect(
            child: PostcardFrame(postcard: postcard, fit: BoxFit.cover),
          ),
        ),
        Text(
          title,
          style: styleBody,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
