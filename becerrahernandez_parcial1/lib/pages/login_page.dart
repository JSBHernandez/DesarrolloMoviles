import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parcial/config.dart';
import 'package:parcial/models/login_request_model.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/formHelper.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: false,
        ),
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
            height: 60,
          ),
          const SizedBox(height: 50),
          FormHelper.inputFieldWidget(
            context,
            "username",
            "UserName",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Username can\'t be empty.';
              }
              return null;
            },
            (onSavedVal) {
              username = onSavedVal;
            },
            borderFocusColor: Colors.blue,
            prefixIconColor: Colors.blue,
            borderColor: Colors.blue,
            textColor: Colors.black,
            hintColor: Colors.grey,
            borderRadius: 5,
          ),
          const SizedBox(height: 20),
          FormHelper.inputFieldWidget(
            context,
            "password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Password can\'t be empty.';
              }
              return null;
            },
            (onSavedVal) {
              password = onSavedVal;
            },
            borderFocusColor: Colors.blue,
            prefixIconColor: Colors.blue,
            borderColor: Colors.blue,
            textColor: Colors.black,
            hintColor: Colors.grey,
            borderRadius: 5,
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Colors.blue.withOpacity(0.7),
              icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  LoginRequestModel model = LoginRequestModel(
                      username: username!, password: password!);
                  APIService.login(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (response) {
                      APIService.getAndInsertFavorites(username!).then((_) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      }).catchError((error) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Error al obtener e insertar los favoritos: $error",
                          "OK",
                          () {
                            Navigator.pop(context);
                          },
                        );
                      });
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Credenciales incorrectas!",
                        "OK",
                        () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  }).catchError((error) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    FormHelper.showSimpleAlertDialog(
                      context,
                      Config.appName,
                      "Error: $error",
                      "OK",
                      () {
                        Navigator.pop(context);
                      },
                    );
                  });
                }
              },
              btnColor: Colors.blue,
              borderColor: Colors.blue,
              txtColor: Colors.white,
              borderRadius: 5,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                    children: <TextSpan>[
                      const TextSpan(text: "No tienes cuenta? "),
                      TextSpan(
                          text: "Registrarse",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, "/register");
                            }),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
