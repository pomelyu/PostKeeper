import 'package:flutter/material.dart';

/// Decorative artwork with a reserved footprint while loading or unavailable.
class Illustration extends StatelessWidget {
  const Illustration(this.name, {super.key, this.width = 80, this.height = 80});
  final String name;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Image.asset(
      'assets/illustrations/illustration-$name.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => SizedBox(width: width, height: height),
    ),
  );
}
