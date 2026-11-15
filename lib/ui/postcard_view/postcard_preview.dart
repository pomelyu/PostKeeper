import 'package:flutter/material.dart';

class PostcardPreview extends StatefulWidget {
  const PostcardPreview({
    super.key,
    required this.frontImagePath,
    required this.backImagePath,
    required this.rotate,
    this.showBack = false,
  });
  final String frontImagePath;
  final String backImagePath;
  final bool rotate;
  final bool showBack;

  static Future<void> open(
    BuildContext context, {
    required String frontImagePath,
    required String backImagePath,
    required bool rotate,
    required bool showBack,
  }) => showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    barrierDismissible: false,
    pageBuilder: (context, _, _) => PostcardPreview(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      rotate: rotate,
      showBack: showBack,
    ),
  );

  @override
  State<PostcardPreview> createState() => _PostcardPreviewState();
}

class _PostcardPreviewState extends State<PostcardPreview> {
  final _transform = TransformationController();
  final _imageKey = GlobalKey();
  late bool _showBack = widget.showBack;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _tapBackground(TapUpDetails details) {
    final box = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final point = box.globalToLocal(details.globalPosition);
    if (!(Offset.zero & box.size).contains(point)) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    key: const ValueKey('postcard-preview'),
    child: Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const ValueKey('postcard-preview-background'),
            behavior: HitTestBehavior.opaque,
            onTapUp: _tapBackground,
            child: InteractiveViewer(
              transformationController: _transform,
              minScale: 1,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(80),
              clipBehavior: Clip.none,
              child: RotatedBox(
                quarterTurns: widget.rotate ? 1 : 0,
                child: Center(
                  child: Image.asset(
                    _showBack ? widget.backImagePath : widget.frontImagePath,
                    key: _imageKey,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: widget.rotate ? null : 0,
          bottom: widget.rotate ? 0 : null,
          right: 0,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey('postcard-preview-flip'),
                    color: Colors.white,
                    icon: const Icon(Icons.flip),
                    onPressed: () => setState(() => _showBack = !_showBack),
                  ),
                  IconButton(
                    key: const ValueKey('postcard-preview-reset'),
                    color: Colors.white,
                    icon: const Icon(Icons.restart_alt),
                    onPressed: () => _transform.value = Matrix4.identity(),
                  ),
                  IconButton(
                    key: const ValueKey('postcard-preview-close'),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
