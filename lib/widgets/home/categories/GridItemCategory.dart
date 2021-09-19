import 'package:flutter/material.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/pages/category/BrandProduct.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../AppLocalizations.dart';

class GridItemCategory extends StatelessWidget {
  final int i;
  final int itemCount;
  final ProductModel product;
  final String categoryName;
  final int categoryId;

  GridItemCategory(
      {this.i,
      this.itemCount,
      this.product,
      this.categoryName,
      this.categoryId});

  @override
  Widget build(BuildContext context) {
    if (i == 5) {
      return buildViewMore(context);
    }
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
                  child: Image.network(product.images[0].src),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
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
                                    width: 25,
                                    height: 15,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: secondaryColor,
                                    ),
                                    child: Text(
                                      "${product.discProduct.round()}%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: responsiveFont(7)),
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
                                        decoration: TextDecoration.lineThrough),
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
                                    double.parse(product.productPrice), context),
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

  Widget buildViewMore(context) {
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
                      builder: (context) => BrandProducts(
                            categoryId: categoryId.toString(),
                            brandName: categoryName,
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Icon(
                    Icons.add,
                    color: secondaryColor,
                    size: 28,
                  ),
                ),
                Container(
                  child: Text(AppLocalizations.of(context)
                      .translate('view_more'),
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(AppLocalizations.of(context)
                      .translate('sub_view_more'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsiveFont(8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
