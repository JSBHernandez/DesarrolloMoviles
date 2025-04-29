import 'package:flutter/material.dart';
import 'package:becerrahernandezquiz3/models/items_model.dart';
import 'package:becerrahernandezquiz3/pages/articulos.dart';

class DetalleArticuloPage extends StatelessWidget {
  final ItemsModel item;

  const DetalleArticuloPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double descuento = double.parse(item.descuento);
    final double precio = item.precio.toDouble();
    final double precioConDescuento =
        (precio * (1 - descuento / 100)).truncateToDouble();

    return Scaffold(
      appBar: AppBar(title: Text(item.articulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              item.urlimagen,
              width: 300,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 300);
              },
            ),
            const SizedBox(height: 16),
            Text(
              item.articulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (descuento > 0) ...[
              Text(
                '\$${precioConDescuento.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              // Precio original tachado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${precio.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Descuento
                  Text(
                    '${descuento.toStringAsFixed(0)}% OFF',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ] else ...[
              // Mostrar solo precio si no hay descuento
              Text(
                '\$${precio.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ((item.valoracion.toDouble()) / 10).toString(),
                  style: const TextStyle(fontSize: 45),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    RatingStars(
                      rating: (item.valoracion.toDouble()) / 10,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.calificaciones} calificaciones',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Regresar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
