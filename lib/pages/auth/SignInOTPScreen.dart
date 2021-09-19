import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/pages/auth/InputOTP.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/provider/LoginProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:provider/provider.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SignInOTPScreen extends StatefulWidget {
  SignInOTPScreen({Key key}) : super(key: key);

  @override
  _SignInOTPScreenState createState() => _SignInOTPScreenState();
}

class _SignInOTPScreenState extends State<SignInOTPScreen> {
  bool isVisible = false;
  bool otpInvalid = false;

  TextEditingController phone = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  loginOTP(var _phone) async {
    await Provider.of<LoginProvider>(context, listen: false)
        .signInOTP(context, _phone)
        .then((value) {
      if (Session.data.getString('cookie') != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }

  int _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    final authLogin = Provider.of<LoginProvider>(context, listen: false);

    signInOTP(String phoneNumber, LoginProvider loginProvider) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      var phone =
          Provider.of<LoginProvider>(context, listen: false).countryCode +
              phoneNumber;
      var phoneUser = Provider.of<LoginProvider>(context, listen: false)
              .countryCode
              .replaceAll("+", "") +
          phoneNumber;

      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(minutes: 1),
        verificationCompleted: (credential) {
          print("completed $credential");
        },
        verificationFailed: (e) {
          print(e.message);
          snackBar(context, message: e.message, color: Colors.red);
          setState(() {
            loginProvider.loading = false;
          });
        },
        forceResendingToken: _forceResendingToken,
        codeSent: (verificationId, [forceResendingToken]) async {
          _forceResendingToken = forceResendingToken;
          final code = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InputOTP(phone: phoneNumber)));
          if (code != null) {
            print(code);
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: code);
            await auth
                .signInWithCredential(phoneAuthCredential)
                .then((value) async {
              if (value.user.uid != null && value.user.uid != '') {
                /*If Success*/
                print('Success');
                loginOTP(phoneUser);
              }
            }).catchError((error) {
              print(error);
              print('Failed');
              snackBar(context,
                  message:
                      AppLocalizations.of(context).translate('otp_invalid'),
                  color: Colors.red);
              setState(() {
                loginProvider.loading = false;
                otpInvalid = true;
              });
            });
          } else {
            setState(() {
              loginProvider.loading = false;
              otpInvalid = true;
            });
            snackBar(context, message: 'Login by OTP cancelled.');
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print('timeout');
        },
      );
    }

    Widget buildButton = Container(
      child: ListenableProvider.value(
        value: authLogin,
        child: Consumer<LoginProvider>(builder: (context, value, child) {
          return Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 40.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: value.loading || phone.text.length < 5
                          ? Colors.grey
                          : secondaryColor),
                  onPressed: () {
                    if (phone.text.isNotEmpty) {
                      setState(() {
                        value.loading = true;
                        otpInvalid = false;
                      });
                      signInOTP(phone.text, value);
                    }
                  },
                  child: value.loading
                      ? customLoading()
                      : Text(
                          otpInvalid
                              ? 'Resend OTP'
                              : AppLocalizations.of(context).translate('login'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveFont(12),
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          );
        }),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: AutoSizeText(
              "${AppLocalizations.of(context).translate('sign_in')} OTP",
              style: TextStyle(
                  fontSize: responsiveFont(16), color: secondaryColor),
            ),
            backgroundColor: Colors.white),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('title_otp'),
                style: TextStyle(
                  fontSize: responsiveFont(14),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: secondaryColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: CountryCodePicker(
                        onChanged: (e) {
                          Provider.of<LoginProvider>(context, listen: false)
                              .countryCode = e.dialCode;
                          print(e);
                        },
                        initialSelection:
                            Provider.of<LoginProvider>(context, listen: false)
                                .countryCode,
                        padding: EdgeInsets.zero,
                        showFlagDialog: true,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: secondaryColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          controller: phone,
                          onChanged: (value) {
                            this.setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: responsiveFont(14),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: responsiveFont(14),
                              ),
                              hintText: AppLocalizations.of(context)
                                  .translate('input_otp_hint')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: phone.text.length < 5 && phone.text.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    alertPhone(context),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              buildButton,
              Container(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
