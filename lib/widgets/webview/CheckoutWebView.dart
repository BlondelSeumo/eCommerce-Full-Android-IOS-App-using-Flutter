import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';

class CheckoutWebView extends StatefulWidget {
  final url;
  final Future<dynamic> Function() onFinish;

  CheckoutWebView({Key key, this.url, this.onFinish}) : super(key: key);
  @override
  CheckoutWebViewState createState() => CheckoutWebViewState();
}

class CheckoutWebViewState extends State<CheckoutWebView> {
  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("URL: " + url);
      if (url.contains("/checkout/order-received/")) {
        final items = url.split("/checkout/order-received/");
        if (items.length > 1) {
          final number = items[1].split("/")[0];
          Session.data.setString('order_number', number);
        }
        widget.onFinish();
      }
    });
    flutterWebviewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('headerwrap').style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('footerwrap').style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('header')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('footer')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('return-to-shop')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('page-title')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('woocommerce-error')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('woocommerce-breadcrumb')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('entry-title')[0].style.display= 'none';");
        });
      }
    });
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('headerwrap')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('footerwrap').style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('header')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('footer')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('return-to-shop')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('page-title')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('woocommerce-error')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('woocommerce-breadcrumb')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('entry-title')[0].style.display= 'none';");
        });
      }
    });
    flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('headerwrap').style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('header')[0].style.display= 'none';");
        });
      }
    });
    flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          flutterWebviewPlugin.evalJavascript(
              "document.getElementById('headerwrap').style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByTagName('header')[0].style.display= 'none';");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      withJavascript: true,
      appCacheEnabled: true,
      url: widget.url,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Checkout Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(child: customLoading()),
    );
  }
}
