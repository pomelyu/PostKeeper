import 'package:flutter/material.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/core/illustration.dart';
import 'package:postkeeper/ui/style.dart';

class EmptyPostcardState extends StatelessWidget {
  const EmptyPostcardState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Flexible(
          child: Illustration('tiger-empty', width: 240, height: 240),
        ),
        const SizedBox(height: sectionSpacing),
        Text(
          AppLocalizations.of(context).mainNoPostcards,
          textAlign: TextAlign.center,
          style: styleBody,
        ),
      ],
    ),
  );
}
