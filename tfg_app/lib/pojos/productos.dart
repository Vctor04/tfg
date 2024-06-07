import 'dart:convert';

class Productos {
  String? id;
  bool alquiler;
  String direccion;
  String ciudad;
  String provincia;
  int precio;
  Map<String, dynamic> imagen;
  String? vendida;

  Productos({
    this.id,
    required this.provincia,
    required this.alquiler,
    required this.ciudad,
    required this.direccion,
    required this.precio,
    required this.imagen,
    this.vendida,
  });

  factory Productos.fromJson(String str) => Productos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Productos.fromMap(Map<String, dynamic> json) => Productos(
        alquiler: json["alquiler"],
        direccion: json["direccion"],
        precio: json["precio"],
        imagen: json["imagen"],
        provincia: json["provincia"],
        ciudad: json["ciudad"], 
        vendida: json["vendida"],
      );

  Map<String, dynamic> toMap() => {
        "alquiler": alquiler,
        "direccion": direccion,
        "precio": precio,
        "imagen": imagen,
        "provincia": provincia,
        "ciudad": ciudad,
        "vendida": vendida,
      };

  Productos copy() => Productos(
        alquiler: alquiler,
        provincia: provincia,
        ciudad: ciudad,
        direccion: direccion,
        precio: precio,
        imagen: imagen,
        vendida: vendida,
      );
}