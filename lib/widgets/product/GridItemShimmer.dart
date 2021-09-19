import 'package:flutter/material.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:shimmer/shimmer.dart';

class GridItemShimmer extends StatelessWidget {
  final int i, itemCount;

  GridItemShimmer({this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(bottom: 1),
        child: Shimmer.fromColors(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 10,
                            color: Colors.white,
                          ),
                          Container(
                            height: 5,
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: secondaryColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 7),
                                  child: Container(
                                    width: 5,
                                    height: 9,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Container(
                                  width: 50,
                                  height: 8,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              height: 10,
                              width: 30,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          Container(
                            width: 50,
                            height: 8,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: secondaryColor, //Color of the border
                            //Style of the border
                          ),
                          alignment: Alignment.center,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: responsiveFont(9),
                            color: secondaryColor,
                          ),
                          Text(
                            "Add to Cart",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFont(9),
                                color: secondaryColor),
                          )
                        ],
                      )),
                )
              ],
            ),
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100]),
      ),
    );
  }
}
