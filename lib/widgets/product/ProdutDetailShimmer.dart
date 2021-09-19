import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/contact/ContactFAB.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailShimmer extends StatefulWidget {
  ProductDetailShimmer({Key key}) : super(key: key);

  @override
  _ProductDetailShimmerState createState() => _ProductDetailShimmerState();
}

class _ProductDetailShimmerState extends State<ProductDetailShimmer>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;

  int itemCount = 10;

  List<String> image = ["image1", "image2", "image3", "image4", "image5"];

  @override
  void initState() {
    super.initState();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 350) / 50);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
            floatingActionButton: ContactFAB(),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      appBar(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            firstPart(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              height: 5,
                              color: HexColor("EEEEEE"),
                            ),
                            secondPart(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              height: 5,
                              color: HexColor("EEEEEE"),
                            ),
                            thirdPart(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              height: 5,
                              color: HexColor("EEEEEE"),
                            ),
                            fourthPart("You Might Also Like"),
                            SizedBox(
                              height: 15,
                            ),
                            fourthPart("Featured Products"),
                            SizedBox(
                              height: 15,
                            ),
                            fourthPart("On Sale Now"),
                            SizedBox(
                              height: 70.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                appBar(),
              ],
            )));
  }

  Widget fourthPart(String title) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: responsiveFont(14), fontWeight: FontWeight.w600),
              ),
              Text(
                "More",
                style: TextStyle(
                    fontSize: responsiveFont(12),
                    fontWeight: FontWeight.w600,
                    color: secondaryColor),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3.0,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return itemList("Kemeja Polos Pria Biru Dongker Navy", "10%",
                    "Rp 888,500", "Rp 999,500", i);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 5,
                );
              },
              itemCount: itemCount),
        ),
      ],
    );
  }

  Widget thirdPart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review",
                    style: TextStyle(
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.h,
                        color: Colors.white,
                      ),
                      Text(
                        " 4.7 (297 Review)",
                        style: TextStyle(fontSize: responsiveFont(10)),
                      ),
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: null,
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: TextStyle(fontSize: responsiveFont(11)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: responsiveFont(20),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50.h,
            alignment: Alignment.center,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 8.w,
                  );
                },
                itemCount: image.length,
                itemBuilder: (context, i) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.white,
                      ),
                      i == image.length - 1
                          ? Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 6,
                              height: 70.h,
                              color: Colors.black54,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "+" + (image.length - 3).toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsiveFont(10),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Others",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsiveFont(10),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget secondPart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
                fontSize: responsiveFont(12), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
          ),
          Container(
            width: double.infinity,
            height: 8.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget firstPart() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 8,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: secondaryColor),
                child: Row(
                  children: [
                    Text(
                      "Save",
                      style: TextStyle(
                          fontSize: responsiveFont(8),
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      width: 100,
                      height: 8,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 100,
                height: 8,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 100,
            height: 8,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "Sold ",
                    style: TextStyle(
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    width: 50,
                    height: 8,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 11,
                width: 1,
                color: Colors.black,
              ),
              Container(
                width: 15.w,
                height: 15.h,
                color: Colors.white,
              ),
              Container(
                width: 100,
                height: 8,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Material(
      color: Colors.white,
      elevation: 5,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget itemList(
      String title, String discount, String price, String crossedPrice, int i) {
    return GestureDetector(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    color: alternateColor,
                  ),
                  child: Image.asset("images/lobby/laptop.png"),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: responsiveFont(10)),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Text(
                              price,
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

class ModalSheetAddCart extends StatefulWidget {
  ModalSheetAddCart({Key key}) : super(key: key);

  @override
  _ModalSheetAddCartState createState() => _ModalSheetAddCartState();
}

class _ModalSheetAddCartState extends State<ModalSheetAddCart> {
  int index = 0;
  int indexColor = 0;
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(
                  "Size",
                  style: TextStyle(fontSize: responsiveFont(12)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: sizeButton("M", 0)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: sizeButton("L", 1)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: sizeButton("XL", 2)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                        child: sizeButton("XXL", 3)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text(
                  "Color",
                  style: TextStyle(fontSize: responsiveFont(12)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 0;
                          });
                        },
                        child: colorButton("Green", 0)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 1;
                          });
                        },
                        child: colorButton("Red", 1)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 2;
                          });
                        },
                        child: colorButton("Blue", 2)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 3;
                          });
                        },
                        child: colorButton("Yellow", 3)),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: HexColor("c4c4c4"),
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Quantity",
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (counter > 1) {
                                  counter = counter - 1;
                                }
                              });
                            },
                            child: counter > 1
                                ? Image.asset("images/cart/minusDark.png")
                                : Image.asset("images/cart/minus.png"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(counter.toString()),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 16.w,
                          height: 16.h,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                counter = counter + 1;
                              });
                            },
                            child: Image.asset("images/cart/plus.png"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                  )
                ],
              ),
              height: 45.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: 132.w,
                height: 30.h,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: secondaryColor, //Color of the border
                          //Style of the border
                        ),
                        alignment: Alignment.center,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5))),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => ModalSheetAddCart(),
                      );
                    },
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorButton(String color, int indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: indexColor == indexes ? Colors.transparent : secondaryColor),
        borderRadius: BorderRadius.circular(5),
        color: indexColor == indexes ? primaryColor : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        color,
        style: TextStyle(
            color: indexColor == indexes ? Colors.white : primaryColor),
      ),
    );
  }

  Widget sizeButton(String size, int indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: indexes == index ? Colors.transparent : secondaryColor),
        borderRadius: BorderRadius.circular(5),
        color: indexes == index ? primaryColor : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        size,
        style: TextStyle(color: indexes == index ? Colors.white : primaryColor),
      ),
    );
  }
}

class ModalSheetBuy extends StatefulWidget {
  ModalSheetBuy({Key key}) : super(key: key);

  @override
  _ModalSheetBuyState createState() => _ModalSheetBuyState();
}

class _ModalSheetBuyState extends State<ModalSheetBuy> {
  int index = 0;
  int indexColor = 0;
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(
                  "Size",
                  style: TextStyle(fontSize: responsiveFont(12)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: sizeButton("M", 0)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: sizeButton("L", 1)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: sizeButton("XL", 2)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                        child: sizeButton("XXL", 3)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text(
                  "Color",
                  style: TextStyle(fontSize: responsiveFont(12)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 0;
                          });
                        },
                        child: colorButton("Green", 0)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 1;
                          });
                        },
                        child: colorButton("Red", 1)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 2;
                          });
                        },
                        child: colorButton("Blue", 2)),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            indexColor = 3;
                          });
                        },
                        child: colorButton("Yellow", 3)),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: HexColor("c4c4c4"),
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Quantity",
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (counter > 1) {
                                  counter = counter - 1;
                                }
                              });
                            },
                            child: counter > 1
                                ? Image.asset("images/cart/minusDark.png")
                                : Image.asset("images/cart/minus.png"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(counter.toString()),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 16.w,
                          height: 16.h,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                counter = counter + 1;
                              });
                            },
                            child: Image.asset("images/cart/plus.png"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                  )
                ],
              ),
              height: 45.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryColor, secondaryColor])),
                width: double.infinity,
                height: 30.h,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                        color: Colors.white, fontSize: responsiveFont(10)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorButton(String color, int indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: indexColor == indexes ? Colors.transparent : secondaryColor),
        borderRadius: BorderRadius.circular(5),
        color: indexColor == indexes ? primaryColor : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        color,
        style: TextStyle(
            color: indexColor == indexes ? Colors.white : primaryColor),
      ),
    );
  }

  Widget sizeButton(String size, int indexes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: indexes == index ? Colors.transparent : secondaryColor),
        borderRadius: BorderRadius.circular(5),
        color: indexes == index ? primaryColor : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        size,
        style: TextStyle(color: indexes == index ? Colors.white : primaryColor),
      ),
    );
  }
}
