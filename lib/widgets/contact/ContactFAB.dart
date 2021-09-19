import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFAB extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final contact = Provider.of<HomeProvider>(context, listen: false);

    void _sendSMS(String message, List<String> recipents) async {
      String _result = await sendSMS(message: message, recipients: recipents)
          .catchError((onError) {
        print(onError);
      });
      print(_result);
    }

    _launchPhoneURL(String phoneNumber) async {
      String url = 'tel:' + phoneNumber;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    _launchWAURL(String phoneNumber) async {
      String url = 'https://api.whatsapp.com/send?phone=$phoneNumber&text=Hi';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return FabCircularMenu(
        fabMargin: EdgeInsets.only(bottom: 55.h, right: 15),
        fabColor: primaryColor,
        fabOpenIcon: Container(
            width: 24.w,
            height: 24.h,
            child: Image.asset("images/account/comment.png")),
        fabCloseIcon: Container(
            width: 24.w,
            height: 24.h,
            child: Image.asset("images/account/comment.png")),
        ringColor: Colors.transparent,
        ringDiameter: 280,
        children: <Widget>[
          Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: IconButton(
                icon: Container(
                    height: 20.h,
                    width: 20.w,
                    child: Image.asset("images/account/sms.png")),
                onPressed: () {
                  _sendSMS('', [contact.sms.description]);
                }),
          ),
          Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: IconButton(
                icon: Container(
                    height: 20.h,
                    width: 20.w,
                    child: Image.asset("images/account/call.png")),
                onPressed: () {
                  _launchPhoneURL(contact.phone.description);
                }),
          ),
          Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: IconButton(
                icon: Container(
                    height: 20.h,
                    width: 20.w,
                    child: Image.asset("images/account/whatsapp.png")),
                onPressed: () {
                  _launchWAURL(contact.wa.description);
                }),
          )
        ]);
  }
}
