import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyoba/models/LoginModel.dart';
import 'package:nyoba/models/UserModel.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'dart:convert';
import 'package:nyoba/services/LoginAPI.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';

import 'HomeProvider.dart';

class LoginProvider with ChangeNotifier {
  LoginModel userLogin;
  bool loading = false;
  String message;
  String countryCode = '+62';

  AccessToken fbAccessToken;
  Map<String, dynamic> fbUserData;

  Future<Map<String, dynamic>> login(context, {username, password}) async {
    var result;
    try {
      loading = true;
      await LoginAPI().loginByDefault(username, password).then((data) {
        result = data;

        if (result['cookie'] != null) {
          UserModel user = UserModel.fromJson(result['user']);
          Session().saveUser(user, result['cookie']);
          Session.data.setString("login_type", 'default');
          final home = Provider.of<HomeProvider>(context, listen: false);

          home.isReload = true;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
          inputDeviceToken();
        } else {
          snackBar(context, message: result['message'], color: Colors.red);
        }
        loading = false;

        notifyListeners();
        printLog(result.toString());
      });
    } catch (e) {
      print(e.toString());
      loading = false;
      notifyListeners();
      snackBar(context,
          message: 'Opps, something is wrong. Please contact the developer',
          color: Colors.red);
    }
    return result;
  }

  Future<void> signInOTP(context, phone) async {
    loading = true;
    await LoginAPI().loginByOTP(phone).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);
        Session.data.setBool('isLogin', true);
        Session.data.setString("cookie", responseJson['cookie']);
        Session.data.setString("login_type", 'otp');

        if (responseJson['user'] != null &&
            responseJson['user'] != "User OTP") {
          Session.data.setString("firstname", responseJson['user']);
        } else {
          Session.data.setString("firstname", responseJson['user_login']);
        }

        final home = Provider.of<HomeProvider>(context, listen: false);

        home.isReload = true;
        loading = false;

        inputDeviceToken();
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
  }

  Future signInWithGoogle(context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      await LoginAPI()
          .loginByGoogle(googleSignInAuthentication.accessToken)
          .then((data) {
        final responseJson = json.decode(data.body);
        if (data.statusCode == 200) {
          Session.data.setBool('isLogin', true);
          Session.data.setString("cookie", responseJson['cookie']);
          Session.data.setString("username", responseJson['user_login']);
          Session.data.setString("login_type", 'google');

          loading = false;
          final home = Provider.of<HomeProvider>(context, listen: false);
          home.isReload = true;
          inputDeviceToken();
          notifyListeners();
          return responseJson;
        } else {
          loading = false;
          notifyListeners();
          return responseJson;
        }
      });
    }
  }

  String prettyPrint(Map json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }

  void _printCredentials() {
    print(
      prettyPrint(fbAccessToken.toJson()),
    );
  }

  Future<void> signInWithFacebook(context) async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by the fault we request the email and the public profilea

    if (result.status == LoginStatus.success) {
      fbAccessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      fbUserData = userData;
      _printCredentials();
      await LoginAPI().loginByFacebook(fbAccessToken.token).then((data) {
        final responseJson = json.decode(data.body);
        if (data.statusCode == 200) {
          Session.data.setBool('isLogin', true);
          Session.data.setString("cookie", responseJson['cookie']);
          Session.data.setString("username", responseJson['user_login']);
          Session.data.setString("login_type", 'facebook');

          final home = Provider.of<HomeProvider>(context, listen: false);
          home.isReload = true;

          loading = false;
          inputDeviceToken();
          notifyListeners();
          return responseJson;
        } else {
          loading = false;
          notifyListeners();
          return responseJson;
        }
      });
    } else {
      print(result.status);
      print(result.message);
    }
  }

  Future<Map<String, dynamic>> inputDeviceToken() async {
    var result;
    await LoginAPI().inputTokenAPI().then((data) {
      result = data;
      loading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<bool> forgotPassword(context, {email}) async {
    bool isSuccess;
    loading = true;
    var result;
    await LoginAPI().forgotPasswordAPI(email).then((data) {
      result = data;

      if (result['status'] == 'success') {
        isSuccess = true;
      } else {
        isSuccess = false;
        snackBar(context, message: result['message'], color: Colors.red);
      }
      loading = false;

      notifyListeners();
      printLog(result.toString());
    });
    return isSuccess;
  }
}
