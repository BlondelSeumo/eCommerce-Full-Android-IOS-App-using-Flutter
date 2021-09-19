import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/BlogModel.dart';
import 'package:nyoba/provider/BlogProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/share_link.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoba/widgets/blog/BlogDetailShimmer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../AppLocalizations.dart';

class BlogDetail extends StatefulWidget {
  final String id;
  final int index;
  final String slug;

  BlogDetail({Key key, this.id, this.index, this.slug}) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  TextEditingController commentController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  BlogModel blogModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  loadDetail() async {
    if (widget.slug == null) {
      await Provider.of<BlogProvider>(context, listen: false)
          .fetchBlogDetailById(widget.id)
          .then((value) {
        setState(() {
          blogModel = value;
        });
        loadComment(blogModel.id);
      });
    } else {
      await Provider.of<BlogProvider>(context, listen: false)
          .fetchBlogDetailBySlug(widget.slug)
          .then((value) {
        setState(() {
          blogModel = value;
        });
        loadComment(blogModel.id);
      });
    }
  }

  loadComment(postId) async {
    await Provider.of<BlogProvider>(context, listen: false)
        .fetchBlogComment(postId, true);
  }

  refresh() {
    loadDetail();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final blog = Provider.of<BlogProvider>(context, listen: false);
    Widget buildComments = Container(
      child: ListenableProvider.value(
        value: blog,
        child: Consumer<BlogProvider>(builder: (context, value, child) {
          if (value.loadingComment) {
            return customLoading();
          }
          return blog.blogComment != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        blog.blogComment != null
                            ? "${blog.blogComment.length} ${AppLocalizations.of(context).translate('comments')} :"
                            : "0 ${AppLocalizations.of(context).translate('comments')} :",
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView.separated(
                        primary: false,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: blog.blogComment.length,
                        itemBuilder: (context, i) {
                          return comment(blog.blogComment[i]);
                        })
                  ],
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: primaryColor,
                      ),
                      Text(AppLocalizations.of(context)
                          .translate('comment_empty'))
                    ],
                  ),
                );
        }),
      ),
    );

    var postComment = () async {
      if (commentController.text.isNotEmpty) {
        print('Start Commenting...');
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        final Future<Map<String, dynamic>> postResponse =
            blog.postComment(blogModel.id, comment: commentController.text);

        postResponse.then((value) {
          commentController.clear();
          if (value['data']['status'] == 200) {
            // UserModel user = UserModel.fromJson(value['user']);
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
            loadComment(blogModel.id);
            blog.blogs[widget.index].blogCommentaries = blog.blogComment;
          } else {
            snackBar(context, message: value['message'], color: Colors.red);
          }
        });
      } else {
        snackBar(context, message: 'Username & password should not empty');
      }
    };

    return ColorfulSafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Blog Detail"),
              backgroundColor: Colors.white,
              leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      shareLinks('blog', blogModel.link);
                    })
              ],
            ),
            body: blog.loadingDetail
                ? BlogDetailShimmer()
                : SmartRefresher(
                    controller: _refreshController,
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: CarouselSlider(
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                autoPlay: true,
                                viewportFraction: 1,
                                aspectRatio: 16 / 9,
                              ),
                              items: [
                                for (var i = 0;
                                    i < blogModel.blogImages.length;
                                    i++)
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: CachedNetworkImage(
                                      imageUrl: blogModel.blogImages[i].srcImg,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) =>
                                          customLoading(),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    blogModel.title,
                                    style: TextStyle(
                                        fontSize: responsiveFont(16),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: HexColor("c4c4c4")),
                                            ),
                                            child: ClipOval(
                                                child: Image.asset(
                                                    "images/lobby/laptop.png")),
                                          ),
                                          Container(
                                            width: 12,
                                          ),
                                          Text(
                                            blogModel.author,
                                            style: TextStyle(
                                                fontSize: responsiveFont(12),
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Text(
                                        convertDateFormatSlash(
                                            DateTime.parse(blogModel.date)),
                                        style: TextStyle(
                                            fontSize: responsiveFont(10)),
                                      )
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
                                    child: HtmlWidget(
                                      blogModel.content,
                                      textStyle: TextStyle(
                                          fontSize: responsiveFont(10)),
                                    )),
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
                                      Wrap(
                                        children: [
                                          for (var i = 0;
                                              i <
                                                  blogModel
                                                      .blogCategories.length;
                                              i++)
                                            Row(
                                              children: [
                                                tag(blogModel.blogCategories[i]
                                                    .categoryName),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  color: HexColor("c4c4c4"),
                                  height: 1,
                                  width: double.infinity,
                                ),
                                buildComments,
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('leave_comment'),
                                    style: TextStyle(
                                        fontSize: responsiveFont(12),
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: TextField(
                                            controller: commentController,
                                            maxLines: 5,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate('hint_comment'),
                                                hintStyle: TextStyle(
                                                    fontSize:
                                                        responsiveFont(12)),
                                                filled: true)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Visibility(
                                        visible: Session.data
                                                    .getBool('isLogin') ==
                                                null ||
                                            !Session.data.getBool('isLogin'),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                size: 48,
                                                color: primaryColor,
                                              ),
                                              Text(
                                                  "You must be logged in to post a comment.")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: Session.data
                                                      .getBool('isLogin') !=
                                                  null &&
                                              Session.data.getBool('isLogin'),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            width: double.infinity,
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: postComment,
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      secondaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 6)),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('comment'),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
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
