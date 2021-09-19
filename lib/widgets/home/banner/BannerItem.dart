import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';

class BannerItem extends StatelessWidget {
  final url;
  final title;
  final int index;
  final Widget loading;
  final int dataLength;
  final int product;

  BannerItem(
      {@required this.url,
      @required this.title,
      @required this.index,
      this.loading,
      this.dataLength,
      this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: index == 0 ? 0 : 10, right: index == dataLength - 1 ? 0 : 10),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
            ),
            borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            if (product != null)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        productId: product.toString(),
                      )));
          },
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  // colorFilter: ColorFilter.mode(
                  //     Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
          ),
        ));
  }
}
