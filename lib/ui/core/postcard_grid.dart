import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardGrid extends StatelessWidget {
  const PostcardGrid({super.key, required this.postcards});

  final List<Postcard> postcards;

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
    ),
    itemCount: postcards.length,
    itemBuilder: (context, index) => PostcardItem(postcard: postcards[index]),
  );
}

class PostcardItem extends StatelessWidget {
  const PostcardItem({super.key, required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    final title =
        postcard.title ??
        "${postcard.sender.name} to ${postcard.recipient.name}";
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
