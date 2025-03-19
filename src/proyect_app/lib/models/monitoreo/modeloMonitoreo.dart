class Monitoreo {
  int pulso;
  int temperatura;
  int respiracion;
  int vfc;
  double latitud;
  double longitud;
  int mascotaId;
  String fechaRegistro; // Nueva propiedad

  Monitoreo({
    required this.pulso,
    required this.temperatura,
    required this.respiracion,
    required this.vfc,
    required this.latitud,
    required this.longitud,
    required this.mascotaId,
    required this.fechaRegistro, // Nueva propiedad en el constructor
  });

  factory Monitoreo.fromJson(Map<String, dynamic> json) {
    return Monitoreo(
      pulso: (json["pulso"] as num?)?.toInt() ?? 0,
      temperatura: (json["temperatura"] as num?)?.toInt() ?? 0,
      respiracion: (json["respiracion"] as num?)?.toInt() ?? 0,
      vfc: (json["vfc"] as num?)?.toInt() ?? 0,
      latitud: (json["latitud"] as num?)?.toDouble() ?? 0.0,
      longitud: (json["longitud"] as num?)?.toDouble() ?? 0.0,
      mascotaId: (json["mascotaId"] as num?)?.toInt() ?? 0,
      fechaRegistro: json["fechaRegistro"] ?? "", // Asignar la fecha de registro
    );
  }

  Map<String, dynamic> jsonData() {
    return {
      "pulso": pulso,
      "temperatura": temperatura,
      "respiracion": respiracion,
      "vfc": vfc,
      "latitud": latitud,
      "longitud": longitud,
      "mascotaId": mascotaId,
      "fechaRegistro": fechaRegistro, // Incluir el campo fechaRegistro
    };
  }
}
