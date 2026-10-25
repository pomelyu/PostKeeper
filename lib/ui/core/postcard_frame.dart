import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';

class PostcardFrame extends StatelessWidget {
  const PostcardFrame({super.key, required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Image.asset(postcard.frontImagePath),
      ),
    );
  }
}
