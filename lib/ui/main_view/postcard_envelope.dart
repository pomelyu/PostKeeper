import 'package:flutter/material.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/ui/core/illustration.dart';
import 'package:postkeeper/ui/core/postcard_frame.dart';

/// Reference artwork coordinates are kept in a fixed canvas and scaled together.
/// The photo sits behind the envelope front and the tiger's paws.
class PostcardEnvelope extends StatelessWidget {
  const PostcardEnvelope({super.key, required this.postcard});
  final Postcard? postcard;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 378,
        height: 335,
        child: Stack(
          children: [
            Positioned(
              left: 45,
              top: 63,
              child: Transform.rotate(
                angle: 0.18,
                alignment: Alignment.topLeft,
                child: Container(
                  width: 340,
                  height: 215,
                  padding: const EdgeInsets.all(10),
                  child: PostcardFrame(postcard: postcard, fit: BoxFit.cover),
                ),
              ),
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: Illustration('home-front', width: 378, height: 335),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
