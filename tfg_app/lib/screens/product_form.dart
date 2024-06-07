

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/productos.dart';

import 'package:tfg_app/providers/providers.dart';
import 'package:tfg_app/services/auth_services.dart';
import 'package:tfg_app/ui/input_decorations.dart';
import 'package:tfg_app/widgets/botom_nav_widget.dart';

// ignore: must_be_immutable
class ProductForm extends StatefulWidget {

ProductForm({Key? key}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}
class _ProductFormState extends State<ProductForm> {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProdFormProvider>(context);

    Map parametros = ModalRoute.of(context)!.settings.arguments as Map;
  const int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de ${parametros['user'].nombre}'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
      child: Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'C/Calle, 123, 1ºA',
                  labelText: 'Dirección',
                  prefixIcon: Icons.edit_location),
              onChanged: (value) => productForm.direccion = value,
              validator: (value) {
                return (value != null)
                    ? null
                    : 'Debes rellenar este campo';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Armilla',
                  labelText: 'Ciudad',
                  prefixIcon: Icons.edit_location),
              onChanged: (value) => productForm.ciudad = value,
              validator: (value) {
                return (value != null)
                    ? null
                    : 'Debes rellenar este campo';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Granada',
                  labelText: 'Provincia',
                  prefixIcon: Icons.edit_location),
              onChanged: (value) => productForm.provincia = value,
              validator: (value) {
                return (value != null) ? null : 'La provincia está vacia';
              },
            ),
            
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '€',
                  labelText: 'Precio',
                  prefixIcon: Icons.euro),
              onChanged: (value) => productForm.precio = int.parse(value),
              validator: (value) {
                return (value != null)
                    ? null
                    : 'Rellena el precio';
              },
            ),
            
            SizedBox(height: 30),
            SwitchListTile(
              title: Text('Alquilar'),
              value: productForm.alquiler,
              onChanged: (value) {
                // Actualiza el estado del alquiler solo si el usuario lo cambia
                
                setState(() {if (value != productForm.alquiler) {
                  productForm.alquiler = value;
                }
                productForm.alquiler = value;});
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'https://imagen1.jpg,https://imagen2.jpg',
                labelText: 'Imagenes',
                prefixIcon: Icons.picture_in_picture,
              ),
              onChanged: (value) {
                // Dividir las URLs separadas por comas y eliminar espacios en blanco
                List<String> urls = value.split(',').map((url) => url.trim()).toList();
                
                // Crear un mapa de imágenes con claves únicas
                Map<String, String> imageMap = {};
                for (int i = 0; i < urls.length; i++) {
                  imageMap['img${i + 1}'] = urls[i];
                }
                
                // Guardar el mapa de imágenes en el formulario
                productForm.imagen = imageMap;
              },
              validator: (value) {
                return (value != null && value.isNotEmpty) ? null : 'La imagen está vacía';
              },
            ),
             SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromARGB(255, 12, 12, 12),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                    child: Text(
                      productForm.isLoading ? 'Espere' : 'Guardar Cambios',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: productForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService = AuthService();
                      
                        if (!productForm.isValidForm()) return;

                        productForm.isLoading = true;

                        // TODO: validar si el login es correcto
                        final String? errorMessage =
                            await authService.addProd(
                              Productos(
                                direccion: productForm.direccion,
                                ciudad: productForm.ciudad,
                                provincia: productForm.provincia,
                                precio: productForm.precio,
                                alquiler: productForm.alquiler,
                                imagen: productForm.imagen,
                                vendida: null,
                              ),
                            );
                        /*authService
                            .loadUsuarios(productForm.email)
                            .then((user) => {*/
                                  if (errorMessage == null)
                                    {
                                      Navigator.pushReplacementNamed(
                                          context, '/home', arguments: {'user' : parametros['user']}); 
                                    }
                                  else
                                    {
                                      // Mostrar error en la terminal
                                      print(errorMessage);
                                      productForm.isLoading = false;
                                    }
                               /* });*/
                      })
          ],
        ),
      ),
      ),
    )
    ),
      bottomNavigationBar: bottomNav(context, parametros['user'], index, parametros['filteredProducts']),
    );
  }
  
  
  }
