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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Category 1';
  bool _isOptionEnabled = false;

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add('${_textController.text} (${_selectedCategory})');
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'List of Items:',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter item',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Category: '),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items: <String>['Category 1', 'Category 2', 'Category 3']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Enable Option: '),
                    Switch(
                      value: _isOptionEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _isOptionEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
