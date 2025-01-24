import 'package:flutter/material.dart';
import 'package:proyect_app/screem/list.dart';
import 'package:proyect_app/screem/register.dart';
void main(){
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "register": (_) => const Register(),
        "listInfinity": (_) => const ListaUsuario()
      },
      initialRoute: "register",
    );
  }
}