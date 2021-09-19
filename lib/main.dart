import 'package:country_code_picker/country_localizations.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nyoba/AppLocalizations.dart';
import 'package:nyoba/deeplink/deeplink_config.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/provider/AppProvider.dart';
import 'package:nyoba/provider/BlogProvider.dart';
import 'package:nyoba/provider/CouponProvider.dart';
import 'package:nyoba/provider/FlashSaleProvider.dart';
import 'package:nyoba/provider/GeneralSettingsProvider.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/provider/LoginProvider.dart';
import 'package:nyoba/provider/NotificationProvider.dart';
import 'package:nyoba/provider/OrderProvider.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/provider/RegisterProvider.dart';
import 'package:nyoba/provider/ReviewProvider.dart';
import 'package:nyoba/provider/SearchProvider.dart';
import 'package:nyoba/provider/UserProvider.dart';
import 'package:nyoba/provider/WishlistProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/GlobalVariable.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nyoba/provider/BannerProvider.dart';
import 'package:nyoba/provider/CategoryProvider.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Session.init();
  final ipv4 = await Ipify.ipv4();
  Session.data.setString('ip', ipv4);
  AppNotifier appLanguage = AppNotifier();
  await appLanguage.fetchLocale();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BannerProvider>(
        create: (context) => BannerProvider(),
      ),
      ChangeNotifierProvider<CategoryProvider>(
        create: (context) => CategoryProvider(),
      ),
      ChangeNotifierProvider<FlashSaleProvider>(
        create: (context) => FlashSaleProvider(),
      ),
      ChangeNotifierProvider<BlogProvider>(
        create: (context) => BlogProvider(),
      ),
      ChangeNotifierProvider<LoginProvider>(
        create: (context) => LoginProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider<ProductProvider>(
        create: (context) => ProductProvider(),
      ),
      ChangeNotifierProvider<GeneralSettingsProvider>(
        create: (context) => GeneralSettingsProvider(),
      ),
      ChangeNotifierProvider<RegisterProvider>(
        create: (context) => RegisterProvider(),
      ),
      ChangeNotifierProvider<WishlistProvider>(
        create: (context) => WishlistProvider(),
      ),
      ChangeNotifierProvider<SearchProvider>(
        create: (context) => SearchProvider(),
      ),
      ChangeNotifierProvider<OrderProvider>(
        create: (context) => OrderProvider(),
      ),
      ChangeNotifierProvider<CouponProvider>(
        create: (context) => CouponProvider(),
      ),
      ChangeNotifierProvider<ReviewProvider>(
        create: (context) => ReviewProvider(),
      ),
      ChangeNotifierProvider<NotificationProvider>(
        create: (context) => NotificationProvider(),
      ),
      ChangeNotifierProvider<AppNotifier>(
        create: (context) => AppNotifier(),
      ),
      ChangeNotifierProvider<HomeProvider>(
        create: (context) => HomeProvider(),
      ),
    ],
    child: MyApp(
      appLanguage: appLanguage,
    ),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final AppNotifier appLanguage;

  MyApp({Key key, this.appLanguage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 640),
        allowFontScaling: false,
        builder: () => ChangeNotifierProvider<AppNotifier>(
              create: (_) => widget.appLanguage,
              child: Consumer<AppNotifier>(
                builder: (context, value, _) => MaterialApp(
                  navigatorKey: GlobalVariable.navState,
                  debugShowCheckedModeBanner: false,
                  locale: value.appLocal,
                  title: 'RevoWoo',
                  routes: <String, WidgetBuilder>{
                    'HomeScreen': (BuildContext context) => HomeScreen(),
                  },
                  theme: value.getTheme(),
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('id', ''),
                    Locale('es', ''),
                    Locale('fr', ''),
                    Locale('zh', ''),
                    Locale('ja', ''),
                    Locale('ko', ''),
                    Locale('ar', ''),
                    Locale("af"),
                    Locale("am"),
                    Locale("ar"),
                    Locale("az"),
                    Locale("be"),
                    Locale("bg"),
                    Locale("bn"),
                    Locale("bs"),
                    Locale("ca"),
                    Locale("cs"),
                    Locale("da"),
                    Locale("de"),
                    Locale("el"),
                    Locale("en"),
                    Locale("es"),
                    Locale("et"),
                    Locale("fa"),
                    Locale("fi"),
                    Locale("fr"),
                    Locale("gl"),
                    Locale("ha"),
                    Locale("he"),
                    Locale("hi"),
                    Locale("hr"),
                    Locale("hu"),
                    Locale("hy"),
                    Locale("id"),
                    Locale("is"),
                    Locale("it"),
                    Locale("ja"),
                    Locale("ka"),
                    Locale("kk"),
                    Locale("km"),
                    Locale("ko"),
                    Locale("ku"),
                    Locale("ky"),
                    Locale("lt"),
                    Locale("lv"),
                    Locale("mk"),
                    Locale("ml"),
                    Locale("mn"),
                    Locale("ms"),
                    Locale("nb"),
                    Locale("nl"),
                    Locale("nn"),
                    Locale("no"),
                    Locale("pl"),
                    Locale("ps"),
                    Locale("pt"),
                    Locale("ro"),
                    Locale("ru"),
                    Locale("sd"),
                    Locale("sk"),
                    Locale("sl"),
                    Locale("so"),
                    Locale("sq"),
                    Locale("sr"),
                    Locale("sv"),
                    Locale("ta"),
                    Locale("tg"),
                    Locale("th"),
                    Locale("tk"),
                    Locale("tr"),
                    Locale("tt"),
                    Locale("uk"),
                    Locale("ug"),
                    Locale("ur"),
                    Locale("uz"),
                    Locale("vi"),
                    Locale("zh")
                  ],
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    CountryLocalizations.delegate,
                  ],
                  home: Builder(
                    builder: (context) {
                      return FutureBuilder(
                          future: DeeplinkConfig().initUniLinks(context),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            return snapshot.data;
                          });
                    },
                  ),
                ),
              ),
            ));
  }
}
