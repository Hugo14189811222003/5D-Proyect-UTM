import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyect_app/models/models.dart';

Future<Usuario?> fetchUsuarioPorId(int id) async {
  final url = Uri.parse('https://nodejs-mysql-railwey-production.up.railway.app/api/usuarios/$id');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Verificar si la respuesta es una lista
    if (data is List && data.isNotEmpty) {
      // Si es una lista, devuelve el primer usuario
      return Usuario.fromJson(data[0]);
    } else if (data is Map<String, dynamic>) {
      // Si es un único objeto, lo parseamos normalmente
      return Usuario.fromJson(data);
    } else {
      // Si no es ni lista ni objeto válido
      return null;
    }
  } else {
    throw Exception('Error al realizar la búsqueda');
  }
}
