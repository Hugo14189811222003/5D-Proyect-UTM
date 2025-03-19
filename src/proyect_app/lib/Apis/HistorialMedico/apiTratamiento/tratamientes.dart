import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyect_app/models/HistorialMedico/modeloTratamiento/tratamiento.dart';

Future<List<Tratamientos>> obtenerTratamientos(int historialMedicoId) async {
  final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico/tratamientos/$historialMedicoId");

  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));

    print("🔄 Estado de respuesta: ${response.statusCode}");
    print("📥 Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Verificar si la respuesta contiene la clave "$values" para acceder a los tratamientos
      if (jsonResponse.containsKey("\$values")) {
        List<dynamic> listaTratamientos = jsonResponse["\$values"];
        return listaTratamientos.map((tratamiento) => Tratamientos.fromJson(tratamiento)).toList();
      } else {
        print("⚠️ No se encontraron tratamientos en la respuesta.");
        return [];
      }
    } else {
      print("❌ Error al obtener tratamientos: ${response.body}");
      return [];
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception('Error de conexión: $err');
  }
}



Future<void> crearTratamiento(Tratamientos nuevoTratamiento) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/${nuevoTratamiento.historialMedicoId}/tratamientos';

  try {
    final uri = Uri.parse(apiUrl);

    // Convertir el objeto Tratamiento a JSON usando el método toJson()
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(nuevoTratamiento.toJson()),  // Usamos el modelo y lo convertimos a JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Tratamiento ingresado de forma exitosa");
      print(response.body);
      return;
    } else {
      print("❌ Error al insertar tratamiento: ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (err) {
    print('⚠️ Error en el servidor: ${err}');
  }
}

 Future<void> actualizarTratamientos(int tratamientoId, TratamientoPut tratamientosActualizada) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/tratamientos/$tratamientoId'; 

  try {
    final uri = Uri.parse(apiUrl);
    final requestBody = json.encode(tratamientosActualizada.toJson());

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

Future<void> eliminarTratamiento(int tratamientoId) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/vacunas/$tratamientoId';

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
