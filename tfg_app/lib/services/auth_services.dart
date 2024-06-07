import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDgEUTKjI3ZR6t5hIw2mQtM4Z5PhZ4LRWk';
   
  //Si devolmenos algo, es un error, si no, toco correcto
  Future<String?> createUser (String email, String password, Usuario usuario) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl,'/v1/accounts:signUp',{
      'key': _firebaseToken
    });   
    
    final resp = await http.post(url, body: json.encode(authData));
    
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if( decodedResp.containsKey('idToken') ) {
      //return decodedResp['idToken'];
      addUser(usuario);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }
  
  Future<void> addUser(Usuario usuario)async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';

      final url = Uri.https(_baseURL, 'usuarios.json');
      final resp = await http.post(url, body: usuario.toJson());
      if (resp.statusCode == 200) {
        print('Usuario insertado con éxito en la base de datos');
      } else {
        print('Error al insertar el Usuario en la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error');
      }

  }
Future<String?> addProd(Productos producto)async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';

      final url = Uri.https(_baseURL, 'inmuebles.json');
      final resp = await http.post(url, body: producto.toJson());
      if (resp.statusCode == 200) {
        print('Usuario insertado con éxito en la base de datos');
      } else {
        print('Error al insertar el Usuario en la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error');
      }
      return null;

  }
  Future<String?> updateUser(Usuario usuario) async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';
    final url = Uri.https(_baseURL, 'usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    if (resp.statusCode == 200) {
      print('Usuario actualizado con éxito en la base de datos');
    } else {
      print('Error al actualizar el usuario en la base de datos. Código de estado: ${resp.statusCode}');
      throw Exception('Error');
    }
    return null;
  }
  Future<String?> updateProd(Productos producto) async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';
    final url = Uri.https(_baseURL, 'inmuebles/${producto.id}.json');
    final resp = await http.put(url, body: producto.toJson());
    if (resp.statusCode == 200) {
      print('Producto actualizado con éxito en la base de datos');
    } else {
      print('Error al actualizar el producto en la base de datos. Código de estado: ${resp.statusCode}');
      throw Exception('Error');
    }
    return null;
  }
  Future<String?> login (String email, String password ) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl,'/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });   
    
    final resp = await http.post(url, body: json.encode(authData));
    
    final Map<String, dynamic> decodedResp = json.decode(resp.body);



    if( decodedResp.containsKey('idToken') ) {
      //return decodedResp['idToken'];
      
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<Usuario?> loadUsuarios(String email) async {
    final String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';
    final url = Uri.https(_baseURL, 'usuarios.json'); // URL de la base de datos
    final resp = await http.get(url); // Petición HTTP para obtener los datos
    Usuario? validUser = null;
    final Map<String, dynamic> usuariosMap = json.decode(resp.body); // Decodificar la respuesta JSON
    usuariosMap.forEach((key, value) {

       Usuario usuario = Usuario.fromMap(value); 
      usuario.id = key;
      if (usuario.email.compareTo(email) == 0){
         validUser = usuario;
         
      } // Crear un objeto Usuario a partir de los datos
       // Asignar el ID del usuario
      
    }
    
    );
   return validUser;

// Devolver la lista de usuarios cargada
  }

}