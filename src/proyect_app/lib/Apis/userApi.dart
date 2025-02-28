import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:proyect_app/models/models.dart';

Future<List<Usuario>> fetchUsuarios(int page) async {
  // Agregar paginación si es necesario
  final url = Uri.parse('https://petpalzapi.onrender.com/api/Usuario?pageNumber=$page&pageSize=10000');
  final response = await http.get(url);

  if (response.statusCode == 200 || response.statusCode == 201) {
    final decodedData = jsonDecode(response.body);

    if (decodedData is Map<String, dynamic> && decodedData.containsKey("\$values")) {
        final List<dynamic> listaRecordatorios = decodedData["\$values"];

        return listaRecordatorios.map((json) => Usuario.fromJson(json)).toList();
      } else {
        throw Exception("La respuesta de la API no tiene la clave '\$values': $decodedData");
      }
  } else {
    throw Exception("Error al cargar a los usuarios");
  }
}
