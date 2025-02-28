import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Horizontalbody extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const Horizontalbody({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidthBuild = constraints.maxWidth;
            final screenHeightBuild = constraints.maxHeight;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                        margin: EdgeInsets.all(20),
                        width: screenWidth * 0.35,
                        height: screenHeight * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.circle, size: screenHeightBuild * 0.18, color: const Color.fromARGB(255, 226, 226, 226),),
                            Icon(Icons.circle, size: screenHeightBuild * 0.18, color: const Color.fromARGB(255, 226, 226, 226),),
                            Spacer(),
                            Icon(Icons.add, size: screenHeightBuild * 0.050,),
                            SizedBox(width: 15,),
                      
                          ],
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}