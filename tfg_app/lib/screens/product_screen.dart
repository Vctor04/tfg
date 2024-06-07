
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tfg_app/services/auth_services.dart';
import 'package:tfg_app/ui/input_decorations.dart';

import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/providers/prod_form_provider.dart';
import 'package:tfg_app/screens/updateprod_form.dart';




// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
   Productos? producto;
  final Map? parametros;

  ProductScreen({this.producto, this.parametros});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
int currentIndex = 0;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _handleProductUpdated(Productos updatedProduct) {
    setState(() {
      widget.producto = updatedProduct;
    });
  }
  void _changeImage(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }
   @override
  Widget build(BuildContext context) {
    List<dynamic> images = widget.producto?.imagen.values.toList() ?? [];
    final productForm = Provider.of<ProdFormProvider>(context);
    print (widget.producto?.vendida);
    print(widget.producto!.id);
    return Scaffold(
      key: _scaffoldKey,
     
      appBar: AppBar(
       
      ),
      body: Container(
        
        child: Column(
          children: [
            if (widget.producto?.vendida == null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Aquí implementamos la lógica para agrandar la imagen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Scaffold(
                           backgroundColor: const Color.fromARGB(255, 59, 57, 57),
                          appBar: AppBar(),
                          body: InteractiveViewer(
                            child: Center(child: Image.network(
                              images[currentIndex],
                              fit: BoxFit.contain,
                            ),) 
                          ),
                        ),
                      ));
                    },
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed:
                              images.isEmpty || currentIndex == 0
                                  ? null
                                  : () {
                                      _changeImage(currentIndex - 1);
                                    },
                        ),
                        Expanded(
                          child: Container(
                            height: 250,
                            child: images.isNotEmpty
                                ? Image.network(
                                    images[currentIndex],
                                    fit: BoxFit.cover,
                                  )
                                : Center(child: Text("No image available")),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: images.isEmpty ||
                                  currentIndex >= images.length - 1
                              ? null
                              : () {
                                  _changeImage(currentIndex + 1);
                                },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                Text(
                "${widget.producto?.provincia ?? 'Sin especificar'} ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                "${widget.producto?.ciudad ?? 'Sin especificar'} ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                "${widget.producto?.direccion ?? 'Sin direccion'}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                widget.producto!.alquiler
                  ? "${widget.producto?.precio ?? 'Sin precio'} €/mes"
                  : "${widget.producto?.precio ?? 'Sin precio'} €",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (widget.parametros?['user']?.admin != true)
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Si está interesado en este inmueble, por favor contacte al vendedor a través de la pestaña perfil del inicio.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              ], 
              
              ), 
                if (widget.producto?.vendida != null) 
                const Center(
                  child: Text(
                    'Vendido',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
            SizedBox(height: 20),
            if (widget.parametros?['user']?.admin == true)
              Column(
              children: [
                if(widget.producto!.vendida == null)
                ElevatedButton(
                child: Text('Vendido'),
                onPressed: _showDialog,
                ),
                SizedBox(width: 20),
                
                ElevatedButton(
                child: Text('Editar'),
                onPressed: () async {
                  setState(() {
                  productForm.isLoading = false;
                  });
                  showDialog(
                  context: context,
                  builder: (context) {
                    return UpdateProductForm(
                    producto: widget.producto,
                    onProductUpdated: _handleProductUpdated,
                    usuario: widget.parametros?['user'],
                    );
                  },
                  );
                  
                },
                ),
                
              ],
              ),
            ],
        ),
      ),
      
    );
    
  }
 

  void _showDialog() {
    final productForm = Provider.of<ProdFormProvider>(context, listen: false);
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Formulario'),
          content: TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
            hintText: '00000000X',
            labelText: 'DNI',
            prefixIcon: Icons.perm_identity,
            ),
            onChanged: (value) => productForm.vendida = value,
            validator: (value) {
            return (value != null && value.isNotEmpty)
            ? null
            : 'Rellena tu DNI';
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Enviar'),
              onPressed: ()async {
               FocusScope.of(context).unfocus();
               final authService = AuthService();
                      
               final String? errorMessage =
                            await authService.updateProd(
                              Productos(
                                id: widget.producto!.id,
                                direccion: widget.producto!.direccion,
                                ciudad: widget.producto!.ciudad,
                                provincia: widget.producto!.provincia,
                                precio: widget.producto!.precio,
                                alquiler: widget.producto!.alquiler,
                                imagen: widget.producto!.imagen,
                                vendida: productForm.vendida
                              ),
                            );
                if (errorMessage == null)
                    {
                      // Mostrar mensaje de éxito tipo notificación
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('El inmueble se actualizó correctamente.'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Esperar unos segundos antes de cerrar el formulario
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.of(context).pop(); // Cierra el diálogo
                            
                    }
                  else
                    {
                      // Mostrar error en la terminal
                      print(errorMessage);
                      productForm.isLoading = false;
                    }
              },
            ),
          ],
        );
      },
    );
  }
 
}
