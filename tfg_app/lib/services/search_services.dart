import 'package:flutter/material.dart';
import 'package:tfg_app/pojos/productos.dart';

class SearchServices extends SearchDelegate<List<Productos>?> {
  final List<Productos> products;

  
  SearchServices(this.products);

  // Implementación de buildActions, buildLeading igual que antes

@override
Widget buildResults(BuildContext context) {
  // Filtra los productos para obtener solo aquellos que están en la ciudad seleccionada.
  final results = products.where((producto) =>
    producto.ciudad.toLowerCase() == query.toLowerCase()).toList();

  // Puedes devolver directamente una lista de productos aquí o,
  // si necesitas regresar a la pantalla anterior con estos resultados:
  WidgetsBinding.instance.addPostFrameCallback((_) {
    close(context, results);
  });
  return Center(child: CircularProgressIndicator());  // Este contenedor estará vacío porque hemos cerrado la búsqueda con los resultados.
}
@override
Widget buildSuggestions(BuildContext context) {
  // Obtén una lista de ciudades únicas.
  final allCities = products.map((p) => p.ciudad).toSet();
  // Filtra las ciudades basado en la consulta actual.
  final suggestions = allCities.where((ciudad) =>
    ciudad.toLowerCase().contains(query.toLowerCase())).toList();

  return ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context); // Llama a showResults para mostrar los productos
        },
      );
    },
  );
}
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
}