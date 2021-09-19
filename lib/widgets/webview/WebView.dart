import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nyoba/utils/utility.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  final String title;

  WebViewScreen({Key key, this.url, this.title}) : super(key: key);
  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("URL: " + url);
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
              "document.getElementsByClassName('useful-links')[0].style.display= 'none';");
          flutterWebviewPlugin.evalJavascript(
              "document.getElementsByClassName('widget woocommerce widget_product_search')[1].style.display= 'none';");
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
          widget.title.replaceAll("_", " ").toUpperCase(),
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
