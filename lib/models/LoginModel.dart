import 'package:nyoba/models/UserModel.dart';

class LoginModel {
  String cookie, cookieName;
  UserModel userModel;

  LoginModel({this.cookie, this.cookieName, this.userModel});

  Map toJson() => {
    'cookie': cookie,
    'cookie_name': cookieName,
    'user': userModel,
  };

  LoginModel.fromJson(Map json) {
    cookie = json['cookie'];
    cookieName = json['cookie_name'];
    userModel = json['user'];
  }
}

class LoginOTPModel {
  String cookie;
  UserModel userModel;

  LoginOTPModel({this.cookie, this.userModel});

  Map toJson() => {
    'cookie': cookie,
    'user': userModel,
  };

  LoginOTPModel.fromJson(Map json) {
    cookie = json['cookie'];
    userModel = json['user'];
  }
}