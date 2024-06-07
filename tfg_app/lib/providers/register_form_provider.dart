import 'package:flutter/material.dart';
class RegisterFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email    = '';
  String password = '';
  String dni = '';
  bool admin = false;
  String tlf = '';
  bool verificado = false;
  String nombre = '';
  String apellidos = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$email - $password - $dni - $nombre - $admin - $tlf - $verificado - $apellidos');

    return formKey.currentState?.validate() ?? false;
  }

}