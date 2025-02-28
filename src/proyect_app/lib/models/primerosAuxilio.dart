class PrimerosAuxilios {
  final int id;
  final String imagenUrl;
  final String titulo;
  final String categoria;
  final String resumen;
  final String contenido;

  PrimerosAuxilios({
    required this.id,
    required this.imagenUrl,
    required this.titulo,
    required this.categoria,
    required this.resumen,
    required this.contenido,
  });

  factory PrimerosAuxilios.fromJson(Map<String, dynamic> json) {
    return PrimerosAuxilios(
      id: json['id'],
      imagenUrl: json['imagenUrl'] ?? 'imagen no disponible',
      titulo: json['titulo'] ?? 'titulo no disponible',  
      categoria: json['categoria'] ?? 'categoria no disponible', 
      resumen: json['resumen'] ?? 'resumen no disponible',
      contenido: json['contenido'] ?? 'contenido no disponible',
    );
  }
}
