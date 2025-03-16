import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/articles_screen.dart';

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
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return snapshot.data == true ? ArticlesScreen() : LoginScreen();
          }
        },
      ),
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
