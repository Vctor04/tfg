import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/pojos/usuario.dart';
import 'package:tfg_app/providers/providers.dart';
import 'package:tfg_app/services/auth_services.dart';
import 'package:tfg_app/ui/input_decorations.dart';

// ignore: must_be_immutable
class UpdateUserForm extends StatefulWidget {
  final Function(Usuario)? onUserUpdated;
  Usuario? usuario;

  UpdateUserForm({Key? key,  this.usuario,  this.onUserUpdated})
      : super(key: key);

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  late TextEditingController nameController;
  late TextEditingController apellidosController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController dniController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.usuario!.nombre);
    apellidosController = TextEditingController(text: widget.usuario!.apellidos);
    emailController = TextEditingController(text: widget.usuario!.email);
    telefonoController = TextEditingController(text: widget.usuario!.telefono);
    dniController = TextEditingController(text: widget.usuario!.dni);
  }

  @override
  void dispose() {
    nameController.dispose();
    apellidosController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    dniController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<RegisterFormProvider>(context);

   
    userForm.nombre = widget.usuario!.nombre;
    userForm.apellidos = widget.usuario!.apellidos!;
    userForm.email = widget.usuario!.email;
    userForm.tlf = widget.usuario!.telefono;
    userForm.dni = widget.usuario!.dni;
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: userForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'john.doe@gmail.com',
                      labelText: 'Correo electrónico',
                      prefixIcon: Icons.alternate_email_outlined,
                    ),
                    onChanged: (value) => userForm.email = value,
                    validator: (value) {
                      String pattern = r'^[^@]+@[^@]+\.[^@]+$';
                      RegExp regExp = new RegExp(pattern);

                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El valor ingresado no luce como un correo';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: nameController,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Pepe',
                      labelText: 'Nombre',
                      prefixIcon: Icons.person_2_outlined,
                    ),
                    onChanged: (value) => userForm.nombre = value,
                    validator: (value) {
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Escribe tu nombre';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: apellidosController,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fernandez Ruiz',
                      labelText: 'Apellidos',
                      prefixIcon: Icons.person_2_outlined,
                    ),
                    onChanged: (value) => userForm.apellidos = value,
                    validator: (value) {
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Rellena tus apellidos';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: telefonoController,
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '+34666666666',
                      labelText: 'Teléfono',
                      prefixIcon: Icons.phone,
                    ),
                    onChanged: (value) => userForm.tlf = value,
                    validator: (value) {
                      return (value != null &&
                              value.startsWith('+') &&
                              value.length == 12)
                          ? null
                          : 'Rellena bien tu telefono';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: dniController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '00000000X',
                      labelText: 'DNI',
                      prefixIcon: Icons.perm_identity,
                    ),
                    onChanged: (value) => userForm.dni = value,
                    validator: (value) {
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Rellena tu DNI';
                    },
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.black,
                    onPressed: () async {
                      final userForm =
                          Provider.of<RegisterFormProvider>(context,
                              listen: false);
                      //Navigator.pushReplacementNamed(context, '/login');
                    final authService = AuthService();
                      //Validacion de todos los campos
                      if (!userForm.isValidForm()) return;

                      try {
                        final response = await authService.updateUser(Usuario(
                          id: widget.usuario!.id,
                          dni: userForm.dni, 
                          email: userForm.email, 
                          nombre: userForm.nombre,
                          apellidos: userForm.apellidos, 
                          admin: widget.usuario!.admin, 
                          telefono: userForm.tlf, 
                          verificado: widget.usuario!.verificado)
                         
                          
                        );
                        print(response);

                        widget.onUserUpdated!(
                          Usuario(
                            id: widget.usuario!.id,
                            nombre: nameController.text,
                            apellidos: apellidosController.text,
                            email: emailController.text,
                            telefono: telefonoController.text,
                            dni: dniController.text,
                            admin: widget.usuario!.admin,
                            verificado: widget.usuario!.verificado,
                            // Asegúrate de pasar otros campos necesarios
                          ),
                        );
                      } catch (e) {
                        print('Error updating user: $e');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                      child: Text(
                        'Actualizar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}