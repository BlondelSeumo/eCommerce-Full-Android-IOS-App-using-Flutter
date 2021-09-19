import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'BannerItem.dart';

class BannerContainer extends StatelessWidget {
  final List<dynamic> dataSlider;
  final int dataSliderLength;
  final double contentHeight;
  final Widget loading;

  BannerContainer(
      {@required this.dataSliderLength,
      @required this.contentHeight,
      @required this.dataSlider,
      @required this.loading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: dataSlider.length,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          autoPlay: true,
          height: contentHeight / 6.5,
        ),
        itemBuilder: (context, i, realIdx) {
          var slide = dataSlider[i];

          var imageSlider = slide.image;

          return BannerItem(
            url: imageSlider,
            title: slide.titleSlider,
            index: i,
            dataLength: dataSlider.length,
            loading: loading,
            product: slide.product,
          );
        },
      ),
    );
  }
}
