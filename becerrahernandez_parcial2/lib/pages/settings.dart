import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:becerrahernandezquiz3/models/login_req_model.dart';
import 'package:becerrahernandezquiz3/services/api_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool biometricLogin;

  Future<void> _authenticate(BuildContext context, String? token) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      // Verifica si el dispositivo soporta autenticación biométrica
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticación biométrica no disponible'),
          ),
        );
        return;
      }

      // Realiza la autenticación biométrica
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor autentícate para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print("Error en autenticación biométrica: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en autenticación biométrica')),
      );
      return;
    }

    if (isAuthenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Autenticación Exitosa')));

      final usernameController = TextEditingController();
      final passwordController = TextEditingController();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reingresa tus credenciales'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;

                  LoginReqModel model = LoginReqModel(
                    username: username,
                    password: password,
                  );

                  try {
                    final response = await APIService.saveLogin(model, token!);
                    if (response) {
                      String? newToken = await APIService.getToken();
                      print('Token guardado: $newToken');
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                        arguments: true,
                      );
                    } else {
                      _showErrorDialog(
                        context,
                        'Usuario o Contraseña inválidos',
                      );
                    }
                  } catch (error) {
                    _showErrorDialog(context, 'Error al guardar el login');
                  }
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Autenticación Fallida')));
    }
  }

  Future<void> _unauthenticate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor autentícate para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print("Error en autenticación biométrica: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en autenticación biométrica')),
      );
      return;
    }

    if (isAuthenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Desautenticación Exitosa')));
      await APIService.deleteToken();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
        arguments: false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Autenticación Fallida')));
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String token = args['token'] as String? ?? '';
    final bool biometricLogin = args['biometricLogin'] as bool? ?? false;

    return Scaffold(
      body: Center(
        child:
            biometricLogin
                ? ElevatedButton(
                  onPressed: () {
                    _unauthenticate(context);
                  },
                  child: const Text('Eliminar datos biométricos'),
                )
                : ElevatedButton(
                  onPressed: () {
                    _authenticate(context, token);
                  },
                  child: const Text('Añadir datos biométricos'),
                ),
      ),
    );
  }
}
