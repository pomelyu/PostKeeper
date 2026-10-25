import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/domain/models/postcard.dart';

class PostcardFrame extends StatelessWidget {
  const PostcardFrame({super.key, required this.postcard});

  final Postcard postcard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(postcardViewURI, extra: postcard);
        },
        child: Image.asset(postcard.frontImagePath),
      ),
    );
  }
}
