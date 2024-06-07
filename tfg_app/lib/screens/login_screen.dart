
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/widgets/widgets.dart';
import 'package:tfg_app/ui/input_decorations.dart';
import 'package:tfg_app/services/auth_services.dart';
import 'package:tfg_app/providers/login_form_provider.dart';



class LoginScreen extends StatelessWidget {
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
              Text('Login', style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _LoginForm())
            ],
          )),
          SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            child: Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
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
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
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
                      loginForm.isLoading ? 'Espere' : 'Iniciar sesión',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        final authService = AuthService();
                        final isLogged = await authService.login(
                            loginForm.email, loginForm.password);

                        loginForm.isLoading = false;
                        if (isLogged == null) {
                          authService
                              .loadUsuarios(loginForm.email)
                              .then((usuario) => {
                                loginForm.setUser(usuario),
                                print(loginForm.getUser()?.admin),
                                print(usuario),
                                    Navigator.pushReplacementNamed(
                                        context, '/home', arguments: {
                                          'user': usuario, 'inicio' : true
                                        })
                                  })
                                  .catchError((err) => {
                                    print(err)
                                  });
                        }
                      })
          ],
        ),
      ),
    );
  }
}


