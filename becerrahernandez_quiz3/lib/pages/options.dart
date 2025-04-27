import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String token = args['token'] as String;
    final bool biometricLogin = args['biometricLogin'] as bool;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: {'token': token, 'isOnSale': false},
                    );
                  },
                  icon: const Icon(Icons.article),
                  iconSize: 64,
                  color: Colors.blue,
                ),
                const Text('Artículos', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: {'token': token, 'isOnSale': true},
                    );
                  },
                  icon: const Icon(Icons.discount),
                  iconSize: 64,
                  color: Colors.red,
                ),
                const Text('En Oferta',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/fingerConfig',
                      arguments: {
                        'token': token,
                        'biometricLogin': biometricLogin,
                      },
                    );
                  },
                  icon: const Icon(Icons.fingerprint),
                  iconSize: 64,
                  color: Colors.green,
                ),
                const Text('Datos Biométricos',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}