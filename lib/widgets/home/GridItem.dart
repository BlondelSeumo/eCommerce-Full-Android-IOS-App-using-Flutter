import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/models/ProductNewModel.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../pages/product/ProductDetailScreen.dart';

class GridItem extends StatelessWidget {
  final int i;
  final int itemCount;
  final ProductModel product;
  final ProductNewModel productHome;

  GridItem({this.i, this.itemCount, this.product, this.productHome});

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetail(
                              productId: product.id.toString(),
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.images[0].src,
                      placeholder: (context, url) => customLoading(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_rounded,
                        size: 25,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                product.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: responsiveFont(10)),
                              ),
                            ),
                            Container(
                              height: 5,
                            ),
                            Visibility(
                              visible: product.discProduct != 0,
                              child: Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: secondaryColor,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 7),
                                      child: Text(
                                        "${product.discProduct.round()}%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsiveFont(9)),
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Text(
                                      stringToCurrency(
                                          double.parse(product.productRegPrice),
                                          context),
                                      style: TextStyle(
                                          fontSize: responsiveFont(8),
                                          color: HexColor("C4C4C4"),
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                child: AutoSizeText(
                                  stringToCurrency(
                                      double.parse(product.productPrice),
                                      context),
                                  minFontSize: 10,
                                  style: TextStyle(
                                      fontSize: responsiveFont(10),
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetail(
                              productId: productHome.id.toString(),
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: productHome.images[0].src,
                      placeholder: (context, url) => customLoading(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_rounded,
                        size: 25,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                productHome.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: responsiveFont(10)),
                              ),
                            ),
                            Container(
                              height: 5,
                            ),
                            Visibility(
                              visible: productHome.discProduct != 0,
                              child: Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: secondaryColor,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 7),
                                      child: Text(
                                        "${productHome.discProduct.round()}%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsiveFont(9)),
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Text(
                                      convertHtmlUnescape(
                                          productHome.formattedPrice),
                                      style: TextStyle(
                                          fontSize: responsiveFont(8),
                                          color: HexColor("C4C4C4"),
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                child: AutoSizeText(
                                  productHome.discProduct != 0
                                      ? convertHtmlUnescape(
                                          productHome.formattedSalesPrice)
                                      : convertHtmlUnescape(
                                          productHome.formattedPrice),
                                  minFontSize: 10,
                                  style: TextStyle(
                                      fontSize: responsiveFont(10),
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )),
      );
    }
  }
}
