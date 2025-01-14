import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // tamaño total de la pantalla: ancho y alto
    final screemWidth = MediaQuery.of(context).size.width;
    final screemHeigth = MediaQuery.of(context).size.height;
    // Verificación si la pantalla esta en landScape (volteada horizontalmente)
    final landScape = screemWidth > screemHeigth;

    return Scaffold(
      body: LayoutBuilder(
        builder:(context, constraints) {
          // obtener el maximo tamaño de ancho de un widgets
          final maxWidth = constraints.maxWidth;
          return Column(
              children: [
                // icono usuario
                icon(landScape, screemHeigth, maxWidth, screemWidth),
                //formulario
                Expanded(
                  child: Container(
                        color: Colors.cyan,
                        width: screemWidth,
                        height: screemHeigth,
                        child: Column(
                          children: [
                            Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.email_outlined),
                                        hintText: "Ingresa tu Email"
                                        
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.email_outlined),
                                        hintText: "Ingresa tu Email"
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                )
              ],
            );        
          },
      )
    );
  }

  Container icon(bool landScape, double screemHeigth, double maxWidth, double screemWidth) {
    return Container(
                height: landScape ? screemHeigth * 0.4 : screemHeigth * 0.30,
                width: maxWidth,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(top: 30),
                  child: Icon(
                    Icons.person_2_rounded,
                    size: landScape ? screemWidth * 0.1 : screemWidth * 0.4,
                    color: const Color.fromARGB(255, 0, 140, 255),
                    ),
                ),
                color: const Color.fromARGB(59, 47, 47, 47),
              );
  }
}