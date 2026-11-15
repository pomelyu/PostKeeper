import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardImage extends StatelessWidget {
  const PostcardImage({
    super.key,
    required this.postcard,
    required this.showBack,
  });
  final Postcard postcard;
  final bool showBack;
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x206B583C),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        showBack ? postcard.backImagePath : postcard.frontImagePath,
        key: ValueKey(
          showBack ? 'postcard-back-image' : 'postcard-front-image',
        ),
        height: postcard.orientation == PostcardOrientation.landscape
            ? 240
            : 300,
        fit: BoxFit.contain,
      ),
    ),
  );
}
