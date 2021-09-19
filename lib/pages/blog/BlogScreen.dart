import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/pages/product/AllProductsScreen.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/pages/product/featured_products/AllFeaturedProductsScreen.dart';
import 'package:nyoba/provider/BannerProvider.dart';
import 'package:nyoba/provider/BlogProvider.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/widgets/blog/BlogGridItem.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../AppLocalizations.dart';
import '../../models/BlogModel.dart';
import '../../provider/FlashSaleProvider.dart';
import '../../utils/utility.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/home/CardItemSmall.dart';

class BlogScreen extends StatefulWidget {
  BlogScreen({Key key}) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  int page = 1;

  TextEditingController searchController = new TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isLoaded = false;

  var blogs;
  @override
  void initState() {
    super.initState();
    final blogs = Provider.of<BlogProvider>(context, listen: false);
    //check provider is list blog empty for first load
    if (blogs.blogs.isEmpty) {
      page = 1;
      load();
    }
    //save state for current search & current page
    searchController.text = blogs.searchBlogs;
    page = blogs.currentPage;
  }

  //init data blog
  load() async {
    await Provider.of<BlogProvider>(context, listen: false).fetchBlogs(
        page: page, search: searchController.text, loadingList: true);
  }

  refreshData() async {
    setState(() {
      page = 1;
      searchController.clear();
    });
    await Provider.of<BlogProvider>(context, listen: false)
        .fetchBlogs(
            page: page, search: searchController.text, loadingList: true)
        .then((value) {
      this.setState(() {});
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    //build data for list blog from provider value
    final blogs = Provider.of<BlogProvider>(context, listen: false);
    Widget buildBlogs = Container(
      child: ListenableProvider.value(
        value: blogs,
        child: Consumer<BlogProvider>(builder: (context, value, child) {
          return mainPart(value.blogs, value.loading);
        }),
      ),
    );

    return ColorfulSafeArea(
        child: Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(),
              buildBlogs,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: HexColor("eaeaea"),
                height: 5,
                width: double.infinity,
              ),
              secondPart()
            ],
          ),
        ),
      ),
    ));
  }

  Widget secondPart() {
    return Column(
      children: [
        Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadingFeatured) {
            return customLoading();
          }
          return Visibility(
              visible: value.listFeaturedProduct.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Featured Products",
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllFeaturedProducts()));
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('more'),
                            style: TextStyle(
                                fontSize: responsiveFont(12),
                                fontWeight: FontWeight.w600,
                                color: secondaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.separated(
                        itemCount: value.listFeaturedProduct.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return CardItem(
                            product: value.listFeaturedProduct[i],
                            i: i,
                            itemCount: value.listFeaturedProduct.length,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5,
                          );
                        },
                      ))
                ],
              ));
        }),
        Container(
          height: 24,
        ),
        Consumer<FlashSaleProvider>(builder: (context, value, child) {
          return Visibility(
              visible: value.flashSaleProducts.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ON SALE NOW",
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllProductsScreen(
                                          listProduct: value.flashSaleProducts,
                                        )));
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('more'),
                            style: TextStyle(
                                fontSize: responsiveFont(12),
                                fontWeight: FontWeight.w600,
                                color: secondaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.separated(
                        itemCount: value.flashSaleProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return CardItem(
                            product: value.flashSaleProducts[i],
                            i: i,
                            itemCount: value.flashSaleProducts.length,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5,
                          );
                        },
                      ))
                ],
              ));
        }),
      ],
    );
  }

  Widget appBar() {
    return Material(
      elevation: 5,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(),
          child: Container(
              height: 70,
              padding:
                  EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontSize: 14),
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        setState(() {
                          page = 1;
                        });
                        load();
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                        hintText:
                            AppLocalizations.of(context).translate('search'),
                        hintStyle: TextStyle(fontSize: responsiveFont(10)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                        });
                        load();
                      },
                      icon: Icon(Icons.cancel),
                      color: primaryColor,
                    ),
                  )
                ],
              ))),
    );
  }

  Widget headerBlog() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).translate('lets'),
            style: TextStyle(color: primaryColor, fontSize: responsiveFont(14)),
          ),
          Text(
            AppLocalizations.of(context).translate('head_blog'),
            style: TextStyle(
                color: secondaryColor,
                fontSize: responsiveFont(14),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          //Banner Item start Here
          Consumer<BannerProvider>(builder: (context, value, child) {
            if (value.loadingBlog) {
              return Container(
                width: 330.w,
                height: 165.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Colors.grey,
                ),
              );
            } else {
              return Container(
                width: 330.w,
                height: 165.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                child: value.bannerBlog.image != null
                    ? InkWell(
                        onTap: value.bannerBlog.product != null
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                              productId: value
                                                  .bannerBlog.product
                                                  .toString(),
                                            )));
                              }
                            : null,
                        child: CachedNetworkImage(
                          imageUrl: value.bannerBlog.image,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                      ),
              );
            }
          }),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget footerBlog(bool loading, int countBlog) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: loading || page == 1
                      ? null
                      : () {
                          setState(() {
                            page--;
                          });
                          load();
                        },
                  style: TextButton.styleFrom(
                      backgroundColor: loading || page == 1
                          ? HexColor("c4c4c4")
                          : secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 7)),
                  child: Text(
                    AppLocalizations.of(context).translate('previous'),
                    style: TextStyle(
                        fontSize: responsiveFont(10), color: Colors.white),
                  )),
              TextButton(
                  onPressed: loading || countBlog < 6
                      ? null
                      : () {
                          setState(() {
                            page++;
                          });
                          load();
                        },
                  style: TextButton.styleFrom(
                      backgroundColor: loading || countBlog < 6
                          ? HexColor("c4c4c4")
                          : secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 7)),
                  child: Text(
                    AppLocalizations.of(context).translate('next'),
                    style: TextStyle(
                        fontSize: responsiveFont(10), color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget mainPart(List<BlogModel> listBlogs, bool loading) {
    return Container(
      margin: EdgeInsets.only(right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerBlog(),
          loading
              ? customLoading()
              : listBlogs.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: primaryColor,
                          ),
                          Text(AppLocalizations.of(context)
                              .translate('blog_empty'))
                        ],
                      ),
                    )
                  : GridView.builder(
                      primary: false,
                      itemCount: listBlogs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 5),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return BlogGridItem(
                          blog: listBlogs[i],
                          index: i,
                        );
                      },
                    ),
          footerBlog(loading, listBlogs.length)
        ],
      ),
    );
  }
}
