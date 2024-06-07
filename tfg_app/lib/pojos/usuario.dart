import 'dart:convert';

class Usuario {
  String? id;
  String dni;
  String email;
  String nombre;
  bool admin;
  String telefono;
  bool verificado;
  String? apellidos;
  String? profileImageUrl;

  Usuario({
    this.id,
    required this.dni,
    required this.email,
    required this.nombre,
    required this.admin,
    required this.telefono,
    required this.verificado,
     this.apellidos,
    this.profileImageUrl,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        dni: json["dni"],
        nombre: json["nombre"],
        admin: json["admin"],
        telefono: json["telefono"],
        verificado: json["verificado"],
        apellidos: json["apellidos"],
        profileImageUrl: json["profileImageUrl"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "dni": dni,
        "nombre": nombre,
        "admin": admin,
        "telefono": telefono,
        "verificado": verificado,
        "apellidos": apellidos,
        "profileImageUrl": profileImageUrl,
      };

  Usuario copy() => Usuario(
        email: email,
        dni: dni,
        nombre: nombre,
        admin: admin,
        telefono: telefono,
        verificado: verificado,
        apellidos: apellidos,
        id: id,
        profileImageUrl: profileImageUrl,
      );
}
 