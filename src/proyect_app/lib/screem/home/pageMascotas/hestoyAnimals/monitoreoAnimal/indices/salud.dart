import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyect_app/Apis/apiMonitoreo/apiMonitoreo.dart';
import 'package:proyect_app/models/monitoreo/modeloMonitoreo.dart';
import 'package:proyect_app/screem/home/pageMonitoreo/verticalMonitoreo.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje1.dart';
import 'package:proyect_app/screem/home/porcentaje/circlePorcentaje2.dart';

class salud extends StatefulWidget {
  final mascotaSeleccionadaIdHistorial;
  const salud({super.key, this.mascotaSeleccionadaIdHistorial});

  @override
  _saludState createState() => _saludState();
}

class _saludState extends State<salud> {
  // Controladores de los campos de texto
  final _formKey = GlobalKey<FormState>();
  TextEditingController temperaturaController = TextEditingController();
  TextEditingController pulsoController = TextEditingController();
  TextEditingController respiracionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int idMascota = widget.mascotaSeleccionadaIdHistorial ?? 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,  // Elimina la flecha de retroceso
        title: Text("Meter valor"),
        backgroundColor: const Color.fromARGB(255, 237, 237, 237),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: const Color.fromARGB(255, 91, 91, 91),  // Cambia el color del icono
            onPressed: () {
              // Mostrar el formulario cuando se presione el botón
              _showFormDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  temperatura(idMascota),
                  pulso(idMascota),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  respiracion(idMascota)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de formulario para ingresar datos
  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Actualizar Datos de Salud"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: temperaturaController,
                  decoration: InputDecoration(labelText: "Temperatura"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la temperatura';
                    }
                    final numValue = int.tryParse(value);
                    if(numValue == null || numValue < 1 || numValue > 100) {
                      return 'Favor de ingresar un numero del 1 al 1000';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pulsoController,
                  decoration: InputDecoration(labelText: "Pulso"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el pulso';
                    }
                    final numValue = int.tryParse(value);
                    if(numValue == null || numValue < 1 || numValue > 100) {
                      return 'Favor de ingresar un numero del 1 al 1000';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: respiracionController,
                  decoration: InputDecoration(labelText: "Respiración"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la respiración';
                    }
                    final numValue = int.tryParse(value);
                    if(numValue == null || numValue < 1 || numValue > 100) {
                      return 'Favor de ingresar un numero del 1 al 1000';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Ocultar el teclado
                  FocusScope.of(context).unfocus();

                  final temperatura = int.tryParse(temperaturaController.text) ?? 0;
                  final pulso = int.tryParse(pulsoController.text) ?? 0;
                  final respiracion = int.tryParse(respiracionController.text) ?? 0;

                  // Validar que los campos no estén vacíos o nulos
                  if (temperatura == 0 || pulso == 0 || respiracion == 0) {
                    print("Por favor, ingresa todos los datos correctamente.");
                    return;
                  }
                  String fechaRegistro = DateTime.now().toIso8601String();
                  Monitoreo monitoreo = Monitoreo(
                    pulso: pulso,
                    temperatura: temperatura,
                    respiracion: respiracion, 
                    vfc: 0, 
                    latitud: 0, 
                    longitud: 0, 
                    mascotaId: widget.mascotaSeleccionadaIdHistorial, 
                    fechaRegistro: fechaRegistro,
                  );

                  try {
                    // Usamos el valor booleano de la respuesta
                    bool success = await postMonitoreo(monitoreo);

                    if (success) {
                      print("Datos actualizados: Temperatura: $temperatura, Pulso: $pulso, Respiración: $respiracion");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Datos actualizados exitosamente")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error al guardar los datos")),
                      );
                    }
                  } catch (e) {
                    print("Error al enviar datos: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al guardar los datos")),
                    );
                  }

                  Navigator.of(context).pop(); // Cerrar el formulario
                }
              },
              child: Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  // Aquí puedes seguir usando los métodos existentes para mostrar los círculos
  Padding respiracion(int mascotaId) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: LayoutBuilder(
        builder: (context, Constraints) {
          final screenConstrainWight = Constraints.maxWidth;
          final screenConstrainHeight = Constraints.maxHeight;
          return Container(
            height: MediaQuery.of(context).size.height * 0.29,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "Respiración",
                    style: GoogleFonts.fredoka(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: circlePorce2(key: ValueKey(mascotaId) ,mascotaId: mascotaId),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  GestureDetector(
                    onTap: () {
                      print("detalles de respiración");
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: screenConstrainWight * 0.5,
                      height: screenConstrainHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 204, 196, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Detalles",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            color: const Color.fromARGB(255, 83, 68, 141),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding pulso(int mascotaId) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: LayoutBuilder(
        builder: (context, Constraints) {
          final screenConstrainWight = Constraints.maxWidth;
          final screenConstrainHeight = Constraints.maxHeight;
          return Container(
            height: MediaQuery.of(context).size.height * 0.29,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "Pulso",
                    style: GoogleFonts.fredoka(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: circlePorce1(key: ValueKey(mascotaId),mascotaId: mascotaId),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  GestureDetector(
                    onTap: () {
                      print("detalles de pulso");
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: screenConstrainWight * 0.5,
                      height: screenConstrainHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 204, 196, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Detalles",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            color: const Color.fromARGB(255, 83, 68, 141),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding temperatura(int mascotaId) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: LayoutBuilder(
        builder: (context, Constraints) {
          final screenConstrainWight = Constraints.maxWidth;
          final screenConstrainHeight = Constraints.maxHeight;
          return Container(
            height: MediaQuery.of(context).size.height * 0.29,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "Temperatura",
                    style: GoogleFonts.fredoka(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: CircleApp(key: ValueKey(mascotaId),mascotaId: mascotaId),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  GestureDetector(
                    onTap: () {
                      print("detalles de temperatura");
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: screenConstrainWight * 0.5,
                      height: screenConstrainHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 204, 196, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Detalles",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            color: const Color.fromARGB(255, 83, 68, 141),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
