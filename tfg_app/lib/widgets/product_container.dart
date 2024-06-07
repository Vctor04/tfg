import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/screens/product_screen.dart';
import 'package:tfg_app/services/prod_services.dart';
//Punto
class ProductContainers extends StatelessWidget {
  final List<Productos>? filteredProducts;
  final Map? parametros;

  const ProductContainers({Key? key, this.filteredProducts, this.parametros}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    final prodService = Provider.of<ProdService>(context);
    Future<List<Productos>> productsFuture = filteredProducts == null ? prodService.loadProductos() : Future.value(filteredProducts);

    return FutureBuilder<List<Productos>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data!.map((producto) => _productContainer(context, producto, parametros)).toList(),
          );
        } else {
          return Text("No products found");
        }
      },
    );
  }
Widget _productContainer(BuildContext context, Productos producto, Map? parametros) {
  String firstKey = producto.imagen.keys.first;
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Espacio entre los productos
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen(producto: producto, parametros: parametros)),
          );
          print('Producto pulsado: ${producto.direccion}');
        },
        child: Container(
          height: 250, // Ajusta esto a la altura que desees
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white, // Color de fondo
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
            boxShadow: [ // Sombra
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: _container(producto.imagen[firstKey]),
              ),
              if (producto.vendida != null)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red, // Color de fondo de la banda roja
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Vendido', // Texto de la banda roja
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black, // Color de fondo del texto
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    producto.alquiler ? 'Alquiler' : '${producto.precio}€', // El precio del producto
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
  Widget _container(dynamic imageUrl) {
  if (imageUrl is String) {
    return Padding(
      
      padding: const EdgeInsets.all(8.0),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  } else {
    return Center(child: Text('Invalid image URL'));
  }
}

}