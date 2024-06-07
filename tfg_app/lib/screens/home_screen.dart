import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';
import 'package:tfg_app/services/notificaciones_services.dart';
import 'package:tfg_app/services/prod_services.dart';
import 'package:tfg_app/services/search_services.dart';


import 'package:tfg_app/widgets/botom_nav_widget.dart';
import 'package:tfg_app/widgets/product_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Productos>? filteredProducts;
  Usuario? usuario;

  bool _notificationsOpen = false;

  void _showSearch() async {
    final prodService = Provider.of<ProdService>(context, listen: false);
    final allProducts = await prodService.loadProductos();
    final List<Productos>? results = await showSearch<List<Productos>?>(
      context: context,
      delegate: SearchServices(allProducts),
    );

    if (results != null) {
      setState(() {
        filteredProducts = results;
      });
    }
  }

  void _showNotifications() async {
    setState(() {
      _notificationsOpen = true;
    });

    final notificationService = NotificationService(); // Instancia del servicio de notificaciones
    final notificationsMap = await notificationService.getAllNotifications();

    _showNotificationsDialog(context, notificationsMap);
  }

  void _showNotificationsDialog(BuildContext context, Map<String, dynamic> notificationsMap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notificaciones'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildNotificationList(notificationsMap),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _notificationsOpen = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildNotificationList(Map<String, dynamic> notificationsMap) {
  List<Widget> notificationWidgets = [];
  int i = 1;
  notificationsMap.forEach((key, value) {
    if (key != "00") {
      if (notificationWidgets.isNotEmpty) {
        // Añadir un divisor entre notificaciones si no es la primera
        notificationWidgets.add(
          Divider(),
        );
      }
      notificationWidgets.add(
        ListTile(
          title: Text(i.toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildNotificationFields(value),
          ),
        ),
      );
      i++;
    }
  });

  return notificationWidgets;
}

  List<Widget> _buildNotificationFields(dynamic value) {
  List<Widget> notificationFields = [];

  if (value is Map<String, dynamic>) {
    value.forEach((key, value) {
   
        notificationFields.add(
        Text('$value'),
      );
      
      
    });
  } else if (value is String) {
    // Si el valor es una cadena, simplemente lo añadimos como un texto
    notificationFields.add(
      Text(value),
    );
  }

  return notificationFields;
}

  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context)!.settings.arguments as Map;
    int index = parametros['user'].admin ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: _showNotifications,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ProductContainers(
          filteredProducts: filteredProducts,
          parametros: parametros,
        ),
      ),
      bottomNavigationBar: bottomNav(
        context,
        parametros['user'],
        index,
        filteredProducts,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parametros = ModalRoute.of(context)!.settings.arguments as Map;
      if (parametros['inicio'] == true) {
        mostrarMensajeBienvenida(parametros['user']);
        parametros['inicio'] = false;
      }
    });
  }

  void mostrarMensajeBienvenida(Usuario usuario) {
    final snackBar = SnackBar(
      content: Text(
        '¡Bienvenido, ${usuario.nombre}!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}