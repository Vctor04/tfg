import 'package:flutter/material.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ContactScreen extends StatefulWidget {


  ContactScreen({super.key});
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool checkbox1Value = false;
  bool checkbox2Value = false;
  TextEditingController textFieldController = TextEditingController();
  Usuario? usuario;
  int? selectedOption;
  List<Productos>? inmuebles;
  Productos? selectedInmueble;

  @override
  Widget build(BuildContext context) {
    final Map parametros = ModalRoute.of(context)!.settings.arguments as Map;
    usuario = parametros['user'] as Usuario;
    inmuebles = parametros['inmuebles'] as List<Productos>;
    return Scaffold(
      appBar: AppBar(
    
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            DropdownButton<Productos>(
              hint: Text('Seleccione un inmueble'),
              value: selectedInmueble,
              onChanged: (Productos? newValue) {
                setState(() {
                  selectedInmueble = newValue;
                });
              },
              items: inmuebles!.map<DropdownMenuItem<Productos>>((Productos inmueble) {
                return DropdownMenuItem<Productos>(
                  value: inmueble,
                  child: Text('${inmueble.ciudad}, ${inmueble.direccion}'),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            
            RadioListTile<int>(
              title: Text('Gestión Simple'),
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),Text('La gestión simple ofrece apoyo en la compra unicamente.', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),),
            SizedBox(height: 16.0),
            RadioListTile<int>(
              title: Text('Gestión Completa'),
              value: 2,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),Text('La gestión completa ofrece también ayuda en la documentación, pago de tasas e inscripción en el regristro.',
            style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),),
            SizedBox(height: 30.0),
            Row(
              children: [
                
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile', arguments: {'user': usuario});
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, // Texto blanco
                  ),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 40.0),
                ElevatedButton(
                  onPressed: () {
                     _launchWhatsApp2('+34609404095', usuario!.nombre, usuario!.apellidos, selectedInmueble, selectedOption);
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

void _launchWhatsApp2(String phoneNumber, String nombre, String? apellidos, Productos? selectedInmueble, int? selectedOption) async {
    if (selectedInmueble != null && selectedOption != null) {
    String gestion = selectedOption == 1 ? 'Simple' : 'Completa';
    final whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=Hola, soy $nombre $apellidos, me interesa el inmueble en ${selectedInmueble.ciudad}, ${selectedInmueble.direccion}. Tipo de gestión: $gestion');
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    // Manejo de error si no se ha seleccionado un inmueble o una opción de gestión
    print('Error: Debes seleccionar un inmueble y una opción de gestión');
  }
    
}