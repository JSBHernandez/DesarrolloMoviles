import 'dart:convert';

LoginResModel loginResJson(String str) =>
LoginResModel.fromJson(json.decode(str));

class LoginResModel {
  LoginResModel({
    required this.message,
  });
  late final String message;
  
  LoginResModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}