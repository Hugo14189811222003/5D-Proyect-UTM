class Tratamientos {
  int id;
  String nombre;
  String fechaAplicacion;
  String descripcion;
  int historialMedicoId;

  Tratamientos({
    this.id = 0,  // 🔥 Se asigna 0 por defecto si no se proporciona un id
    required this.nombre,
    required this.fechaAplicacion,
    required this.descripcion,
    required this.historialMedicoId,
  });

  factory Tratamientos.fromJson(Map<String, dynamic> json) {
    return Tratamientos(
      id: json["id"] ?? 0,  // 🔥 Si no hay ID en la API, se asigna 0
      nombre: json["nombre"] ?? "Sin nombre",
      fechaAplicacion: json["fechaAplicacion"] ?? "",
      descripcion: json["descripcion"] ?? "Sin descripción",
      historialMedicoId: json["historialMedicoId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id > 0 ? id : null,  // 🔥 No enviar `id` si es 0
      "nombre": nombre,
      "fechaAplicacion": fechaAplicacion,
      "descripcion": descripcion,
      "historialMedicoId": historialMedicoId,
    };
  }
}

class TratamientoPut {
  int id;
  String nombre;
  String fechaAplicacion;
  String descripcion;
  int historialMedicoId;

  TratamientoPut({
    required this.nombre,
    required this.fechaAplicacion,
    required this.descripcion,
    required this.historialMedicoId, required this.id,
  });

  factory TratamientoPut.fromJson(Map<String, dynamic> json) {
    return TratamientoPut(
      id: json["id"] ?? 0,
      nombre: json["nombre"] ?? "Sin nombre",
      fechaAplicacion: json["fechaAplicacion"] ?? "",
      descripcion: json["descripcion"] ?? "Sin descripción",
      historialMedicoId: json["historialMedicoId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id, // Agregar el ID aquí
      "nombre": nombre,
      "fechaAplicacion": fechaAplicacion,
      "descripcion": descripcion,
      "historialMedicoId": historialMedicoId,
    };
  }
}

