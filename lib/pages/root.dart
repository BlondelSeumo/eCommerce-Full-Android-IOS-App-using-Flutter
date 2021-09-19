import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:nyoba/pages/intro/SplashScreen.dart';
import 'package:nyoba/services/service.dart';

class Root extends StatefulWidget {
  Root();

  @override
  State<StatefulWidget> createState() {
    return RootState();
  }
}

class RootState extends State<Root> {
  Widget rootWidget = SplashScreen();

  @override
  void initState() {
    super.initState();
    GetIt.instance.registerSingleton<Services>(Services(context));
  }

  @override
  Widget build(BuildContext context) {
    return rootWidget;
  }
}
