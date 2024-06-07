import 'package:flutter/material.dart';
import 'package:tfg_app/pojos/productos.dart';
import 'package:tfg_app/pojos/usuario.dart';

 BottomNavigationBar bottomNav(BuildContext context, Usuario parametros, int index, [List<Productos>? filteredProducts]) {

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i){
        index = i;
        if(parametros.admin == true){
          if(i == 0){
            Navigator.pushReplacementNamed(context, '/admin', arguments: {'user': parametros, 'filteredProducts': filteredProducts});
          }else if(i == 1){
            Navigator.pushReplacementNamed(context, '/home', arguments: {'user': parametros});
          }else if(i == 2){
            Navigator.pushReplacementNamed(context, '/profile', arguments: {'user': parametros});
          }
        }else{
          if(i == 0){
          
            Navigator.pushReplacementNamed(context, '/home', arguments: {'user': parametros});
          }else if(i == 1){
            Navigator.pushReplacementNamed(context, '/profile', arguments: {'user': parametros});
          }
        }
        
      
      },
      
      items: parametros.admin ?  itemsadmin() : items1(),
    );
  }

  items1 (){
    return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
  }

  itemsadmin(){
    return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        
      ];
  }