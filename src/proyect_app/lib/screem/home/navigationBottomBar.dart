import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navigationbottombar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const Navigationbottombar({
    super.key,
    required this.currentIndex,
    required this.onTap
    });

  @override
  State<Navigationbottombar> createState() => _NavigationbottombarState();
}

class _NavigationbottombarState extends State<Navigationbottombar> {
  int _selectIndex = 0;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        final screemHeight = constraints.maxHeight;
        final screemWidth = constraints.maxWidth;
        bool screemCompareHeightAndScreemWidth = screemWidth > screemWidth;
        return BottomAppBar(
          color: const Color.fromARGB(255, 0, 132, 103),
          height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Container(
                        width: screemWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.currentIndex == 1 ? const Color.fromARGB(255, 0, 116, 90) : const Color.fromARGB(0, 0, 116, 91)
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.home_outlined, color: Colors.white, size: screemHeight * 0.035,),
                            Text("Inicio", style: GoogleFonts.fredoka(color: Colors.white, fontSize: screemHeight * 0.015),)
                          ],
                        ),
                      ),
                    onTap: () => widget.onTap(1)
                  ),
                  GestureDetector(
                      child: Container(
                        width: screemWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.currentIndex == 5 ? const Color.fromARGB(255, 0, 116, 91) : const Color.fromARGB(0, 0, 116, 91)
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.pets_outlined, color: Colors.white, size: screemHeight * 0.034,),
                            Text("Mascotas", style: GoogleFonts.fredoka(color: Colors.white, fontSize: screemHeight * 0.015),)
                          ],
                        ),
                      ),
                    onTap: () => widget.onTap(5)
                  ),
                  GestureDetector(
                      child: Container(
                        width: screemWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.currentIndex == 4 ? const Color.fromARGB(255, 0, 116, 91) : const Color.fromARGB(0, 0, 116, 91)
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.place_outlined, color: Colors.white, size: screemHeight * 0.035,),
                            Text("Veterinarias", style: GoogleFonts.fredoka(color: Colors.white, fontSize: screemHeight * 0.015),)
                          ],
                        ),
                      ),
                    onTap: () => widget.onTap(4)
                  ),
                  GestureDetector(
                      child: Container(
                        width: screemWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.currentIndex == 2 ? const Color.fromARGB(255, 0, 116, 91) : const Color.fromARGB(0, 0, 116, 91)
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.medication_outlined, color: Colors.white, size: screemHeight * 0.035,),
                            Text("Guías", style: GoogleFonts.fredoka(color: Colors.white, fontSize: screemHeight * 0.015),)
                          ],
                        ),
                      ),
                    onTap: () => widget.onTap(2)
                  ),
                  /*GestureDetector(
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.currentIndex == 3 ? const Color.fromARGB(255, 0, 116, 91) : const Color.fromARGB(0, 0, 116, 91)
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.analytics_outlined, color: Colors.white, size: screemHeight * 0.035,),
                            Text("Monitoreo", style: GoogleFonts.fredoka(color: Colors.white, fontSize: screemHeight * 0.015),)
                          ],
                        ),
                      ),
                    onTap: () => widget.onTap(3)
                  ),*/
                ],
              ),
        );
      }
    );
  }
}