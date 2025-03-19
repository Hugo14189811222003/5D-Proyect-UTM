import 'package:proyect_app/models/HistorialMedico/modeloEnfermedad/enfermedad.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Enfermedades>> obtenerEnfermedades(int historialMedicoId) async {
  final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico/enfermedades/$historialMedicoId");

  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));

    print("🔄 Estado de respuesta: ${response.statusCode}");
    print("📥 Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Verificar si la respuesta contiene la clave "$values" para acceder a las enfermedades
      if (jsonResponse.containsKey("\$values")) {
        List<dynamic> listaEnfermedades = jsonResponse["\$values"];
        return listaEnfermedades.map((enfermedad) => Enfermedades.fromJson(enfermedad)).toList();
      } else {
        print("⚠️ No se encontraron enfermedades en la respuesta.");
        return [];
      }
    } else {
      print("❌ Error al obtener enfermedades: ${response.body}");
      return [];
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception('Error de conexión: $err');
  }
}



Future<void> crearEnfermedad(Enfermedades nuevaEnfermedad) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/${nuevaEnfermedad.historialMedicoId}/enfermedades';

  try {
    final uri = Uri.parse(apiUrl);

    // Convertir el objeto Enfermedad a JSON usando el método toJson()
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(nuevaEnfermedad.toJson()),  // Usamos el modelo y lo convertimos a JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Enfermedad ingresada de forma exitosa");
      print(response.body);
      return;
    } else {
      print("❌ Error al insertar enfermedad: ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (err) {
    print('⚠️ Error en el servidor: ${err}');
  }
}

 Future<void> actualizarEnfermedad(int enfermedadId, EnfermedadPut enfermedadsActualizada) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/enfermedades/$enfermedadId'; 

  try {
    final uri = Uri.parse(apiUrl);
    final requestBody = json.encode(enfermedadsActualizada.toJson());

    print("📤 Enviando solicitud PUT a: $apiUrl");
    print("📋 Datos enviados: $requestBody");

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: requestBody, 
    );

    print("🔄 Estado de respuesta: ${response.statusCode}");
    print("📥 Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Tratamiento actualizado de forma exitosa");
    } else {
      print("❌ Error al actualizar tratamiento: ${response.statusCode} - ${response.body}");
    }
  } catch (err) {
    print('⚠️ Error en el servidor: $err');
  }
}

Future<void> eliminarEnfermedad(int enfermedadId) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/vacunas/$enfermedadId';

  try {
    final uri = Uri.parse(apiUrl);
    final response = await http.delete(uri, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Vacuna eliminada con éxito.");
    } else {
      print("❌ Error al eliminar la vacuna: ${response.statusCode} - ${response.body}");
      throw Exception("Error al eliminar la vacuna.");
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception("Error de conexión al intentar eliminar la vacuna.");
  }
}

