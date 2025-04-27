import 'package:flutter/material.dart';
import 'package:becerrahernandez_quiz3/models/items_model.dart';
import 'package:becerrahernandez_quiz3/pages/ficha_articulo.dart';
import 'package:becerrahernandez_quiz3/services/api_service.dart';

class ArticulosPage extends StatefulWidget {
  const ArticulosPage({super.key});

  @override
  State<ArticulosPage> createState() => _ArticulosPageState();
}

class _ArticulosPageState extends State<ArticulosPage> {
  late List<ItemsModel> items;
  late String token;
  late bool isOnSale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        isOnSale = args?['isOnSale'] ?? false;
        token = args?['token'] ?? '';
      });
    });
  }

  Future<List<ItemsModel>> _cargarItems() async {
    if (isOnSale) {
      return await APIService.getOnSaleItems(token);
    } else {
      return await APIService.getItems(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artículos')),
      body: FutureBuilder<List<ItemsModel>>(
        future: _cargarItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("Error al cargar los items"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: AlertDialog(
                title: const Text("Sesión Expirada"),
                content: const Text(
                  "Tu sesión ha expirado. Por favor, inicia sesión nuevamente.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        '/',
                        (route) => false,
                        arguments: true,
                      );
                    },
                    child: const Text("Ir a Inicio de Sesión"),
                  ),
                ],
              ),
            );
          } else {
            return mostrarItemsLista(items: snapshot.data!);
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/options',
              arguments: {'biometricLogin': true, 'token': token},
            );
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

  Widget mostrarItemsLista({required List<ItemsModel> items}) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            bool isValidToken = await APIService.validateToken(token);
            if (isValidToken) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleArticuloPage(item: items[index]),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Sesión Expirada"),
                      content: const Text(
                        "Tu sesión ha expirado. Por favor, inicia sesión nuevamente.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                              arguments: true,
                            );
                          },
                          child: const Text("Ir a Inicio de Sesión"),
                        ),
                      ],
                    ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 189, 213, 219),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, 7),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.network(
                              items[index].urlimagen,
                              width: 100,
                              height: 100,
                              cacheHeight: 100,
                              cacheWidth: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].articulo,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    if (int.parse(items[index].descuento) >
                                        0) ...[
                                      Text(
                                        '\$${((items[index].precio) * (1 - int.parse(items[index].descuento) / 100)).truncate().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '\$${(items[index].precio).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${items[index].descuento}% OFF',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        '\$${(items[index].precio).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    RatingStars(
                                      rating:
                                          (items[index].valoracion.toDouble()) /
                                          10,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.yellow, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.black26, size: size);
        }
      }),
    );
  }
}
