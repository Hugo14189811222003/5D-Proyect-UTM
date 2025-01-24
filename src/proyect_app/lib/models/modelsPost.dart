
class UsuarioPost{
  final String name;
  final String userName;
  final String email;
  final String password;

  UsuarioPost({
    required this.name,
    required this.userName,
    required this.email,
    required this.password
  });

  // Constructor para crear un objeto desde un JSON
  factory UsuarioPost.fromJson(Map<String, dynamic> json){
    return UsuarioPost(
      name: json['name'],
      userName: json['userName'],
      email: json['email'],
      password: json['password']
    );
  }

  // Método para convertir el objeto en un JSON
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'username': userName,
      'email': email,
      'password': password
    };
  }
}