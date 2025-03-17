import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/articles_screen.dart';
import 'screens/favorites_screen.dart'; // Importa la pantalla de favoritos

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
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data == true ? ArticlesScreen() : LoginScreen();
            }
          },
        ),
        '/login': (context) => LoginScreen(),
        '/articles': (context) => ArticlesScreen(),
        '/favorites': (context) => FavoritesScreen(), // Añade la ruta para favoritos
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final loginTime = prefs.getInt('loginTime');
    if (token != null && loginTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - loginTime < 7 * 24 * 60 * 60 * 1000) {
        return true;
      } else {
        await prefs.remove('token');
        await prefs.remove('loginTime');
      }
    }
    return false;
  }
}
