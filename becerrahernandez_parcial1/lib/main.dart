import 'package:flutter/material.dart';
import 'package:becerrahernandez_parcial1/pages/favorites.dart';
import 'package:becerrahernandez_parcial1/pages/home_page.dart';
import 'package:becerrahernandez_parcial1/pages/login_page.dart';
import 'package:becerrahernandez_parcial1/pages/register_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/register':(context) => const RegisterPage(),
        '/home':(context) => const HomePage(),
        '/login':(context) => const LoginPage(),
        '/favorites': (context) => const Favorites(),
      },
    );
  }
}

