import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/router.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardFrame extends StatelessWidget {
  const PostcardFrame({super.key, required this.postcard, this.fit,});

  final Postcard? postcard;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (postcard == null) {
      return ColoredBox(
        color: backgroundColor,
        child: Center(
          child: Text(
            l10n.mainNoPostcards,
            textAlign: TextAlign.center,
            style: styleBody,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(postcardViewURI, extra: postcard);
        },
        child: Image.asset(
          postcard!.frontImagePath,
          width: double.infinity,
          height: double.infinity,
          fit: fit,
        ),
      ),
    );
  }
}
