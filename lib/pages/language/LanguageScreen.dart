import 'package:flutter/material.dart';
import 'package:nyoba/AppLocalizations.dart';
import 'package:nyoba/provider/AppProvider.dart';
import 'package:provider/provider.dart';
import '../../utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({Key key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> image = [
    "uk",
    "indonesian",
    "spanish",
    "french",
    "chinese",
    "japanese",
    "korean",
    "arabic",
  ];
  List<String> title = [
    "English",
    "Indonesian",
    "Spanish",
    "French",
    "Chinese",
    "Japanese",
    "Korean",
    "Arabic"
  ];

  String locale(int index) {
    String locale = 'en';
    if (index == 0) {
      locale = 'en';
    } else if (index == 1) {
      locale = 'id';
    } else if (index == 2) {
      locale = 'es';
    } else if (index == 3) {
      locale = 'fr';
    } else if (index == 4) {
      locale = 'zh';
    } else if (index == 5) {
      locale = 'ja';
    } else if (index == 6) {
      locale = 'ko';
    } else if (index == 7) {
      locale = 'ar';
    }
    return locale;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('title_language'),
          style: TextStyle(
              color: Colors.black,
              fontSize: responsiveFont(16),
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: (){
                      setState(() {
                        appLanguage.selectedLocaleIndex = i;
                      });
                      appLanguage.changeLanguage(
                          Locale(locale(appLanguage.selectedLocaleIndex)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: itemList(image[i], title[i], i),
                    ),
                  );
                },
                itemCount: title.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    height: 1,
                    color: HexColor("c4c4c4"),
                  );
                },
              ),
            ],
          )),
    );
  }

  Widget itemList(String image, String title, int i) {
    var appLanguage = Provider.of<AppNotifier>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 36.h,
                    height: 36.w,
                    child: Image.asset("images/account/$image.png")),
                SizedBox(
                  width: 15,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: responsiveFont(12)),
                )
              ],
            ),
            appLanguage.selectedLocaleIndex == i
                ? Text(
                    "Active",
                    style: TextStyle(
                        fontSize: responsiveFont(12),
                        fontWeight: FontWeight.w600,
                        color: secondaryColor),
                  )
                : Container()
          ],
        )
      ],
    );
  }
}
