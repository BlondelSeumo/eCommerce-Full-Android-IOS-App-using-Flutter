import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:shimmer/shimmer.dart';

import '../../AppLocalizations.dart';

class OrderDetailShimmer extends StatefulWidget {
  OrderDetailShimmer({Key key}) : super(key: key);

  @override
  _OrderDetailShimmerState createState() => _OrderDetailShimmerState();
}

class _OrderDetailShimmerState extends State<OrderDetailShimmer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
            child: Shimmer.fromColors(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 30.w,
                              height: 30.h,
                              child: Image.asset("images/order/car.png")),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('shipping_information'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(12),
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: HexColor("EEEEEE"),
                      margin: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                      height: 2,
                      width: double.infinity,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 30.w,
                              height: 30.h,
                              child: Image.asset("images/order/location.png")),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('shipping_address'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(12),
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: HexColor("EEEEEE"),
                      margin: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                      height: 2,
                      width: double.infinity,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 30.w,
                              height: 30.h,
                              child: Icon(Icons.credit_card_outlined)),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('payment_info'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(12),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('payment_method'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(10),
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 10,
                                  width: 150,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('payment_info'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(10),
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: HexColor("EEEEEE"),
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      height: 5,
                      width: double.infinity,
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('subtotal'),
                                style: TextStyle(fontSize: responsiveFont(10)),
                              ),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  AppLocalizations.of(context)
                                      .translate('shipping_cost'),
                                  style:
                                      TextStyle(fontSize: responsiveFont(10))),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  AppLocalizations.of(context)
                                      .translate('total_order'),
                                  style: TextStyle(
                                      fontSize: responsiveFont(10),
                                      fontWeight: FontWeight.w500)),
                              Container(
                                height: 10,
                                width: 100,
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100])),
      ],
    ));
  }
}
