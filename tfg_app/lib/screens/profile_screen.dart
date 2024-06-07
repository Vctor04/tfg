import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';
import 'package:tfg_app/screens/updateuser_form.dart';
import 'package:tfg_app/services/services.dart';

import 'package:tfg_app/widgets/botom_nav_widget.dart';



class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Usuario? usuario;
  List<Productos>? inmuebles;
  
  Future<List<Productos>> cargarInmuebles() async{
    final prodService = Provider.of<ProdService>(context, listen: false);
    final inmuebles = await prodService.loadProductos();
    return inmuebles;
  }
  @override
  Widget build(BuildContext context) { 
    final Map parametros = ModalRoute.of(context)!.settings.arguments as Map;
    
    usuario = parametros['user'] as Usuario;
    
    // Mostrar un indicador de carga mientras el usuario se inicializa
    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(
       
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    int index = usuario!.admin ? 2 : 1;
    String profileImageUrl = usuario!.profileImageUrl ?? 'https://cdn-icons-png.freepik.com/256/12808/12808894.png?semt=ais_hybrid';

    return Scaffold(
      appBar: AppBar(
      
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Usuario? updatedUser = await showDialog<Usuario>(
                context: context,
                builder: (context) {
                  return UpdateUserForm(
                    usuario: usuario!,
                    onUserUpdated: (updatedUser) {
                      Navigator.of(context).pop(updatedUser);
                    },
                  );
                },
              );

              if (updatedUser != null) {
                setState(() {
                  usuario = updatedUser;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                usuario!.nombre,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                usuario!.email,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                usuario!.telefono,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 60),
           if (usuario!.admin != true)
            FutureBuilder<List<Productos>>(
                future: cargarInmuebles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar los inmuebles');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No se encontraron inmuebles');
                  } else {
                    return ElevatedButton(
                      child: Text('Contactar'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/contact',
                          arguments: {'user': parametros['user'], 'inmuebles': snapshot.data},
                        );
                      },
                    );
                  }
                },
              ),
                const SizedBox(height: 40),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromARGB(255, 12, 12, 12),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                child: Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            
            // Añade más campos según lo que tenga tu clase Usuario
          ],
        ),
      ),
      bottomNavigationBar: bottomNav(context, usuario!, index),
    );
  }
}

