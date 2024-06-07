import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/services/prod_services.dart';  // Asegúrate de importar correctamente

class ImagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: Consumer<ProdService>(
        builder: (context, prodService, child) {
          return FutureBuilder<List<dynamic>>(
            future: prodService.loadImagenes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                final imagenes = snapshot.data!;
                return ListView.builder(
                  itemCount: imagenes.length,
                  itemBuilder: (context, index) {
                    return Image.network(imagenes[index]);
                  },
                );
              } else {
                return Center(child: Text("No images found"));
              }
            },
          );
        },
      ),
    );
  }
}