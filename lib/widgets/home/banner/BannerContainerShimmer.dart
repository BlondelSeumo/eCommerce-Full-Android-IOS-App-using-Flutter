import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerContainerShimmer extends StatelessWidget {
  final int dataSliderLength;
  final double contentHeight;

  BannerContainerShimmer(
      {@required this.dataSliderLength, @required this.contentHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: contentHeight / 6.5,
      child: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 10,
            );
          },
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: dataSliderLength,
          itemBuilder: (context, i) {
            return Shimmer.fromColors(
                child: Container(
                  margin: EdgeInsets.only(
                      left: i == 0 ? 15 : 0,
                      right: i == dataSliderLength - 1 ? 15 : 0),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          }),
    );
  }
}
