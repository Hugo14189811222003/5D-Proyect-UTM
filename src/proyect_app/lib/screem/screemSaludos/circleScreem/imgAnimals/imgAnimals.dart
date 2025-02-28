import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class animalsImg extends StatelessWidget {
  final double responseScale;
  final double width;
  final double height;

  const  animalsImg({
    super.key,
    required this.responseScale,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
            left: width * 0.02,
            bottom: height * 0.45,
          child: FadeInLeft(
            duration: Duration(milliseconds: 950),
              curve: Curves.bounceInOut,
              child: Image.network(
                'https://www.pngall.com/wp-content/uploads/10/Pet-PNG-Clipart-Background.png',
                fit: BoxFit.contain,
                scale: responseScale,
              ),
          )
        );
  }
}