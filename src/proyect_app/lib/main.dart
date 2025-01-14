import 'package:flutter/material.dart';
import 'package:proyect_app/screem/login.dart';
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
        "login": (_) => const Login()
      },
      initialRoute: "login",
    );
  }
}