import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:intl/intl.dart';

import 'dart:developer';

import 'package:nyoba/pages/auth/LoginScreen.dart';
import 'package:nyoba/widgets/home/CardItemShimmer.dart';

import '../AppLocalizations.dart';

Color primaryColor = HexColor("ED1D1D");
Color secondaryColor = HexColor("960000");
Color tertiaryColor = HexColor("ED625E");
Color alternateColor = HexColor("FD490C");

double responsiveFont(double designFont) {
  return ScreenUtil().setSp(designFont, allowFontScalingSelf: true);
}

Widget customLoading({Color color}) {
  return LoadingFlipping.circle(
    borderColor: color != null ? color : secondaryColor,
    borderSize: 3.0,
    size: 30.0,
    duration: Duration(milliseconds: 500),
  );
}

printLog(String message, {String name}) {
  return log(message, name: name ?? 'log');
}

convertDateFormatShortMonth(date) {
  String dateTime = DateFormat("dd MMM yyyy").format(date);
  return dateTime;
}

convertDateFormatSlash(date) {
  String dateTime = DateFormat("dd/MM/yyyy").format(date);
  return dateTime;
}

convertDateFormatFull(date) {
  String dateTime = DateFormat("dd MMMM yyyy").format(date);
  return dateTime;
}

convertDateFormatDash(date) {
  String dateTime = DateFormat("dd-MM-yyyy").format(date);
  return dateTime;
}

snackBar(context, {String message, Color color, int duration = 2}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color != null ? color : null,
    duration: Duration(seconds: duration),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String alertPhone(context){
  return AppLocalizations.of(context).translate('hint_otp');
}

loadingPop(context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.05,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  customLoading(),
                  SizedBox(width: 10),
                  Text("Loading...")
                ],
              )
          )
      );
    },
    barrierDismissible: false,
  );
}

buildNoAuth(context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset("images/lobby/403.png"),
      SizedBox(height: 10,),
      Text("Oops, please login first to use this feature", style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 14
      ),),
      SizedBox(height: 10,),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, secondaryColor])),
        height: 30.h,
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login()));
          },
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: responsiveFont(10), fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}

convertHtmlUnescape(String textCharacter){
  var unescape = HtmlUnescape();
  var text = unescape.convert(textCharacter);
  return text;
}

Widget shimmerProductItemSmall() {
  return ListView.separated(
    itemCount: 6,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, i) {
      return CardItemShimmer(
        i: i,
        itemCount: 6,
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return SizedBox(
        width: 5,
      );
    },
  );
}