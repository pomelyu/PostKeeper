import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/core/empty_postcard_state.dart';
import 'package:postkeeper/ui/core/layout.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardGrid extends StatelessWidget {
  const PostcardGrid({
    super.key,
    required this.postcards,
    this.showDate = false,
  });

  final List<Postcard> postcards;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    if (postcards.isEmpty) {
      return const EmptyPostcardState(
        key: ValueKey('postcard-grid-empty'),
      );
    }
    return GridView.builder(
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
        bodyVerticalSpace,
        Text(
          title,
          style: bodyTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showDate && postcard.sentAt != null)
          Text(
            DateFormat('yyyy.MM.dd').format(postcard.sentAt!),
            style: labelTextStyle,
          ),
      ],
    );
  }
}
