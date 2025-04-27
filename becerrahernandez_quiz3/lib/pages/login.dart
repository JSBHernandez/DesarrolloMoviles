import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:becerrahernandez_quiz3/models/login_req_model.dart';
import 'package:becerrahernandez_quiz3/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool isAuthenticated = false;
  bool isAPI = false;
  bool hidePassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#ffffff'),
        body: ProgressHUD(
          inAsyncCall: isAPI,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(key: formKey, child: _loginUI(context)),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Align(alignment: Alignment.center)],
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 20, right: 30, top: 50)),
          FormHelper.inputFieldWidget(
            context,
            prefixIcon: const Icon(Icons.email),
            showPrefixIcon: true,
            "username",
            "Email",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Tiene que ingresar un nombre de usuario.";
              }
              return null;
            },
            (onSavedVal) {
              username = onSavedVal;
            },
            borderFocusColor: Colors.black,
            prefixIconColor: Colors.black,
            borderColor: Colors.black,
            textColor: Colors.black,
            hintColor: Colors.black.withOpacity(0.7),
            borderRadius: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: FormHelper.inputFieldWidget(
              context,
              prefixIcon: const Icon(Icons.password),
              showPrefixIcon: true,
              "password",
              "Contraseña",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Tiene que ingresar una contraseña.";
                }
                return null;
              },
              (onSavedVal) {
                password = onSavedVal;
              },
              borderFocusColor: Colors.black,
              prefixIconColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.black.withOpacity(0.7),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: FormHelper.submitButton(
              "Iniciar Sesion",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPI = true;
                  });

                  LoginReqModel model = LoginReqModel(
                    username: username!,
                    password: password!,
                  );

                  APIService.login(model)
                      .then((response) {
                        setState(() {
                          isAPI = false;
                        });

                        if (response['success']) {
                          String token = response['token']; // Obtén el token
                          if (!isAuthenticated) {
                            Navigator.pushNamedAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              '/fingerConfig',
                              (route) => false,
                              arguments: {'token': token},
                            );
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              '/options',
                              (route) => false,
                              arguments: {
                                'biometricLogin': true,
                                'token': token,
                              },
                            );
                          }
                        } else {
                          FormHelper.showSimpleAlertDialog(
                            // ignore: use_build_context_synchronously
                            context,
                            "Login",
                            "Usuario o Contraseña invalidos",
                            "OK",
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      })
                      .catchError((error) {
                        setState(() {
                          isAPI = false;
                        });
                        FormHelper.showSimpleAlertDialog(
                          // ignore: use_build_context_synchronously
                          context,
                          "Error",
                          error.toString(),
                          "OK",
                          () {
                            Navigator.pop(context);
                          },
                        );
                      });
                }
              },
              btnColor: HexColor('#3199d6'),
              borderColor: HexColor('#3199d6'),
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ),
          const SizedBox(height: 20),
          if (isAuthenticated)
            Center(
              child: ElevatedButton(
                onPressed: () => _authenticateWithBiometrics(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#3199d6'),
                  fixedSize: const Size(320, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión con Datos Biométricos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void showLoginSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '¡Éxito!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Iniciaste sesión exitosamente.',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Autentíquese para ingresar a la aplicación',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        String? token = await _storage.read(key: 'token');
        print(token);
        if (token != null) {
          final response = await APIService.loginBiom(token);
          if (response['success']) {
            String token = response['token'];
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/options',
              (route) => false,
              arguments: {'biometricLogin': true, 'token': token},
            );
          } else {
            FormHelper.showSimpleAlertDialog(
              context,
              "Error",
              "Sesion Expirada.",
              "OK",
              () {
                Navigator.pop(context);
              },
            );
          }
        } else {
          FormHelper.showSimpleAlertDialog(
            context,
            "Error",
            "No se pudo obtener la sesión.",
            "OK",
            () {
              Navigator.pop(context);
            },
          );
        }
      } else {
        FormHelper.showSimpleAlertDialog(
          context,
          "Error",
          "No se pudo autenticar",
          "OK",
          () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool? result = ModalRoute.of(context)?.settings.arguments as bool?;
    if (result != null && result) {
      setState(() {
        isAuthenticated = result;
      });
    }
  }
}
