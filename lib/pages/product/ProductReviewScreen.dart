import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/ReviewModel.dart';
import 'package:nyoba/provider/ReviewProvider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReview extends StatefulWidget {
  final String productId;
  ProductReview({Key key, this.productId}) : super(key: key);

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int currentIndex = 0;

  int countAll = 0;
  int countOneStar = 0;
  int countTwoStar = 0;
  int countThreeStar = 0;
  int countFourStar = 0;
  int countFiveStar = 0;

  List<ReviewHistoryModel> listReview = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final review = Provider.of<ReviewProvider>(context, listen: false);
    await Provider.of<ReviewProvider>(context, listen: false)
        .fetchReviewProduct(widget.productId)
        .then((value) {
      setState(() {
        listReview = review.listReviewAllStar;

        countAll = review.listReviewAllStar.length;
        countOneStar = review.listReviewOneStar.length;
        countTwoStar = review.listReviewTwoStar.length;
        countThreeStar = review.listReviewThreeStar.length;
        countFourStar = review.listReviewFourStar.length;
        countFiveStar = review.listReviewFiveStar.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final review = Provider.of<ReviewProvider>(context, listen: false);
    Widget buildReview = Container(
      child: ListenableProvider.value(
        value: review,
        child: Consumer<ReviewProvider>(builder: (context, value, child) {
          if (value.isLoadingReview) {
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      commentShimmer(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        color: HexColor("EEEEEE"),
                        width: double.infinity,
                        height: 2,
                      ),
                    ],
                  );
                });
          }
          if (listReview.isEmpty){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: primaryColor,
                  ),
                  Text(AppLocalizations.of(context).translate('empty_review_product'),)
                ],
              ),
            );
          }
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: listReview.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    comment(
                        listReview[i].author,
                        listReview[i].content,
                        int.parse(listReview[i].star),
                        listReview[i].commentDate),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      color: HexColor("EEEEEE"),
                      width: double.infinity,
                      height: 2,
                    ),
                  ],
                );
              });
        }),
      ),
    );

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "All Reviews",
            style: TextStyle(
              fontSize: responsiveFont(14),
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              firstPart(),
              Container(
                color: HexColor("EEEEEE"),
                width: double.infinity,
                height: 5,
              ),
              buildReview
            ],
          ),
        ),
      ),
    );
  }

  Widget comment(String name, String comment, int starGoldItem, String date) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person),
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: responsiveFont(10),
                      fontWeight: FontWeight.w500),
                ),
                starGold(starGoldItem),
                comment.isEmpty
                    ? Container()
                    : HtmlWidget(
                        comment,
                        textStyle: TextStyle(color: HexColor("929292")),
                      ),
                /*item == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50.h,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Container(
                                height: 50.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                    color: HexColor("c4c4c4"),
                                    borderRadius: BorderRadius.circular(5)),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: 5,
                              );
                            },
                            itemCount: item),
                      ),*/
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    convertDateFormatShortMonth(DateTime.parse(date)),
                    style: TextStyle(fontSize: responsiveFont(8)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget firstPart() {
    final review = Provider.of<ReviewProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 5),
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
          if (currentIndex == 0) {
            setState(() {
              listReview = review.listReviewAllStar;
            });
          } else if (currentIndex == 1) {
            setState(() {
              listReview = review.listReviewFiveStar;
            });
          } else if (currentIndex == 2) {
            setState(() {
              listReview = review.listReviewFourStar;
            });
          } else if (currentIndex == 3) {
            setState(() {
              listReview = review.listReviewThreeStar;
            });
          } else if (currentIndex == 4) {
            setState(() {
              listReview = review.listReviewTwoStar;
            });
          } else if (currentIndex == 5) {
            setState(() {
              listReview = review.listReviewOneStar;
            });
          }
        },
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border.all(color: secondaryColor),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        tabs: [
          tabStyle(
              0,
              Text(
                "All",
                style: TextStyle(
                  fontSize: responsiveFont(12),
                  color: Colors.black,
                ),
              ),
              countAll),
          tabStyle(1, starGold(5), countFiveStar),
          tabStyle(2, starGold(4), countFourStar),
          tabStyle(3, starGold(3), countThreeStar),
          tabStyle(4, starGold(2), countTwoStar),
          tabStyle(5, starGold(1), countOneStar),
        ],
      ),
    );
  }

  Widget starGold(int starCount) {
    return Container(
      height: 20.h,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: starCount,
          itemBuilder: (context, i) {
            return Container(
                width: 15.w,
                height: 15.h,
                child: Image.asset("images/product_detail/starGold.png"));
          }),
    );
  }

  Widget tabStyle(int index, Widget title, int total) {
    return Container(
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.transparent : HexColor("eeeeee"),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title,
          Text("($total)",
              style: TextStyle(
                fontSize: responsiveFont(10),
                color: currentIndex == index ? primaryColor : Colors.black,
              ))
        ],
      ),
    );
  }

  Widget commentShimmer() {
    return Shimmer.fromColors(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 80,
                      color: Colors.white,
                    ),
                    starGold(5),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 10,
                      width: 120,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}
