import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/l10n/app_localizations.dart';
import 'package:postkeeper/ui/style.dart';

class PostcardEditImages extends StatelessWidget {
  const PostcardEditImages({
    super.key,
    required this.postcard,
    required this.showBack,
    required this.onSideSelected,
    required this.image,
    required this.importing,
    required this.onCamera,
    required this.onGallery,
  });

  final Uint8List? image;
  final bool importing;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final Postcard? postcard;
  final bool showBack;
  final ValueChanged<bool> onSideSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PostcardEditSideSelector(
        showBack: showBack,
        onSideSelected: onSideSelected,
      ),
      Flexible(
        flex: 2,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            'assets/illustrations/illustration-tiger-camera.png',
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
      ),
      Expanded(
        flex: 12,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: selectionColor,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(sectionSpacing),
                  child: image != null
                      ? Image.memory(
                          image!,
                          key: ValueKey(
                            showBack
                                ? 'postcard-edit-back-image'
                                : 'postcard-edit-front-image',
                          ),
                          fit: BoxFit.contain,
                        )
                      : postcard == null
                      ? const SizedBox.expand(
                          key: ValueKey('postcard-edit-empty-image'),
                        )
                      : Image.asset(
                          showBack
                              ? postcard!.backImagePath
                              : postcard!.frontImagePath,
                          key: ValueKey(
                            showBack
                                ? 'postcard-edit-back-image'
                                : 'postcard-edit-front-image',
                          ),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              PostcardEditImportActions(
                onCamera: importing ? null : onCamera,
                onGallery: importing ? null : onGallery,
              ),
            ],
          ),
        ),
      ),
      Spacer(flex: 1),
    ],
  );
}

class PostcardEditSideSelector extends StatelessWidget {
  const PostcardEditSideSelector({
    super.key,
    required this.showBack,
    required this.onSideSelected,
  });
  final bool showBack;
  final ValueChanged<bool> onSideSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: surfaceMutedColor,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Row(
        children: [
          for (final back in [false, true])
            Expanded(
              child: TextButton(
                key: ValueKey(
                  back ? 'postcard-edit-back-tab' : 'postcard-edit-front-tab',
                ),
                style: collectionTabStyle(showBack == back),
                onPressed: () => onSideSelected(back),
                child: Text(back ? l10n.postcardBack : l10n.postcardFront),
              ),
            ),
        ],
      ),
    );
  }
}

class PostcardEditImportActions extends StatelessWidget {
  const PostcardEditImportActions({
    super.key,
    required this.onCamera,
    required this.onGallery,
  });
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: surfaceMutedColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextButton.icon(
                key: const ValueKey('postcard-edit-camera'),
                style: primaryActionStyle,
                onPressed: onCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l10n.postcardEditCamera),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextButton.icon(
                key: const ValueKey('postcard-edit-gallery'),
                style: secondaryActionStyle,
                onPressed: onGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.postcardEditGallery),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
