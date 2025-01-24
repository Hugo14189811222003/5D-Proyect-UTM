import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:proyect_app/models/models.dart';

Future<List<Usuario>> fetchUsuarios(int page) async {
  // Agregar paginación si es necesario
  final url = Uri.parse('https://nodejs-mysql-railwey-production.up.railway.app/api/usuarios?page=$page');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print(response.body);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Usuario.fromJson(json)).toList();
  } else {
    throw Exception("Error al cargar a los usuarios");
  }
}
