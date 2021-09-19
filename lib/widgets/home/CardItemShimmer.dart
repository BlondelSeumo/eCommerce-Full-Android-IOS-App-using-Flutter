import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardItemShimmer extends StatelessWidget {
  final int i, itemCount;

  CardItemShimmer({this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Container(
        margin: EdgeInsets.only(
            left: i == 0 ? 15 : 0, right: i == itemCount - 1 ? 15 : 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        height: double.infinity,
        child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 10),
            child: Shimmer.fromColors(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 7),
                                      width: 20,
                                      height: 10,
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 70,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Container(
                                    width: 70,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100])),
      ),
    );
  }
}
