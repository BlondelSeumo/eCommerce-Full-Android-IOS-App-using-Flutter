import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/ProductNewModel.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FlashSaleContainer extends StatelessWidget {
  final AnimationController colorAnimationController;
  final AnimationController textAnimationController;

  final Animation colorTween, titleColorTween, iconColorTween, moveTween;
  final List<ProductNewModel> dataProducts;
  final String customImage;

  final bool loading;

  FlashSaleContainer(
      {this.colorAnimationController,
      this.textAnimationController,
      this.colorTween,
      this.titleColorTween,
      this.iconColorTween,
      this.moveTween,
      this.dataProducts,
      this.loading,
      this.customImage});

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.horizontal) {
      colorAnimationController.animateTo(scrollInfo.metrics.pixels / 150);
      textAnimationController.animateTo((scrollInfo.metrics.pixels - 350) / 50);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: scrollListener,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(
                0.8, 0.0), // 10% of the width, so there are ten blinds.
            colors: [primaryColor, tertiaryColor],
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        width: double.infinity,
        child: AnimatedBuilder(
          animation: colorAnimationController,
          builder: (context, child) => Stack(
            children: [
              Transform.translate(
                offset: moveTween.value,
                child: Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width / 3.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: customImage != null
                              ? NetworkImage(customImage)
                              : AssetImage("images/lobby/laptop.png"))),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colorTween.value,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: loading
                    ? customLoading(color: alternateColor)
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return i == 0
                              ? Container(
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width / 3.0,
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetail(
                                                  productId: dataProducts[i]
                                                      .id
                                                      .toString(),
                                                )));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  topLeft: Radius.circular(5)),
                                              color: Colors.transparent,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  dataProducts[i].images[0].src,
                                              placeholder: (context, url) =>
                                                  Container(height: 25,),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons
                                                    .image_not_supported_rounded,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    dataProducts[i].productName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsiveFont(10)),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: dataProducts[i]
                                                          .discProduct !=
                                                      0,
                                                  child: Flexible(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                secondaryColor,
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      7),
                                                          child: Text(
                                                            "${dataProducts[i].discProduct.round()}%",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    responsiveFont(
                                                                        9)),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          stringToCurrency(
                                                              dataProducts[i]
                                                                  .productRegPrice.toDouble(),
                                                              context),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  responsiveFont(
                                                                      8),
                                                              color: HexColor(
                                                                  "C4C4C4"),
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    stringToCurrency(
                                                        dataProducts[i]
                                                            .productPrice.toDouble(),
                                                        context),
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsiveFont(10),
                                                        color: secondaryColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                new LinearPercentIndicator(
                                                    padding: EdgeInsets.zero,
                                                    lineHeight: 5.0,
                                                    percent: dataProducts[i]
                                                                    .productStock !=
                                                                null &&
                                                            dataProducts[i]
                                                                    .productStock !=
                                                                0
                                                        ? 1
                                                        : 0,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    progressColor:
                                                        HexColor("00963C")),
                                                Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                    dataProducts[i].productStock !=
                                                                null &&
                                                            dataProducts[i]
                                                                    .productStock !=
                                                                0
                                                        ? "Stock Available"
                                                        : "Stock Empty",
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsiveFont(6)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 0,
                          );
                        },
                        itemCount: dataProducts.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
