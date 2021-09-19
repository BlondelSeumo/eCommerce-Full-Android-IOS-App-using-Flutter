import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/size_extension.dart';

class ListItemProduct extends StatelessWidget {
  final ProductModel product;
  final int i, itemCount;

  ListItemProduct({this.product, this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      productId: product.id.toString(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 60.h,
                  height: 60.h,
                  child: CachedNetworkImage(
                    imageUrl: product.images[0].src,
                    placeholder: (context, url) => customLoading(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          HtmlWidget(
                            product.productDescription.length > 100
                                ? '${product.productDescription.substring(0, 100)} ...'
                                : product.productDescription,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: responsiveFont(9)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: product.discProduct != 0,
                            child: Text(
                              stringToCurrency(
                                  double.parse(product.productRegPrice), context),
                              style: TextStyle(
                                  color: HexColor("C4C4C4"),
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: responsiveFont(8)),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            stringToCurrency(
                                double.parse(product.productPrice), context),
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                color: secondaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
