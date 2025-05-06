import 'package:flutter/material.dart';
import 'package:becerrahernandezquiz3/pages/articulos.dart';
import 'package:becerrahernandezquiz3/pages/options.dart';
import 'package:becerrahernandezquiz3/pages/settings.dart';
import 'package:becerrahernandezquiz3/pages/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => const LoginPage(),
        '/options': (context) => const OptionsPage(),
        '/home': (context) => const ArticulosPage(),
        '/fingerConfig': (context) => const SettingsPage(),
      },
    );
  }
}
