import 'package:flutter/material.dart';
import 'screens/persons_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonsScreen(),
    );
  }
}