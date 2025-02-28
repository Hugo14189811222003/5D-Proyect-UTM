import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:proyect_app/screem/screemSaludos/circleScreem/imgAnimals/imgDog.dart';

class Circle extends StatelessWidget {
  final double width;
  final double height;

  const Circle({
    super.key,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    final double responseScale = ((height + width) / 2) / 135;
    return Stack(
      children: [
        // centro
        Positioned(
            right: width * 0.35,
            top: height * 0.1,
          child: Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        // izquierda
        Positioned(
            right: width * 0.85,
            top: height * 0.27,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        Positioned(
            right: width * 0.65,
            top: height * 0.35,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        Positioned(
            right: width * 0.9,
            top: height * 0.4,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        //derecha
        Positioned(
            right: width * 0.25,
            top: height * 0.1,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        Positioned(
            right: width * 0.1,
            top: height * 0.1,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        //Animal
        dogImg(
          responseScale: responseScale,
          width: width,
          height: height,
        )
      ]
    );
  }
}