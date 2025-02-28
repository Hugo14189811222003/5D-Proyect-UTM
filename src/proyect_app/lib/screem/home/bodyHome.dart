import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/screem/home/home.dart';
import 'package:proyect_app/screem/home/horizontalBody.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje.dart';
import 'package:proyect_app/screem/home/pageHome/verticaBoody.dart';

class Bodyhome extends StatelessWidget {
  const Bodyhome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool screenHorizontal = screenWidth > screenHeight;

    return Scaffold(
      floatingActionButton: Container(
        width: screenWidth * 0.6,
        height: screenHorizontal ? screenHeight * 0.09 : screenHeight * 0.05,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: screenHorizontal ? Horizontalbody(screenHeight: screenHeight, screenWidth: screenWidth,) : verticalBody(screenWidth: screenWidth, screenHeight: screenHeight, screenHorizontal: screenHorizontal)
    );
  }
}