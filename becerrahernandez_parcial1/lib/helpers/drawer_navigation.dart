import 'package:flutter/material.dart';
import 'package:becerrahernandez_parcial1/pages/favorites.dart';
import 'package:becerrahernandez_parcial1/pages/home_page.dart';
import 'package:becerrahernandez_parcial1/pages/login_page.dart';
import 'package:becerrahernandez_parcial1/pages/register_page.dart';
import 'package:becerrahernandez_parcial1/repositories/database_connection.dart';
import 'package:becerrahernandez_parcial1/repositories/repository.dart';
import 'package:becerrahernandez_parcial1/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/favorites': (context) => const Favorites(),
      },
    );
  }
}

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            accountEmail: Text('Juan.Gomez@gmail.com'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('Favoritos'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/favorites',
                (route) => false,
              );
            },
          ),
          Divider(), 
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                APIService.sendFavoritesToServer().then((_) {
                  DatabaseConnection().deleteAllFavorites().then((_) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }).catchError((error) {
                    print('Error al cerrar sesión: $error');
                  });
                }).catchError((error) {
                  print('Error al enviar los favoritos al servidor: $error');
                  DatabaseConnection().deleteAllFavorites().then((_) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }).catchError((error) {
                    print('Error al cerrar sesión: $error');
                  });
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
