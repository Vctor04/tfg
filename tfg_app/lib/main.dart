import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_app/providers/login_form_provider.dart';
import 'package:tfg_app/providers/prod_form_provider.dart';
import 'package:tfg_app/providers/providers.dart';
import 'package:tfg_app/screens/product_form.dart';
import 'package:tfg_app/screens/product_screen.dart';
import 'package:tfg_app/screens/updateprod_form.dart';
import 'package:tfg_app/screens/updateuser_form.dart';
import 'package:tfg_app/services/prod_services.dart';
import 'package:tfg_app/screens/screens.dart';
import 'package:tfg_app/widgets/product_container.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Envolver MaterialApp con ChangeNotifierProvider
    
      return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>LoginFormProvider(),
        child: ProfileScreen(),),
        ChangeNotifierProvider(create: (_) => LoginFormProvider(),
        child: HomeScreen(),),
        ChangeNotifierProvider(create: (_) => LoginFormProvider(),
        child: LoginScreen(),),
        ChangeNotifierProvider(create: (_) => ProdService(),
        child: ProductContainers(),),
        ChangeNotifierProvider(create: (_) => LoginFormProvider(),
        child: RegisterScreen(),), 
        ChangeNotifierProvider(create: (_) =>LoginFormProvider(),
        child: ProductScreen(),),
        ChangeNotifierProvider(create: (_) =>LoginFormProvider(),
        child: ProductForm(),),
        ChangeNotifierProvider(create: (_) =>ProdFormProvider(),
        child: ProductForm(),),
        ChangeNotifierProvider(create: (_) =>ProdFormProvider(),
        child: UpdateProductForm(),),
        ChangeNotifierProvider(create: (_) =>ProdFormProvider(),
        child: ProductScreen(),),
        ChangeNotifierProvider(create: (_) =>RegisterFormProvider(),
        child: UpdateUserForm(),),
        ChangeNotifierProvider(create: (_) =>LoginFormProvider(),
        child: ContactScreen(),),
        ChangeNotifierProvider(create: (_) =>ProdFormProvider(),
        child: ProfileScreen(),),
        ChangeNotifierProvider(create: (_) =>ProdFormProvider(),
        child: ContactScreen(),),
      ],
      child: MaterialApp(
        title: 'App Grupo Gespromat',
        initialRoute: '/login',
        debugShowCheckedModeBanner: false,
        routes: {

          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/profile': (context) => ProfileScreen(),
          '/admin': (context) => ProductForm(),
          '/contact': (context) => ContactScreen(), 

      },
    ),
    );
  }
}