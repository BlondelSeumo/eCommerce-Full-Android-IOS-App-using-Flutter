import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/provider/LoginProvider.dart';
import 'package:provider/provider.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isVisible = false;
  bool isSuccess = false;

  TextEditingController email = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authLogin = Provider.of<LoginProvider>(context, listen: false);

    var forgotPassword = () async {
      if (email.text.isNotEmpty) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        await Provider.of<LoginProvider>(context, listen: false)
            .forgotPassword(context, email: email.text)
            .then((value) {
          setState(() {
            isSuccess = value;
          });
        });
      } else {
        snackBar(context, message: 'Username or email should not empty');
      }
    };

    Widget buildButton = Container(
      child: ListenableProvider.value(
        value: authLogin,
        child: Consumer<LoginProvider>(builder: (context, value, child) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: 40.h,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: value.loading || email.text.length < 3
                      ? Colors.grey
                      : secondaryColor),
              onPressed: forgotPassword,
              child: value.loading
                  ? customLoading()
                  : Text(
                      AppLocalizations.of(context).translate('reset_password'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveFont(12),
                          fontWeight: FontWeight.bold),
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
              AppLocalizations.of(context).translate('forgot_password_title'),
              style: TextStyle(
                  fontSize: responsiveFont(16), color: secondaryColor),
            ),
            backgroundColor: Colors.white),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: isSuccess
              ? buildSuccess()
              : Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('forgot_password_subtitle'),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: responsiveFont(10),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      child: form(
                          AppLocalizations.of(context)
                              .translate('enter_username_email'),
                          AppLocalizations.of(context)
                              .translate('label_username_email'),
                          true,
                          email,
                          icon: "email"),
                    ),
                    buildButton,
                    Container(
                      height: 15,
                    ),
                  ],
                ),
        ));
  }

  Widget form(
      String hints, String label, bool prefix, TextEditingController controller,
      {String icon = "email"}) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
            prefixIcon: prefix
                ? Container(
                    padding: EdgeInsets.only(right: 5),
                    width: 24.w,
                    height: 24.h,
                    child: Image.asset("images/account/$icon.png"))
                : null,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(10),
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: responsiveFont(12),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }

  Widget buildSuccess() {
    return Container(
      child: Column(
        children: [
          Text(
            "We have sent a notification to the email ${email.text} please check your email. Thank you.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: responsiveFont(12),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: 40.h,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: secondaryColor),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Done",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveFont(12),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
