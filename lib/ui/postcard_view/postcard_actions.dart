import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardActions extends StatelessWidget {
  const PostcardActions({
    super.key,
    required this.postcard,
    required this.showBack,
    required this.onSideSelected,
    required this.onEdit,
  });
  final Postcard postcard;
  final bool showBack;
  final ValueChanged<bool> onSideSelected;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              for (final back in [false, true])
                Expanded(
                  child: TextButton(
                    key: ValueKey(
                      back ? 'postcard-back-tab' : 'postcard-front-tab',
                    ),
                    style: collectionTabStyle(showBack == back),
                    onPressed: () => onSideSelected(back),
                    child: Text(back ? l10n.postcardBack : l10n.postcardFront),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          key: const ValueKey('postcard-favorite-button'),
          tooltip: l10n.keeperFavorite,
          onPressed: null,
          icon: Icon(
            postcard.isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
        ),
        IconButton(
          key: const ValueKey('postcard-edit-button'),
          onPressed: () => onEdit(),
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}
