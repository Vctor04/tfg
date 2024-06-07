
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';

import 'package:tfg_app/providers/providers.dart';
import 'package:tfg_app/services/auth_services.dart';
import 'package:tfg_app/ui/input_decorations.dart';
import 'package:tfg_app/services/notificaciones_services.dart';


// ignore: must_be_immutable
class UpdateProductForm extends StatefulWidget {
Productos? producto;
Usuario? usuario;
final Function(Productos)? onProductUpdated;
UpdateProductForm({Key? key, this.producto, this.onProductUpdated, this.usuario}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<UpdateProductForm> {
  late TextEditingController direccionController;
  late TextEditingController ciudadController;
  late TextEditingController provinciaController;
  late TextEditingController precioController;
  late TextEditingController imagenController;

  @override
  void initState() {
    super.initState();

    direccionController = TextEditingController(text: widget.producto?.direccion ?? '');
    ciudadController = TextEditingController(text: widget.producto?.ciudad ?? '');
    provinciaController = TextEditingController(text: widget.producto?.provincia ?? '');
    precioController = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    imagenController = TextEditingController(text: widget.producto?.imagen.values.join(',') ?? '');
  }

  @override
  void dispose() {
    direccionController.dispose();
    ciudadController.dispose();
    provinciaController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProdFormProvider>(context);
    final int previousPrice = widget.producto?.precio ?? 0; // Guardar el precio anterior

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario para Editar'),
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
                    controller: direccionController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'C/Calle, 123, 1ºA',
                      labelText: 'Dirección',
                      prefixIcon: Icons.edit_location,
                    ),
                    onChanged: (value) => productForm.direccion = value,
                    validator: (value) {
                      return (value != null) ? null : 'Debes rellenar este campo';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: ciudadController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Armilla',
                      labelText: 'Ciudad',
                      prefixIcon: Icons.edit_location,
                    ),
                    onChanged: (value) => productForm.ciudad = value,
                    validator: (value) {
                      return (value != null) ? null : 'Debes rellenar este campo';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: provinciaController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Granada',
                      labelText: 'Provincia',
                      prefixIcon: Icons.edit_location,
                    ),
                    onChanged: (value) => productForm.provincia = value,
                    validator: (value) {
                      return (value != null) ? null : 'La provincia está vacía';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: precioController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '€',
                      labelText: 'Precio',
                      prefixIcon: Icons.euro,
                    ),
                    onChanged: (value) => productForm.precio = int.parse(value),
                    validator: (value) {
                      return (value != null) ? null : 'Rellena el precio';
                    },
                  ),
                  SizedBox(height: 30),
                  SwitchListTile(
                    title: Text('Alquilar'),
                    value: widget.producto!.alquiler,
                    onChanged: (value) {
                      setState(() {
                        widget.producto!.alquiler = value;
                        productForm.alquiler = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: imagenController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'https://imagen1.jpg,https://imagen2.jpg',
                      labelText: 'Imágenes',
                      prefixIcon: Icons.picture_in_picture,
                    ),
                    onChanged: (value) {
                      // Dividir las URLs separadas por comas y eliminar espacios en blanco
                      List<String> urls = value.split(',').map((url) => url.trim()).toList();

                      // Crear un mapa de imágenes con claves únicas
                      Map<String, dynamic> imageMap = {};
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: const Color.fromARGB(255, 12, 12, 12),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      child: Text(
                        productForm.isLoading ? 'Espere' : 'Guardar Cambios',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: productForm.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            final authService = AuthService();

                            // Asignar valores de los controladores al productForm si no se han editado
                            productForm.direccion = direccionController.text;
                            productForm.ciudad = ciudadController.text;
                            productForm.provincia = provinciaController.text;
                            productForm.precio = int.tryParse(precioController.text) ?? 0;

                            List<String> urls = imagenController.text.split(',').map((url) => url.trim()).toList();
                            Map<String, dynamic> imageMap = {};
                            for (int i = 0; i < urls.length; i++) {
                              imageMap['img${i + 1}'] = urls[i];
                            }
                            productForm.imagen = imageMap;
                            String direccion = productForm.direccion;
                            String? id = widget.producto?.id;
                            final newPrecio = int.tryParse(precioController.text) ?? 0;
                            print('Precio anterior: $previousPrice, Precio nuevo: $newPrecio, direccion: ${productForm.direccion}');
                            
                            if (previousPrice > newPrecio) {
                              // Enviar email diciendo que ha bajado el precio
                              final notificationService = NotificationService();
                              await notificationService.addOrUpdateNotification(id, {id: '¡El inmueble de ${productForm.ciudad}, ubicado en $direccion, ha bajado de precio a $newPrecio€!'}
  );
                          
                              print('Se ha guardado el mensaje');
                              //
                            }
                            if (previousPrice < newPrecio){
                              final notificationService = NotificationService();
                              await notificationService.deleteNotification(id);
                            }
                            

                            productForm.isLoading = true;

                            if (!productForm.isValidForm()) return;

                            final String? errorMessage = await authService.updateProd(
                              Productos(
                                id: widget.producto!.id,
                                direccion: productForm.direccion,
                                ciudad: productForm.ciudad,
                                provincia: productForm.provincia,
                                precio: productForm.precio,
                                alquiler: productForm.alquiler,
                                imagen: productForm.imagen,
                              ),
                            );

                            if (errorMessage == null) {
                              // Mostrar mensaje de éxito tipo notificación
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El inmueble se actualizó correctamente.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );

                              // Esperar unos segundos antes de cerrar el formulario
                              await Future.delayed(Duration(seconds: 2));

                              // Cerrar el formulario emergente
                              Navigator.pop(context);

                              // Llamar a la función de actualización en ProductScreen
                              widget.onProductUpdated?.call(
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
                            } else {
                              // Mostrar error en la terminal
                              print(errorMessage);
                              productForm.isLoading = false;
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  

}