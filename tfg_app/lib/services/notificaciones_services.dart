import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _baseURL = 'tfg-app-01-default-rtdb.europe-west1.firebasedatabase.app';

  Future<void> addOrUpdateNotification(String? messageId, Map<String?, dynamic> notificationData) async {
    try {
      final url = Uri.https(_baseURL, 'notificaciones.json');
      final resp = await http.get(url);
      
      if (resp.statusCode == 200) {
        final Map<String, dynamic> existingData = json.decode(resp.body);

        if (existingData.containsKey(messageId)) {
          // Si la notificación ya existe, actualiza los datos existentes
          await updateNotification(messageId, notificationData);
        } else {
          // Si la notificación no existe, crea una nueva notificación
          await addNotification(messageId, notificationData);
        }
      } else {
        print('Error al consultar las notificaciones en la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error al consultar las notificaciones');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error en el servicio de notificaciones');
    }
  }

  Future<void> addNotification(String? messageId, Map<String?, dynamic> notificationData) async {
    try {
      final url = Uri.https(_baseURL, 'notificaciones.json');
      final resp = await http.patch(url, body: json.encode({ messageId: notificationData }));
      if (resp.statusCode == 200) {
        print('Notificación agregada con éxito a la base de datos');
      } else {
        print('Error al agregar la notificación a la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error al agregar la notificación');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error en el servicio de notificaciones');
    }
  }

  Future<void> updateNotification(String? messageId, Map<String?, dynamic> notificationData) async {
    try {
      final url = Uri.https(_baseURL, 'notificaciones/$messageId.json');
      final resp = await http.patch(url, body: json.encode(notificationData));
      if (resp.statusCode == 200) {
        print('Notificación actualizada con éxito en la base de datos');
      } else {
        print('Error al actualizar la notificación en la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error al actualizar la notificación');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error en el servicio de notificaciones');
    }
  }

  Future<void> deleteNotification(String? messageId) async {
  try {
    final url = Uri.https(_baseURL, 'notificaciones/$messageId.json');
    final resp = await http.get(url);
    
    if (resp.statusCode == 200) {
      // La notificación existe, así que se puede eliminar
      final deleteResp = await http.delete(url);
      
      if (deleteResp.statusCode == 200) {
        print('Notificación eliminada con éxito de la base de datos');
      } else {
        print('Error al eliminar la notificación de la base de datos. Código de estado: ${deleteResp.statusCode}');
        throw Exception('Error al eliminar la notificación');
      }
    } else if (resp.statusCode == 404) {
      // La notificación no existe, no se puede eliminar
      print('La notificación con ID $messageId no existe en la base de datos. No se puede eliminar.');
    } else {
      print('Error al verificar la existencia de la notificación en la base de datos. Código de estado: ${resp.statusCode}');
      throw Exception('Error al verificar la existencia de la notificación');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error en el servicio de notificaciones');
  }
}
   Future<Map<String, dynamic>> getAllNotifications() async {
    try {
      final url = Uri.https(_baseURL, 'notificaciones.json');
      final resp = await http.get(url);
      
      if (resp.statusCode == 200) {
        final Map<String, dynamic> notificationsData = json.decode(resp.body);
        return notificationsData;
      } else {
        print('Error al obtener las notificaciones de la base de datos. Código de estado: ${resp.statusCode}');
        throw Exception('Error al obtener las notificaciones');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error en el servicio de notificaciones');
    }
  }
}