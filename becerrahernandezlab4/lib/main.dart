import 'package:flutter/material.dart';
import 'item_usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> aItems = [
    {
      "imagen": "assets/7.jpeg",
      "nombres": "Juan Becerra",
      "carrera": "Ing Sistemas",
      "promedio": 3.7
    },
    {
      "imagen": "assets/8.jpeg",
      "nombres": "Gabriela Perez",
      "carrera": "Psicologia",
      "promedio": 4.1
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<ItemUsuario> awItems = [];
    for (var aItem in aItems) {
      awItems.add(
        ItemUsuario(
          sImagen: aItem["imagen"].toString(),
          sNombres: aItem["nombres"].toString(),
          sCarrera: aItem["carrera"].toString(),
          dPromedio: aItem["promedio"],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: awItems,
      ),
    );
  }
}
