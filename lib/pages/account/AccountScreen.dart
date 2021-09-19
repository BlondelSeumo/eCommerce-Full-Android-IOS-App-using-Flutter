import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:launch_review/launch_review.dart';
import 'package:nyoba/AppLocalizations.dart';
import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/pages/language/LanguageScreen.dart';
import 'package:nyoba/pages/account/AccountDetailScreen.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/pages/point/MyPointScreen.dart';
import 'package:nyoba/pages/review/ReviewScreen.dart';
import 'package:nyoba/provider/AppProvider.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/provider/UserProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/widgets/webview/WebView.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../wishlist/WishlistScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../order/MyOrder.dart';
import '../../utils/utility.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  loadDetail() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetail()
        .then((value) => this.setState(() {}));
  }

  logout()async{
    final home = Provider.of<HomeProvider>(context, listen: false);
    var auth = FirebaseAuth.instance;
    final AccessToken accessToken = await FacebookAuth.instance.accessToken;

    Session().removeUser();
    if (auth.currentUser != null) {
      await GoogleSignIn().signOut();
    }
    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
    home.isReload = true;
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    final generalSettings =
        Provider.of<HomeProvider>(context, listen: false);


    final point = Provider.of<UserProvider>(context, listen: false);
    _launchPhoneURL(String phoneNumber) async {
      String url = 'tel:' + phoneNumber;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('title_myAccount'),
          style: TextStyle(
              fontSize: responsiveFont(16),
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  point.loading
                      ? Text(
                          "${AppLocalizations.of(context).translate('hello')}",
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          "${AppLocalizations.of(context).translate('hello')}, ${Session.data.getString('firstname').length > 10 ? Session.data.getString('firstname').substring(0, 10) + '... ' : Session.data.getString('firstname')} !",
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w500),
                        ),
                  Text(
                    AppLocalizations.of(context).translate('welcome_back'),
                    style: TextStyle(fontSize: responsiveFont(9)),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: Colors.black12,
            ),
            point.loading
                ? Container()
                : Visibility(
                    visible: point.point != null,
                    child: buildPointCard(),
                  ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
              child: Text(
                AppLocalizations.of(context).translate('account'),
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w600,
                    color: secondaryColor),
              ),
            ),
            accountButton("akun",
                AppLocalizations.of(context).translate('title_myAccount'),
                func: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountDetailScreen()))
                  .then((value) => this.setState(() {}));
            }),
            point.loading
                ? Container()
                : Visibility(
                    visible: point.point != null,
                    child: accountButton("coin",
                        AppLocalizations.of(context).translate('my_point'),
                        func: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPoint()))
                          .then((value) => this.setState(() {}));
                    }),
                  ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
              child: Text(
                AppLocalizations.of(context).translate('transaction'),
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w600,
                    color: secondaryColor),
              ),
            ),
            accountButton(
                "myorder", AppLocalizations.of(context).translate('my_order'),
                func: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyOrder()));
            }),
            accountButton(
                "wishlist", AppLocalizations.of(context).translate('wishlist'),
                func: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WishList()));
            }),
            accountButton(
                "review", AppLocalizations.of(context).translate('review'),
                func: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReviewScreen()));
            }),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                AppLocalizations.of(context).translate('general_setting'),
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w600,
                    color: secondaryColor),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 25.w,
                              height: 25.h,
                              child:
                                  Image.asset("images/account/darktheme.png")),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate('dark_theme'),
                            style: TextStyle(fontSize: responsiveFont(11)),
                          )
                        ],
                      ),
                      Consumer<AppNotifier>(
                          builder: (context, theme, _) => Switch(
                                value: theme.isDarkMode,
                                onChanged: (value) {
                                  setState(() {
                                    theme.isDarkMode = !theme.isDarkMode;
                                  });
                                  if (theme.isDarkMode) {
                                    theme.setDarkMode();
                                  } else {
                                    theme.setLightMode();
                                  }
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 2,
                  color: Colors.black12,
                )
              ],
            ),
            accountButton("languange",
                AppLocalizations.of(context).translate('title_language'),
                func: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()));
            }),
            accountButton(
                "rateapp", AppLocalizations.of(context).translate('rate_app'),
                func: () {
              LaunchReview.launch(androidAppId: packageName);
            }),
            accountButton(
                "aboutus", AppLocalizations.of(context).translate('about_us'),
                func: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                            url: generalSettings.about.description,
                            title: generalSettings.about.slug.toUpperCase(),
                          )));
            }),
            accountButton(
                "contact", AppLocalizations.of(context).translate('contact'),
                func: () {
              _launchPhoneURL(generalSettings.phone.description);
            }),
            accountButton(
                "logout", AppLocalizations.of(context).translate('logout'),
                func: logoutPopDialog),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "${AppLocalizations.of(context).translate('version')} $version",
                style: TextStyle(
                    fontWeight: FontWeight.w300, fontSize: responsiveFont(10)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget accountButton(String image, String title, {var func}) {
    return Column(
      children: [
        InkWell(
          onTap: func,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset("images/account/$image.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: responsiveFont(11)),
                    )
                  ],
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 2,
          color: Colors.black12,
        )
      ],
    );
  }

  Widget buildPointCard() {
    final point = Provider.of<UserProvider>(context, listen: false);
    String fullName =
        "${Session.data.getString('firstname')} ${Session.data.getString('lastname')}";

    if (point.point == null) {
      return Container();
    }
    return Container(
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Stack(
          children: [
            Image.asset("images/account/card_point.png"),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  Session.data
                      .getString('role')
                      .replaceAll('_', ' ')
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      color: secondaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              top: 15,
              right: 15,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate('full_name'),
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          color: primaryColor,
                          fontWeight: FontWeight.w400)),
                  Text(
                    fullName.length > 10
                        ? fullName.substring(0, 10) + '... '
                        : fullName,
                    style: TextStyle(
                        fontSize: responsiveFont(18),
                        color: secondaryColor,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              bottom: 10,
              left: 15,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context).translate('total_point'),
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          color: primaryColor,
                          fontWeight: FontWeight.w400)),
                  point.loading
                      ? Text(
                          '-',
                          style: TextStyle(
                              fontSize: responsiveFont(18),
                              color: secondaryColor,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          '${point.point.pointsBalance} ${point.point.pointsLabel}',
                          style: TextStyle(
                              fontSize: responsiveFont(18),
                              color: secondaryColor,
                              fontWeight: FontWeight.w600),
                        )
                ],
              ),
              bottom: 10,
              right: 15,
            )
          ],
        ));
  }

  logoutPopDialog(){
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
                              .translate('logout_body_alert'),
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
                                    onTap: () => logout(),
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
}
