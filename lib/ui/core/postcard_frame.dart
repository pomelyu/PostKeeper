import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';

class PostcardFrame extends StatelessWidget {
  const PostcardFrame({super.key, required this.postcard});

  final Postcard? postcard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (postcard == null) {
      return Center(child: Text(l10n.mainNoPostcards));
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(postcardViewURI, extra: postcard);
        },
        child: Image.asset(postcard!.frontImagePath),
      ),
    );
  }
}
