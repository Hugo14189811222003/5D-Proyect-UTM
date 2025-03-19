import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyect_app/models/HistorialMedico/modeloVacuna/postVacuna.dart';

Future<List<Vacuna>> obtenerVacunas(int historialMedicoId) async {
  final uri = Uri.parse("https://petpalzapi.onrender.com/api/historial-medico/vacunas/$historialMedicoId");
  print("api el 61: ${historialMedicoId}");

  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));

    print("🔄 Estado de respuesta: ${response.statusCode}");
    print("📥 Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Extraer la lista correcta desde "$values"
      if (jsonResponse.containsKey("\$values")) {
        List<dynamic> listaVacunas = jsonResponse["\$values"];
        return listaVacunas.map((vacuna) => Vacuna.fromJson(vacuna)).toList();
      } else {
        print("⚠️ No se encontraron vacunas en la respuesta.");
        return [];
      }
    } else {
      print("❌ Error al obtener vacunas: ${response.body}");
      return [];
    }
  } catch (err) {
    print("⚠️ Error de conexión: $err");
    throw Exception('Error de conexión: $err');
  }
}



Future<void> crearVacuna(Vacuna nuevaVacuna) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/${nuevaVacuna.historialMedicoId}/vacunas';


  try {
    final uri = Uri.parse(apiUrl);

    // Convertir el objeto Vacuna a JSON usando el método toJson() del modelo
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(nuevaVacuna.toJson()),  // Usamos el modelo y lo convertimos a JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Vacuna ingresada de forma exitosa");
      print(response.body);
      return;
    } else {
      print("❌ Error al insertar vacuna: ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (err) {
    print('⚠️ Error en el servidor: ${err}');
  }
}



Future<void> actualizarVacuna(int vacunaId, VacunaPut vacunaActualizada) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/vacunas/$vacunaId'; // URL con el ID de la vacuna que se quiere actualizar

  try {
    final uri = Uri.parse(apiUrl);

    // Convertir el objeto Vacuna a JSON usando el método toJson()
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(vacunaActualizada.toJson()),  // Usamos el modelo y lo convertimos a JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ tratamiento actualizada de forma exitosa");
      print(response.body);
      return;
    } else {
      print("❌ Error al actualizar tratamientos: ${response.statusCode} - ${response.body}");
      return;
    }
  } catch (err) {
    print('⚠️ Error en el servidor: ${err}');
  }
}

Future<void> eliminarVacuna(int vacunaId) async {
  final String apiUrl = 'https://petpalzapi.onrender.com/api/historial-medico/vacunas/$vacunaId';

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
