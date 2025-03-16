import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:becerrahernandez_parcial1/config.dart';
import 'package:becerrahernandez_parcial1/models/register_request_model.dart';
import 'package:becerrahernandez_parcial1/services/api_service.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:snippet_coder_utils/formHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? userName;
  String? password;
  String? email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Register",
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
            child: _registerUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
            height: 60,
          ),
          const SizedBox(height: 50),
          FormHelper.inputFieldWidget(
            context,
            "Username",
            "Username",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Username can\'t be empty.';
              }
              return null;
            },
            (onSavedVal) => {
              userName = onSavedVal,
            },
            initialValue: "",
            obscureText: false,
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
            "Password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Password can\'t be empty.';
              }
              return null;
            },
            (onSavedVal) => {
              password = onSavedVal,
            },
            initialValue: "",
            obscureText: hidePassword,
            borderFocusColor: Colors.blue,
            prefixIconColor: Colors.blue,
            borderColor: Colors.blue,
            textColor: Colors.black,
            hintColor: Colors.grey,
            borderRadius: 5,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Colors.blue.withOpacity(0.7),
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FormHelper.inputFieldWidget(
            context,
            "Email",
            "Email",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Email can\'t be empty.';
              }
              return null;
            },
            (onSavedVal) => {
              email = onSavedVal,
            },
            initialValue: "",
            borderFocusColor: Colors.blue,
            prefixIconColor: Colors.blue,
            borderColor: Colors.blue,
            textColor: Colors.black,
            hintColor: Colors.grey,
            borderRadius: 5,
          ),
          const SizedBox(height: 30),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                    username: userName!,
                    password: password!,
                    email: email!,
                  );

                  APIService.register(model).then(
                    (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      if (response.data != null) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          response.message,
                          "OK",
                          () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          response.message,
                          "OK",
                          () {
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: Colors.blue,
              borderColor: Colors.blue,
              txtColor: Colors.white,
              borderRadius: 5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
