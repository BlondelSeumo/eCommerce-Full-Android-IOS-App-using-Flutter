import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/PointModel.dart';
import 'package:nyoba/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';

class MyPoint extends StatefulWidget {
  MyPoint({Key key}) : super(key: key);

  @override
  _MyPointState createState() => _MyPointState();
}

class _MyPointState extends State<MyPoint> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // load();
  }

  @override
  Widget build(BuildContext context) {
    final point = Provider.of<UserProvider>(context, listen: false);

    Widget buildPoint = ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: point.point.events.length,
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 5,
            color: HexColor('EEEEEE'),
          );
        },
        itemBuilder: (context, i) {
          return Column(
            children: [buildCardHistory(point.point.events[i])],
          );
        });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('my_point'),
          style: TextStyle(
            fontSize: responsiveFont(14),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: 70,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('congratulation'),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HexColor('FFFFFF')),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('total_point'),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: HexColor('EEEEEE')),
                    ),
                    Text(
                      point.point.pointsBalance.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: HexColor('FFFFFF')),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(child: buildPoint)
        ],
      ),
    );
  }

  Widget buildCardHistory(Events event) {
    final point = Provider.of<UserProvider>(context, listen: false);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: HexColor('212121')),
                ),
                Text(
                  convertDateFormatDash(DateTime.parse(event.date)),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: HexColor('424242')),
                ),
              ],
            ),
          )),
          Container(
            child: Text(
              "${event.points} ${point.point.pointsLabel}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
