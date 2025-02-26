import 'package:flutter/material.dart';
import '../models/person.dart';

class ProfileScreen extends StatelessWidget {
  final Person person;

  ProfileScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de ${person.nombreCompleto}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(person.urlImagen),
              ),
            ),
            SizedBox(height: 20),
            Text('Nombre: ${person.nombreCompleto}', style: TextStyle(fontSize: 18)),
            Text('Profesión: ${person.profesion}', style: TextStyle(fontSize: 18)),
            Text('Edad: ${person.edad}', style: TextStyle(fontSize: 18)),
            Text('Universidad: ${person.universidad}', style: TextStyle(fontSize: 18)),
            Text('Bachillerato: ${person.bachillerato}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text('Regresar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}