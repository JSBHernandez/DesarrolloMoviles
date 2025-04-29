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
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor autentícate para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print("Error en autenticación biométrica: $e");
    }

    if (isAuthenticated) {
      // Muestra un mensaje de autenticación exitosa.
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

                  APIService.saveLogin(model, token!)
                      .then((response) async {
                        if (response) {
                          String? token = await APIService.getToken();
                          print('Token guardado: $token');
                          Navigator.pushNamedAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,
                            '/',
                            (route) => false,
                            arguments: true,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Login'),
                                content: const Text(
                                  'Usuario o Contraseña invalidos',
                                ),
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
                      })
                      .catchError((error) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('ERROR'),
                              content: const Text('ERROR'),
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
                      });
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      // Si la autenticación falla.
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
    }

    if (isAuthenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Desautenticación Exitosa')));
      await APIService.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
        // ignore: use_build_context_synchronously
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
