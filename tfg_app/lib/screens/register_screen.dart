import 'package:tfg_app/pojos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:tfg_app/providers/providers.dart';
import 'package:tfg_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/ui/input_decorations.dart';
import 'package:tfg_app/widgets/widgets.dart';


class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              SizedBox(height: 10),
              Text('Regístrate', style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => RegisterFormProvider(), child: _RegisterForm())
            ],
          )),
          SizedBox(height: 50),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder())),
            child: Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

// ignore: must_be_immutable
class _RegisterForm extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_outlined),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Pepe',
                  labelText: 'Nombre',
                  prefixIcon: Icons.person_2_outlined),
              onChanged: (value) => registerForm.nombre = value,
              validator: (value) {
                return (value != null) ? null : 'Escribe tu nombre';
              },
            ),
            
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Fernandez Ruiz',
                  labelText: 'Apellidos',
                  prefixIcon: Icons.person_2_outlined),
              onChanged: (value) => registerForm.apellidos = value,
              validator: (value) {
                return (value != null)
                    ? null
                    : 'Rellena tus apellidos';
              },
            ),
            
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '+34666666666',
                  labelText: 'Teléfono',
                  prefixIcon: Icons.phone),
              onChanged: (value) => registerForm.tlf = value,
              validator: (value) {
                return (value != null &&
                        value.contains("+") &&
                        value.length == 12)
                    ? null
                    : 'Rellena bien tu telefono';
              },
            ),
             SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '00000000X',
                  labelText: 'DNI',
                  prefixIcon: Icons.perm_identity),
              onChanged: (value) => registerForm.dni = value,
              validator: (value) {
                return (value != null)
                    ? null
                    : 'Rellena tu DNI';
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
                      registerForm.isLoading ? 'Espere' : 'Registrarse',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: registerForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService = AuthService();

                        if (!registerForm.isValidForm()) return;

                        registerForm.isLoading = true;

                        // TODO: validar si el login es correcto
                        final String? errorMessage =
                            await authService.createUser(
                                registerForm.email,
                                registerForm.password,
                                Usuario(
                                    email: registerForm.email,
                                    dni: registerForm.dni,
                                    admin: false,
                                    nombre: registerForm.nombre,
                                    telefono: registerForm.tlf,
                                    verificado: true,
                                    apellidos: registerForm.apellidos,
                                    ));
                        authService
                            .loadUsuarios(registerForm.email)
                            .then((user) => {
                                  if (errorMessage == null)
                                    {
                                      Navigator.pushReplacementNamed(
                                          context, '/home',
                                          arguments: {"user": user,'inicio' : true})
                                    }
                                  else
                                    {
                                      // Mostrar error en la terminal
                                      print(errorMessage),
                                      registerForm.isLoading = false
                                    }
                                });
                      })
          ],
        ),
      ),
    );
  }

 
}
