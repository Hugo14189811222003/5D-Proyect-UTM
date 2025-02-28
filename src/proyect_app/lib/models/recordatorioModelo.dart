class Recordatorio {
  String tipo;
  String nombre;
  String descripcion;
  String frecuencia;
  DateTime hora;
  int mascotaId;
  
  Recordatorio({
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.frecuencia,
    required this.hora,
    required this.mascotaId,
  });

  factory Recordatorio.fromJson(Map<String, dynamic> json) {
    return Recordatorio(
      tipo: json["tipo"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      frecuencia: json["frecuencia"],
      hora: DateTime.parse(json["hora"]),
      mascotaId: json["mascotaId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
        "tipo": tipo,
        "nombre": nombre,
        "descripcion": descripcion,
        "frecuencia": frecuencia,
        "hora": hora.toIso8601String().substring(11),  // Solo la hora
        "mascotaId": mascotaId,
    };
  }
}

class RecordatorioGet {
  int mascotaId;
  String tipo;
  String nombre;
  String descripcion;
  String frecuencia;
  DateTime? hora;

  RecordatorioGet({
    required this.mascotaId,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.frecuencia,
    this.hora,
  });

  factory RecordatorioGet.fromJson(Map<String, dynamic> json) {
    print("📥 JSON recibido: $json");
    // Revisamos si la hora está presente y es válida
    String? horaString = json["hora"];
    DateTime? hora;
    
    if (horaString != null) {
      try {
        // Usamos la fecha actual y combinamos con la hora proporcionada
        hora = DateTime.parse("${DateTime.now().toIso8601String().substring(0, 10)}T$horaString");
      } catch (e) {
        print("Error al parsear la hora: $e");
        hora = null;  // Si no se puede parsear, asignamos null
      }
    }

    return RecordatorioGet(
      mascotaId: json["mascotaId"],
      tipo: json["tipo"] ?? "",
      nombre: json["nombre"] ?? "",
      descripcion: json["descripcion"] ?? "",
      frecuencia: json["frecuencia"] ?? "",
      hora: hora,
    );
  }
}

class RecordatorioUpdate {
  int id;
  String tipo;
  String nombre;
  String descripcion;
  String frecuencia;
  DateTime hora;

  RecordatorioUpdate({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.frecuencia,
    required this.hora
  });

  factory RecordatorioUpdate.fromJson(Map<String, dynamic> json) {
    return RecordatorioUpdate(
      id: json["id"] ?? 0,
      tipo: json["tipo"] ?? "no hay tipo",
      nombre: json["nombre"] ?? "no hay nombre",
      descripcion: json["descripcion"] ?? "no hay descripcion",
      frecuencia: json["frecuencia"] ?? "no hay frecuencia",
      hora: DateTime.parse(json["hora"] ?? DateTime.now())
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tipo": tipo,
      "nombre": nombre,
      "descripción": descripcion,
      "frecuencia": frecuencia,
      "hora": hora.toIso8601String().substring(11)
    };
  }
}


