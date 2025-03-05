import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyect_app/models/recordatorioModelo.dart';

Future<void> crearRecordatorios(Recordatorio newRecordatorio) async {
  const String apiUrl = 'https://petpalzapi.onrender.com/api/Recordatorio';

  try{
    final uri = Uri.parse(apiUrl);
    final response = await http.post(uri, headers: {"Content-Type": "application/json"}, body: json.encode(newRecordatorio.toJson()));
    if(response.statusCode == 200 || response.statusCode == 201){
      print("se ingreso el recordatorio de forma exitosa");
      print(response);
      return;
    } else {
      print("Error al insertar ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (err) {
    print('Error en el servidor: ${err}');
  }
}

Future<List<RecordatorioGet>> ObtenerRecordatorios(int page) async {
  final apiUrl = "https://petpalzapi.onrender.com/api/Recordatorio?pageNumber=$page&pageSize=10000";

  try {
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);

    print("📡 Respuesta API completa (${response.statusCode}): ${response.body}");


    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

      // 🔥 Verificar si contiene la clave "$values"
      if (decodedData is Map<String, dynamic> && decodedData.containsKey("\$values")) {
        final List<dynamic> listaRecordatorios = decodedData["\$values"];
        return listaRecordatorios.map((json) => RecordatorioGet.fromJson(json)).toList();
      } else {
        throw Exception("La respuesta de la API no tiene la clave '\$values': $decodedData");
      }
    } else {
      throw Exception("Error al obtener los recordatorios: ${response.body}");
    }
  } catch (err) {
    throw Exception("Error del servidor: ${err}");
  }
}

Future<void> updateRecordatorios(Recordatorio recordatorio, int id) async {
  final url = Uri.parse("https://petpalzapi.onrender.com/api/Recordatorio/$id");
  print("url parseado?: ${url}");
  try{
    final response = await http.put(url, headers: {"Content-Type": "application/json"}, body: json.encode({
      "tipo": recordatorio.tipo,
      "nombre": recordatorio.nombre,
      "descripcion": recordatorio.descripcion,
      "frecuencia": recordatorio.frecuencia,
      "hora": recordatorio.hora.toIso8601String().substring(11)
    }));
    print("API de estado (${response.statusCode}): ${response.body}");
    print("respuesta obteniendo datos: ${response.body}");
    if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204){
      print("Los datos se han actualizado");
    } else {
      throw Exception("problemas con los datos: ${response.body}");
    }
  } catch (err) {
    print("Problema con el servidor: ${err}");
  }
}

