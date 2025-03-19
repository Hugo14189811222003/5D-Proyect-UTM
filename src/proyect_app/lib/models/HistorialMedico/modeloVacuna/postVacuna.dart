class Vacuna {
  int id;
  String nombre;
  String fechaAplicacion;
  String descripcion;
  int historialMedicoId;

  Vacuna({
    this.id = 0,  // 🔥 Se asigna 0 por defecto si no se proporciona un id
    required this.nombre,
    required this.fechaAplicacion,
    required this.descripcion,
    required this.historialMedicoId,
  });

  factory Vacuna.fromJson(Map<String, dynamic> json) {
    return Vacuna(
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



class VacunaPut {
  int id;
  String nombre;
  String fechaAplicacion;
  String descripcion;
  int historialMedicoId;

  VacunaPut({
    required this.nombre,
    required this.fechaAplicacion,
    required this.descripcion,
    required this.historialMedicoId, required this.id,
  });

  factory VacunaPut.fromJson(Map<String, dynamic> json) {
    return VacunaPut(
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

