import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/ProductNewModel.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';

class CardItem extends StatelessWidget {
  final ProductModel product;
  final ProductNewModel productHome;

  final int i, itemCount;

  CardItem({this.product, this.i, this.itemCount, this.productHome});

  @override
  Widget build(BuildContext context) {
    if (product != null) {
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
          margin: EdgeInsets.only(
              left: i == 0 ? 15 : 0, right: i == itemCount - 1 ? 15 : 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          width: MediaQuery.of(context).size.width / 3,
          height: double.infinity,
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
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
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
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
                            visible: product.discProduct != 0 &&
                                product.discProduct != 0.0,
                            child: Flexible(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
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
                                        color: HexColor("C4C4C4"),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: responsiveFont(8)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Text(
                                stringToCurrency(
                                    double.parse(product.productPrice),
                                    context),
                                style: TextStyle(
                                    fontSize: responsiveFont(10),
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600),
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
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetail(
                        productId: productHome.id.toString(),
                      )));
        },
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
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
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
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
                            visible: productHome.discProduct != 0 &&
                                productHome.discProduct != 0.0,
                            child: Flexible(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
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
                                  Text(convertHtmlUnescape(
                                      productHome.formattedPrice),
                                    style: TextStyle(
                                        color: HexColor("C4C4C4"),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: responsiveFont(8)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Text(
                                productHome.discProduct != 0
                                    ? convertHtmlUnescape(
                                        productHome.formattedSalesPrice)
                                    : convertHtmlUnescape(
                                        productHome.formattedPrice),
                                style: TextStyle(
                                    fontSize: responsiveFont(10),
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600),
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
          ),
        ),
      );
    }
  }
}
