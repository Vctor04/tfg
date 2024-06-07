import 'package:flutter/material.dart';
class ProdFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String? id;
  bool alquiler = false;
  String direccion = '';
  String ciudad = '';
  String provincia = '';
  int precio = 0;
  Map<String, dynamic> imagen = {};
  String? vendida;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$alquiler - $direccion - $ciudad - $provincia - $precio');

    return formKey.currentState?.validate() ?? false;
  }

}