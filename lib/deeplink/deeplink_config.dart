import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyoba/pages/blog/BlogDetail.dart';
import 'package:nyoba/pages/intro/SplashScreen.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:uni_links/uni_links.dart';

class DeeplinkConfig {
  Future<Widget> initUniLinks(BuildContext context) async {
    Widget screen = SplashScreen();
    Future Function() onLinkClicked;
    try {
      String initialLink = await getInitialLink();
      print(initialLink);
      if (initialLink != null) {
        Uri uri = Uri.parse(initialLink);
        print(uri);

        printLog('Deeplink Exists!', name: 'Deeplink');

        /*Shop (Detail Product)*/
        if (uri.pathSegments[0] == "shop" && uri.pathSegments[1].isNotEmpty) {
          print("Detail Product");
          onLinkClicked = () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetail(
                        slug: uri.pathSegments[1],
                      )));
        }

        /*Blog (Detail Blog)*/
        if (uri.pathSegments[0] == "artikel" &&
            uri.pathSegments[1].isNotEmpty) {
          print("Detail Blog");
          onLinkClicked = () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlogDetail(
                        slug: uri.pathSegments[1],
                      )));
        }

        screen = SplashScreen(
          onLinkClicked: onLinkClicked,
        );
      }
    } on PlatformException {
      print("Error");
    }
    return screen;
  }
}
