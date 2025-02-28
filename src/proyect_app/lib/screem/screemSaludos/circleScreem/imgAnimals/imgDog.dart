import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class dogImg extends StatelessWidget {
  final double responseScale;
  final double width;
  final double height;

  const dogImg({
    super.key,
    required this.responseScale,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
            left: width * 0.3,
            bottom: height * 0.45,
          child: FadeInLeft(
            duration: Duration(milliseconds: 950),
              curve: Curves.bounceInOut,
              child: Image.network(
                'https://cdn.pixabay.com/photo/2020/06/08/22/50/dog-5276317_1280.png',
                fit: BoxFit.contain,
                scale: responseScale,
              ),
          )
        );
  }
}