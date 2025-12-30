import 'package:flutter/material.dart';

class SvgBackground extends StatelessWidget {
  final String assetPath;
  final Widget child;
  final BoxFit fit;

  const SvgBackground({
    super.key,
    required this.assetPath,
    required this.child,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SVG Background
        Positioned.fill(child: Image.asset(assetPath, fit: fit)),

        // Foreground Content
        child,
      ],
    );
  }
}
