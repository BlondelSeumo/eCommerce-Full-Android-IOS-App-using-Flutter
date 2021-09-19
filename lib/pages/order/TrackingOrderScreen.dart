import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clipboard/clipboard.dart';

class TrackingOrder extends StatefulWidget {
  TrackingOrder({Key key}) : super(key: key);

  @override
  _TrackingOrderState createState() => _TrackingOrderState();
}

class _TrackingOrderState extends State<TrackingOrder> {
  int itemCount = 6;
  List<String> location = [
    "[SURABAYA] The package has been received [Alex Eko]",
    "[SURABAYA] The package will be sent to the recipient's address",
    "[SURABAYA] The package has arrived at the Drop Center in SURABAYA",
    "[JAKARTA] The package will be sent to the Drop Center in SURABAYA",
    "[JAKARTA] The package has been received by Drop Point in JAKARTA (JNT: JP64234879990)",
    "[JAKARTA] The package has been received by Drop Point in JAKARTA"
  ];
  List<String> date = [
    "Today, 08:23",
    "12 Mar, 10:23",
    "11 Mar, 12:23",
    "10 Mar, 14:23",
    "9 Mar, 16:23",
    "9 Mar, 08:23"
  ];
  String code = "JP64234879990";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Done",
          style: TextStyle(fontSize: responsiveFont(16), color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: HexColor("fafafa")),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                          color: HexColor("c4c4c4"),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SSD V-Gen 64GB 128GB 256GB 512GB 1TB 2TB SATA3 | PREMIUM",
                          style: TextStyle(
                              fontSize: responsiveFont(10),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Shipped with J&T Express",
                          style: TextStyle(fontSize: responsiveFont(10)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("No receipt"),
                  Row(
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            FlutterClipboard.copy(code)
                                .then((value) => print('copied'));
                          });
                        },
                        child: Text(
                          "Copy",
                          style: TextStyle(
                              fontSize: responsiveFont(10),
                              fontWeight: FontWeight.w500,
                              color: primaryColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 15),
              height: 1,
              width: double.infinity,
              color: HexColor("c4c4c4"),
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, i) {
                return trackingorder(
                    date[i], location[i], i == 0 ? true : false, i);
              },
              itemCount: itemCount,
            ),
          ],
        )),
      ),
    );
  }

  Widget trackingorder(String date, String location, bool position, int index) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: position ? primaryColor : HexColor("929292")),
              ),
              index == itemCount - 1
                  ? Container()
                  : Expanded(
                      child: Container(
                        width: 2,
                        color: HexColor("c4c4c4"),
                      ),
                    )
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                    date,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  location,
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      color:
                          position ? primaryColor : HexColor("929292")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
