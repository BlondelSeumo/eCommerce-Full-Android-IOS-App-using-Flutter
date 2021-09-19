import 'package:flutter/material.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWishlist extends StatelessWidget {
  final int i, itemCount;

  ShimmerWishlist({this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            Shimmer.fromColors(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor("c4c4c4"),
                      ),
                      width: 80.h,
                      height: 80.h,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            height: 12,
                          ),
                          Container(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: secondaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                child: Text(
                                  "50%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsiveFont(9)),
                                ),
                              ),
                              Container(
                                width: 5,
                              ),
                              Container(
                                width: 60,
                                color: Colors.white,
                                height: 8,
                              ),
                            ],
                          ),
                          Container(
                            height: 5,
                          ),
                          Container(
                            width: 80,
                            color: Colors.white,
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 25.h,
                                height: 25.h,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                ),
                                child: Image.asset("images/account/trash.png"),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: secondaryColor,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "+ Add to Cart",
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: responsiveFont(9)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100])
          ],
        ),
      ),
    );
  }
}
