class Categoria {
  final String titulo;
  final String extracto;
  final String url;

  Categoria({
    required this.titulo,
    required this.extracto,
    required this.url,
  });

  // Este factory constructor convierte el JSON de la respuesta de la API en una instancia de Categoria
  factory Categoria.fromJson(Map<String, dynamic> json) {
    final page = json['query']['pages'].values.first;

    return Categoria(
      titulo: page['title'] ?? 'Título no disponible',
      extracto: page['extract'] ?? 'Extracto no disponible',
      url: 'https://es.wikipedia.org/wiki/${Uri.encodeComponent(page['title'] ?? '')}',
    );
  }
}
