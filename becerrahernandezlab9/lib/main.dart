import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab9 JSBH'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstView()),
                );
              },
              child: const Text('Vista 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondView()),
                );
              },
              child: const Text('Vista 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstView extends StatefulWidget {
  const FirstView({super.key});

  @override
  State<FirstView> createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  String _selectedOption = 'None';

  void _showOptions() {
    String? selectedOption = _selectedOption;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<String>(
                  title: const Text('Amarillo'),
                  value: 'Amarillo',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Naranja'),
                  value: 'Naranja',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Rojo'),
                  value: 'Rojo',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Verde'),
                  value: 'Verde',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Azul'),
                  value: 'Azul',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedOption);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedOption = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _showOptions,
              child: const Text('Mostrar Opciones'),
            ),
            const SizedBox(height: 16.0),
            Text('Opción seleccionada: $_selectedOption'),
          ],
        ),
      ),
    );
  }
}

class SecondView extends StatelessWidget {
  const SecondView({super.key});

  void _navigateToThirdView(BuildContext context, String buttonLabel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThirdView(buttonLabel: buttonLabel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToThirdView(context, 'Botón Lila'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Botón Lila'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToThirdView(context, 'Botón Rojo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Botón Rojo'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToThirdView(context, 'Botón Naranja'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Botón Naranja'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdView extends StatelessWidget {
  final String buttonLabel;

  const ThirdView({super.key, required this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista 3'),
      ),
      body: Center(
        child: Text('Botón presionado: $buttonLabel'),
      ),
    );
  }
}
