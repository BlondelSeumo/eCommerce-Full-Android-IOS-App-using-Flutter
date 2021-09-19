import 'package:flutter/material.dart';
import 'package:nyoba/pages/account/AccountScreen.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:upgrader/upgrader.dart';
import '../../AppLocalizations.dart';
import '../auth/LoginScreen.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'LobbyScreen.dart';
import '../category/CategoryScreen.dart';
import '../order/CartScreen.dart';
import '../blog/BlogScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isLogin = false;
  Animation<double> animation;
  AnimationController controller;
  List<bool> isAnimate = [false, false, false, false, false];
  Timer _timer;

  static List<Widget> _widgetOptions = <Widget>[
    LobbyScreen(),
    BlogScreen(),
    CategoryScreen(
      isFromHome: true,
    ),
    CartScreen(
      isFromHome: true,
    ),
    AccountScreen()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 24, end: 24).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0,
          0.150,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              insetPadding: EdgeInsets.all(0),
              content: Builder(
                builder: (context) {
                  return Container(
                    height: 150.h,
                    width: 330.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('title_exit_alert'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: responsiveFont(14),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('body_exit_alert'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              color: Colors.black12,
                              height: 2,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(false),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15)),
                                          color: primaryColor),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('no'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(true),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(15)),
                                          color: Colors.white),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('yes'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                },
              )),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      debugLogging: true,
      canDismissDialog: false,
      child: WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: bottomNavBar,
                ),
              ],
            ),
          ),
          onWillPop: _onWillPop),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget bottomNavBar(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)]),
      child: BottomAppBar(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.079,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isAnimate[0] = true;
                      _animatedFlutterLogoState(0);
                    });
                    await _onItemTapped(0);
                  },
                  child: Container(
                      child: navbarItem(
                          0,
                          "images/lobby/home.png",
                          "images/lobby/homeClicked.png",
                          AppLocalizations.of(context).translate('home'),
                          28,
                          14)),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[1] = true;
                        _animatedFlutterLogoState(1);

                        _onItemTapped(1);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            1,
                            "images/lobby/writing.png",
                            "images/lobby/writingClicked.png",
                            AppLocalizations.of(context).translate('blog'),
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[2] = true;
                        _animatedFlutterLogoState(2);

                        _onItemTapped(2);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            2,
                            "images/lobby/category.png",
                            "images/lobby/categoryClicked.png",
                            AppLocalizations.of(context).translate('category'),
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isAnimate[3] = true;
                        _animatedFlutterLogoState(3);

                        _onItemTapped(3);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            3,
                            "images/lobby/cart.png",
                            "images/lobby/cartClicked.png",
                            AppLocalizations.of(context).translate('cart'),
                            28,
                            14)),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      if (Session.data.getBool('isLogin') != null) {
                        setState(() {
                          isLogin = Session.data.getBool('isLogin');
                        });
                      }
                      if (!isLogin) {
                        setState(() {
                          _widgetOptions[4] = Login();
                        });
                      } else {
                        setState(() {
                          _widgetOptions[4] = AccountScreen();
                        });
                      }
                      printLog(isLogin.toString(), name: 'isLogin');
                      printLog(Session.data.getBool('isLogin').toString(),
                          name: 'isLoginShared');
                      setState(() {
                        isAnimate[4] = true;
                        _animatedFlutterLogoState(4);

                        _onItemTapped(4);
                      });
                    },
                    child: Container(
                        child: navbarItem(
                            4,
                            "images/lobby/account.png",
                            "images/lobby/accountClicked.png",
                            AppLocalizations.of(context).translate('account'),
                            28,
                            14)),
                  ))
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
        elevation: 5,
      ),
    );
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  _animatedFlutterLogoState(int index) {
    _timer = new Timer(const Duration(milliseconds: 200), () {
      setState(() {
        isAnimate[index] = false;
      });
    });
    return _timer;
  }

  Widget navbarItem(
    int index,
    String image,
    String clickedImage,
    String title,
    int width,
    int smallWidth,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 10,
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: isAnimate[index] == true ? 0 : 1,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.bottomCenter,
              width: isAnimate[index] == true ? smallWidth.w : width.w,
              height: isAnimate[index] == true ? smallWidth.w : width.w,
              child: _selectedIndex == index
                  ? Image.asset(clickedImage)
                  : Image.asset(image)),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            title,
            style: TextStyle(
                fontWeight: _selectedIndex == index
                    ? FontWeight.w600
                    : FontWeight.normal,
                fontSize: responsiveFont(8),
                fontFamily: 'Poppins',
                color: _selectedIndex == index
                    ? primaryColor
                    : Colors.black),
          ),
        ),
        Container(
          height: 3,
        ),
      ],
    );
  }
}
