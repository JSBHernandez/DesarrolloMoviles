import 'package:flutter/material.dart';

class ItemUsuario extends StatelessWidget {
  final String sImagen;
  final String sNombres;
  final String sCarrera;
  final double dPromedio;

  const ItemUsuario({
    super.key,
    required this.sImagen,
    required this.sNombres,
    required this.sCarrera,
    required this.dPromedio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(sImagen, width: 50, height: 50),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sNombres, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(sCarrera, style: TextStyle(fontSize: 16)),
            Text('Promedio: $dPromedio', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}