import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyect_app/firebase_options.dart';
import 'package:proyect_app/screem/home/home.dart';
import 'package:proyect_app/screem/home/horizontalBody.dart';
import 'package:proyect_app/screem/home/pageGu%C3%ADas/verticalGuiasBody.dart';
import 'package:proyect_app/screem/home/pageGu%C3%ADas/listCategoria/listCategoria.dart';
import 'package:proyect_app/screem/home/pageHome/verticaBoody.dart';
import 'package:proyect_app/screem/home/pageMascotas/crearMascota/crearMascota.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/historyAnimals.dart';
import 'package:proyect_app/screem/home/pageMascotas/hestoyAnimals/monitoreoAnimal/monitoreoAnimal.dart';
import 'package:proyect_app/screem/home/pageMascotas/mascota.dart';
import 'package:proyect_app/screem/list.dart';
import 'package:proyect_app/screem/screemLoginRegister/login.dart';
import 'package:proyect_app/screem/screemLoginRegister/register.dart';
import 'package:proyect_app/screem/screemSaludos/screemSet1.dart';
import 'package:proyect_app/screem/screemSaludos/screemSet2.dart';
import 'package:proyect_app/screem/screemSaludos/screemSet3.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Bloquear la orientación en modo vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Solo permite orientación vertical normal
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  initState() {
    super.initState();
    ObtencionDeCurrentIndex();
  }
  int? indexCurrent;

  Future<void> ObtencionDeCurrentIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? stringCurren = await pref.getString('currentIndex');
    setState(() {
      indexCurrent = stringCurren != null ? int.tryParse(stringCurren) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "register": (_) => const Register(),
        "login": (_) => const Login(),
        "listInfinity": (_) => const ListaUsuario(),
        "home": (context) {
          // Verificamos si el valor de indexCurrent está disponible
          if (indexCurrent == null) {
            indexCurrent = 1;
          }
          // Una vez que indexCurrent esté disponible, pasamos el valor a Home
          return Home(indexSeleccionado: indexCurrent ?? 0);
        },
        "set1": (_) => const set1(),
        "set2": (_) => const set2(),
        "set3": (_) => const set3(),
        "horizontalScreem": (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Horizontalbody(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          );
        },
        "verticalScreem": (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return verticalBody(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            screenHorizontal: screenWidth > screenHeight,
          );
        },
        "Verticalguiasbody": (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          return Verticalguiasbody(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          );
        },
        "listCategoria": (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          return Listcategoria(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          );
        },
        "mascotasPage": (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          return mascotasPage(
            screenWidth: screenWidth,
            screenHeight: screenHeight
          );
        },
        "Crearmascota": (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          return Crearmascota(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          );
        },
        // "historyAnimals": (_) => const historyAnimals(),
        "monitoreAnimal": (_) => const monitoreAnimal()
      },
      initialRoute: "login",
    );
  }
}
