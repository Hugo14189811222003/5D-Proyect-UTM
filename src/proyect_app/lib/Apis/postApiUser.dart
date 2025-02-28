import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyect_app/models/modelsPost.dart';

Future<bool> createAccount(UsuarioPost newUser) async {
  const String url = 'https://petpalzapi.onrender.com/api/Usuario';

  try{
    final uri = Uri.parse(url);
    final response = await http.post(uri, headers: {'Content-type': 'application/json'}, body: json.encode(newUser.toJson()));
    print(response.body);

    if(response.statusCode == 200 || response.statusCode == 201){
      print('Usuario ingresado con exito');
      print(response);
      return true;
    } else {
      print('Error al ingresar a los usuarios');
      return false;
    }
  } catch (error){
    print("Ha habido un error: $error");
    return false;
  }
}