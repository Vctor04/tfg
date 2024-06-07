import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tfg_app/pojos/productos.dart';

class ProdService extends ChangeNotifier {

  Future<List<String>> loadImagenes() async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';
    final url = Uri.https(_baseURL, 'inmuebles.json');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      if (data is Map<String, dynamic>) {
        List<String> imagenes = [];
        data.forEach((key, value) {
          print("estamos por aqui");
          // Asegúrate de que 'imagenes' en el JSON es un objeto de tipo clave-valor
          
            // Recorre las claves del objeto 'imagenes' y agrega los valores a la lista
            value['imagen'].forEach((key, value) {
              imagenes.add(value.toString());
              print("Esto es lo que hay en imagenes: " + value.toString());
            });
        
        });
        return imagenes;
      } else {
        throw Exception('Data format is not as expected');
      }
    } else {
      throw Exception('Failed to load images: ${resp.statusCode}');
    }
  }
  Future<List<Productos>> loadProductos() async {
  final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';
  final url = Uri.https(_baseURL, 'inmuebles.json');
  final resp = await http.get(url);

  if (resp.statusCode == 200) {
    final data = json.decode(resp.body);
    if (data is Map<String, dynamic>) {
      List<Productos> productos = [];
      data.forEach((key, value) {
        
        productos.add(Productos(
          id: key,
          alquiler: value['alquiler'],
          precio: value['precio'],
          provincia: value['provincia'],
          ciudad: value['ciudad'],
          direccion: value['direccion'],
          imagen : value['imagen'],
          vendida: value['vendida'], 
        ));
      });
      return productos;
    } else {
      throw Exception('Data format is not as expected');
    }
  } else {
    throw Exception('Failed to load products: ${resp.statusCode}');
  }
}
}