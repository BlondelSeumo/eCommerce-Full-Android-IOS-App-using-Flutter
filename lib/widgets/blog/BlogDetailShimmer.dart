import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/BlogModel.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BlogDetailShimmer extends StatefulWidget {
  final String id;
  final int index;
  final String slug;

  BlogDetailShimmer({Key key, this.id, this.index, this.slug})
      : super(key: key);

  @override
  _BlogDetailShimmerState createState() => _BlogDetailShimmerState();
}

class _BlogDetailShimmerState extends State<BlogDetailShimmer> {
  TextEditingController commentController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1,
                autoPlay: true,
                height: 250),
            items: [
              Shimmer.fromColors(
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.white,
                          );
                        }),
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100])
            ],
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: Shimmer.fromColors(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: HexColor("c4c4c4")),
                                  ),
                                  child: ClipOval(
                                      child: Image.asset(
                                          "images/lobby/laptop.png")),
                                ),
                                Container(
                                  width: 12,
                                ),
                                Container(
                                  height: 12,
                                  width: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                              width: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 10,
                        width: double.infinity,
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 10,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 10,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        height: 10,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: Container(
                                    child: Icon(
                                  Icons.local_offer,
                                  color: secondaryColor,
                                ))),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        color: HexColor("c4c4c4"),
                        height: 1,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100]))
        ],
      ),
    );
  }

  Widget comment(BlogCommentModel blogComment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: HexColor("c4c4c4")),
            ),
            child: ClipOval(child: Image.asset("images/lobby/laptop.png")),
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blogComment.authorName,
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      convertDateFormatFull(DateTime.parse(blogComment.date)),
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w400,
                          color: primaryColor),
                    )
                  ],
                ),
                Container(
                  height: 5,
                ),
                HtmlWidget(
                  blogComment.content,
                  textStyle: TextStyle(fontSize: responsiveFont(8)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget tag(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: secondaryColor)),
      child: Text(
        title,
        style: TextStyle(color: primaryColor),
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
                  IconButton(icon: Icon(Icons.share), onPressed: () {}),
                ],
              ))),
    );
  }
}
