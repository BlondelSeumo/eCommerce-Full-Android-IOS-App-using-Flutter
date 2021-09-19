import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/pages/intro/IntroScreen.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final Future Function() onLinkClicked;
  SplashScreen({Key key, this.onLinkClicked}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startSplashScreen() async {
    final home = Provider.of<HomeProvider>(context, listen: false);
    var duration = const Duration(milliseconds: 2500);

    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Session.data.getBool('isIntro')
            ? HomeScreen()
            : IntroScreen(
                intro: home.intro,
              );
      }));
      if (widget.onLinkClicked != null) {
        print("URL Available");
        widget.onLinkClicked();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Session.data.containsKey('isIntro')) {
      Session.data.setBool('isLogin', false);
      Session.data.setBool('isIntro', false);
    }
    printLog(widget.onLinkClicked.toString());
    loadHome();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadHome() async {
    await Provider.of<HomeProvider>(context, listen: false)
        .fetchHome()
        .then((value) async {
      this.setState(() {});
      await startSplashScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
        body: home.loading
            ? Container()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            child: CachedNetworkImage(
                              imageUrl: home.splashscreen.image,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Text(
                            home.splashscreen.title,
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            home.splashscreen.description,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Version $version",
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                )));
  }
}
