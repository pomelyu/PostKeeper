import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardGrid extends StatelessWidget {
  const PostcardGrid({
    super.key,
    required this.postcards,
    this.padding = const EdgeInsets.all(pagePadding),
    this.showDate = false,
  });

  final List<Postcard> postcards;
  final EdgeInsetsGeometry padding;
  final bool showDate;

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: padding,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
    ),
    itemCount: postcards.length,
    itemBuilder: (context, index) =>
        PostcardItem(postcard: postcards[index], showDate: showDate),
  );
}

class PostcardItem extends StatelessWidget {
  const PostcardItem({
    super.key,
    required this.postcard,
    this.showDate = false,
  });

  final Postcard postcard;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final title =
        postcard.title ??
        "${postcard.sender.name} to ${postcard.recipient.name}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cardRadius),
            child: PostcardFrame(postcard: postcard, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: styleBody,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showDate && postcard.sentAt != null)
          Text(
            DateFormat('yyyy.MM.dd').format(postcard.sentAt!),
            style: styleLabel,
          ),
      ],
    );
  }
}
