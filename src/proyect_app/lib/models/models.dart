class Usuario {
  final int id;
  final String name;
  final String userName;
  final String email;
  final String password;

  Usuario({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'] ?? 'Nombre no disponible',  
      userName: json['username'] ?? 'Usuario no disponible', 
      email: json['email'] ?? 'Correo no disponible', 
      password: json['password'] ?? 'Contraseña no disponible',
    );
  }
}
