import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class catImg extends StatelessWidget {
  final double responseScale;
  final double width;
  final double height;

  const  catImg({
    super.key,
    required this.responseScale,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
            left: width * 0.35,
            bottom: height * 0.33,
          child: FadeInLeft(
            duration: Duration(milliseconds: 950),
              curve: Curves.bounceInOut,
              child: Image.network(
                'https://pngimg.com/uploads/cat/cat_PNG50437.png',
                fit: BoxFit.contain,
                scale: responseScale,
              ),
          )
        );
  }
}