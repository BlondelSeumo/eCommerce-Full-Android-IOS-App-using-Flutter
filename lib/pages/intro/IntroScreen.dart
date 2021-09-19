import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/models/GeneralSettingsModel.dart';
import 'package:nyoba/services/Session.dart';
import '../../utils/utility.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  final List<GeneralSettingsModel> intro;
  IntroScreen({Key key, this.intro}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget titleWidget(String title, String _image) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 40.0)),
          Container(
            child: Image.network(
              _image,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Icon(
                  Icons.broken_image_outlined,
                  size: 128,
                );
              },
            ),
          ),
          // Padding(padding: EdgeInsets.only(top: 20.0)),
          Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              minFontSize: 18,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void _openHome(context) {
    Session.data.setBool('isIntro', true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0);
    const pageDecoration = const PageDecoration(
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      pageColor: Colors.white,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        for (var i = 0; i < widget.intro.length; i++)
          PageViewModel(
            titleWidget:
                titleWidget(widget.intro[i].title, widget.intro[i].image),
            decoration: pageDecoration,
            bodyWidget: Text(
              widget.intro[i].description,
              textAlign: TextAlign.center,
            ),
          ),
      ],
      onDone: () => _openHome(context),
      showNextButton: true,
      showSkipButton: true,
      nextFlex: 0,
      skipFlex: 0,
      globalBackgroundColor: Colors.white,
      skip: Text(
        'Skip',
        style: TextStyle(color: primaryColor),
      ),
      next: Text('Next', style: TextStyle(color: primaryColor)),
      done: Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeColor: primaryColor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
