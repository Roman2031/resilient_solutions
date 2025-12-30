import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginBackground extends StatelessWidget {
  final Widget? child;
  final String svgAsset; // path to svg asset
  final BoxFit fit;
  final Color? overlayColor; // optional translucent overlay
  final double overlayOpacity;

  const LoginBackground({
    Key? key,
    this.child,
    this.svgAsset = 'assets/svgs/loginbg.svg',
    this.fit = BoxFit.cover,
    this.overlayColor,
    this.overlayOpacity = 0.25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        
        Positioned.fill(
          child: SvgPicture.asset(
            svgAsset,
            fit: fit,
            
          ),
        ),


        if (overlayColor != null)
          Positioned.fill(
            child: Container(
              color: overlayColor!.withOpacity(overlayOpacity),
            ),
          ),

        // Main content
        if (child != null)
          Positioned.fill(
            child: SafeArea(
              child: child!,
            ),
          ),
      ],
    );
  }
}
