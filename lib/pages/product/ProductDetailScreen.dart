import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/pages/category/BrandProduct.dart';
import 'package:nyoba/pages/order/CartScreen.dart';
import 'package:nyoba/pages/order/OrderSuccessScreen.dart';
import 'package:nyoba/pages/product/ProductMoreScreen.dart';
import 'package:nyoba/pages/wishlist/WishlistScreen.dart';
import 'package:nyoba/provider/FlashSaleProvider.dart';
import 'package:nyoba/provider/OrderProvider.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/provider/ReviewProvider.dart';
import 'package:nyoba/provider/WishlistProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/utils/share_link.dart';
import 'package:nyoba/widgets/contact/ContactFAB.dart';
import 'package:nyoba/widgets/home/CardItemShimmer.dart';
import 'package:nyoba/widgets/home/CardItemSmall.dart';
import 'package:nyoba/widgets/product/ProductPhotoView.dart';
import 'package:nyoba/widgets/product/ProdutDetailShimmer.dart';
import 'package:nyoba/widgets/youtube/YoutubePlayer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../AppLocalizations.dart';
import '../../models/ProductModel.dart';
import '../../utils/utility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ProductReviewScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:like_button/like_button.dart';

import 'featured_products/AllFeaturedProductsScreen.dart';

class ProductDetail extends StatefulWidget {
  final String productId;
  final String slug;
  ProductDetail({Key key, this.productId, this.slug}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;

  int itemCount = 10;

  List<String> image = ["image1", "image2", "image3", "image4", "image5"];

  bool isWishlist = false;

  int cartCount = 0;
  TextEditingController reviewController = new TextEditingController();

  double rating = 0;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isFlashSale = false;

  ProductModel productModel;
  final CarouselController _controller = CarouselController();
  int _current = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    loadDetail();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  Future loadDetail() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    loadCartCount();
    if (widget.slug == null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProductDetail(widget.productId)
          .then((value) async {
        setState(() {
          productModel = value;
          printLog(productModel.toString(), name: 'Product Model');
          productModel.isSelected = false;
          productProvider.loadingDetail = false;
        });
        secondLoad();
        if (Session.data.getBool('isLogin'))
          await productProvider.hitViewProducts(widget.productId).then(
              (value) async => await productProvider.fetchRecentProducts());
      });
    } else {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProductDetailSlug(widget.slug)
          .then((value) {
        setState(() {
          productModel = value;
          productModel.isSelected = false;
          productProvider.loadingDetail = false;
          printLog(productModel.toString(), name: 'Product Model');
        });
        secondLoad();
      });
    }
  }

  secondLoad() {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);

    checkFlashSale();

    if (Session.data.getBool('isLogin')) {
      final Future<Map<String, dynamic>> checkWishlist =
          wishlist.checkWishlistProduct(productId: productModel.id.toString());

      checkWishlist.then((value) {
        printLog('Cek Wishlist Success');
        setState(() {
          isWishlist = value['message'];
        });
      });
    }
    loadReviewProduct();
  }

  Future<bool> setWishlist(bool isLiked) async {
    if (Session.data.getBool('isLogin')) {
      setState(() {
        isWishlist = !isWishlist;
        isLiked = isWishlist;
      });
      final wishlist = Provider.of<WishlistProvider>(context, listen: false);

      final Future<Map<String, dynamic>> setWishlist = wishlist
          .setWishlistProduct(context, productId: productModel.id.toString());

      setWishlist.then((value) {
        print("200");
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WishList()));
    }
    return isLiked;
  }

  Future<dynamic> loadCartCount() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      setState(() {
        cartCount = value;
      });
    });
  }

  loadReviewProduct() async {
    await Provider.of<ReviewProvider>(context, listen: false)
        .fetchReviewProductLimit(productModel.id.toString())
        .then((value) => loadLikeProduct());
  }

  loadLikeProduct() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchCategoryProduct(productModel.categories[0].id.toString());
  }

  checkFlashSale() {
    final flashsale = Provider.of<FlashSaleProvider>(context, listen: false);
    if (flashsale.flashSales != null && flashsale.flashSales.isNotEmpty) {
      setState(() {
        endTime = DateTime.parse(flashsale.flashSales[0].endDate)
            .millisecondsSinceEpoch;
      });
    }

    if (flashsale.flashSaleProducts.isNotEmpty) {
      flashsale.flashSaleProducts.forEach((element) {
        if (productModel.id.toString() == element.id.toString()) {
          setState(() {
            isFlashSale = true;
          });
        }
      });
    }
  }

  refresh() async {
    this.setState(() {});
    await loadDetail().then((value) {
      this.setState(() {});
      _refreshController.refreshCompleted();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildWishlistBtn = LikeButton(
      size: 25,
      onTap: setWishlist,
      circleColor: CircleColor(start: primaryColor, end: secondaryColor),
      bubblesColor: BubblesColor(
        dotPrimaryColor: primaryColor,
        dotSecondaryColor: secondaryColor,
      ),
      isLiked: isWishlist,
      likeBuilder: (bool isLiked) {
        if (!isLiked) {
          return Icon(
            Icons.favorite_border,
            color: Colors.grey,
            size: 25,
          );
        }
        return Icon(
          Icons.favorite,
          color: Colors.red,
          size: 25,
        );
      },
    );

    return ListenableProvider.value(
      value: product,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        if (value.loadingDetail) {
          return ProductDetailShimmer();
        }
        List<Widget> itemSlider = [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPhotoView(
                            image: productModel.images[0].src,
                          )));
            },
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: CachedNetworkImage(
                imageUrl: productModel.images[0].src,
                placeholder: (context, url) => customLoading(),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported_rounded,
                  size: 25,
                ),
              ),
            ),
          ),
          for (var i = 0; i < productModel.videos.length; i++)
            Container(
              child: YoutubePlayerWidget(
                url: productModel.videos[i].content,
              ),
            ),
          for (var i = 1; i < productModel.images.length; i++)
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductPhotoView(
                                image: productModel.images[i].src,
                              )));
                },
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: CachedNetworkImage(
                    imageUrl: productModel.images[i].src,
                    placeholder: (context, url) => customLoading(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_rounded,
                      size: 25,
                    ),
                  ),
                ))
        ];
        return ColorfulSafeArea(
          color: Colors.white,
          child: Scaffold(
            floatingActionButton: ContactFAB(),
            appBar: appBar(productModel),
            body: Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                  aspectRatio: 1 / 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              carouselController: _controller,
                              items: itemSlider,
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    itemSlider.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == entry.key
                                              ? primaryColor
                                              : primaryColor.withOpacity(0.5),
                                        )),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: isFlashSale,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "images/product_detail/bg_flashsale.png"))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "FLASH SALE ENDS IN :",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                      Text(
                                          "${productModel.totalSales} Item Sold",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10)),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    child: CountdownTimer(
                                      endTime: endTime,
                                      widgetBuilder:
                                          (_, CurrentRemainingTime time) {
                                        int hours = time.hours;
                                        if (time.days != null &&
                                            time.days != 0) {
                                          hours = (time.days * 24) + time.hours;
                                        }
                                        if (time == null) {
                                          return Text('Flash Sale Selesai');
                                        }
                                        return Container(
                                          height: 30.h,
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 35.w,
                                                height: 30.h,
                                                child: Text(
                                                  hours < 10
                                                      ? "0$hours"
                                                      : "$hours",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 30.w,
                                                height: 30.h,
                                                child: Text(
                                                  time.min < 10
                                                      ? "0${time.min}"
                                                      : "${time.min}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 30.w,
                                                height: 30.h,
                                                child: Text(
                                                  time.sec < 10
                                                      ? "0${time.sec}"
                                                      : "${time.sec}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          responsiveFont(12)),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ))
                              ],
                            ),
                          ),
                        ),
                        firstPart(productModel, buildWishlistBtn),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 5,
                          color: HexColor("EEEEEE"),
                        ),
                        secondPart(productModel),
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
                        commentPart(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 5,
                          color: HexColor("EEEEEE"),
                        ),
                        sameCategoryProduct(),
                        SizedBox(
                          height: 15,
                        ),
                        featuredProduct(),
                        SizedBox(
                          height: 15,
                        ),
                        onSaleProduct(),
                        SizedBox(
                          height: 70.h,
                        ),
                      ],
                    ),
                  ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150.w,
                          height: 30.h,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: secondaryColor, //Color of the border
                                    //Style of the border
                                  ),
                                  alignment: Alignment.center,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5))),
                              onPressed: () {
                                if (productModel.stockStatus == 'instock') {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => ModalSheetCart(
                                      product: productModel,
                                      type: 'add',
                                      loadCount: loadCartCount,
                                    ),
                                  );
                                } else {
                                  snackBar(context,
                                      message:
                                          "Product currently is out of stock");
                                }
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
                                    AppLocalizations.of(context)
                                        .translate('add_to_cart'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: responsiveFont(9),
                                        color: secondaryColor),
                                  )
                                ],
                              )),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [primaryColor, secondaryColor])),
                          width: 132.w,
                          height: 30.h,
                          child: TextButton(
                            onPressed: () {
                              if (productModel.stockStatus == 'instock') {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => ModalSheetCart(
                                    product: productModel,
                                    type: 'buy',
                                  ),
                                );
                              } else {
                                snackBar(context,
                                    message:
                                        "Product currently is out of stock");
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('buy_now'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveFont(10)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget sameCategoryProduct() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    return ListenableProvider.value(
        value: product,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadingCategory) {
            return Container(
                height: MediaQuery.of(context).size.height / 3.2,
                child: ListView.separated(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return CardItemShimmer(
                      i: i,
                      itemCount: 4,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 5,
                    );
                  },
                ));
          }
          return Visibility(
              visible: value.listCategoryProduct.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('you_might_also'),
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BrandProducts(
                                          categoryId: product
                                              .productDetail.categories[0].id
                                              .toString(),
                                          brandName:
                                              AppLocalizations.of(context)
                                                  .translate('you_might_also'),
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
                        itemCount: value.listCategoryProduct.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return CardItem(
                            product: value.listCategoryProduct[i],
                            i: i,
                            itemCount: value.listCategoryProduct.length,
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
        }));
  }

  Widget featuredProduct() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
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
                                builder: (context) => AllFeaturedProducts()));
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
    });
  }

  Widget onSaleProduct() {
    return Consumer<FlashSaleProvider>(builder: (context, value, child) {
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductMoreScreen(
                                      include: value.flashSales[0].products,
                                      name: 'ON SALE NOW',
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
    });
  }

  Widget thirdPart() {
    final review = Provider.of<ReviewProvider>(context, listen: false);
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildReview = Container(
      child: ListenableProvider.value(
        value: review,
        child: Consumer<ReviewProvider>(builder: (context, value, child) {
          if (value.isLoadingReview) {
            return Container();
          }
          if (value.listReviewLimit.isEmpty) {
            return Text(
              AppLocalizations.of(context).translate('empty_review_product'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBar(
                    initialRating: double.parse(value.listReviewLimit[0].star),
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 15,
                    onRatingUpdate: null,
                    ratingWidget: RatingWidget(
                        empty: Icon(
                          Icons.star,
                          color: Colors.grey,
                        ),
                        full: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: null),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "by ",
                    style: TextStyle(
                        color: HexColor("929292"), fontSize: responsiveFont(9)),
                  ),
                  Text(
                    value.listReviewLimit[0].author,
                    style: TextStyle(fontSize: responsiveFont(9)),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value.listReviewLimit[0].content,
                style: TextStyle(
                    color: HexColor("464646"),
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
            ],
          );
        }),
      ),
    );

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
                    AppLocalizations.of(context).translate('review'),
                    style: TextStyle(
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Container(
                          width: 15.w,
                          height: 15.h,
                          child: Image.asset(
                              "images/product_detail/starGold.png")),
                      Text(
                        " ${product.productDetail.avgRating} (${product.productDetail.ratingCount} ${AppLocalizations.of(context).translate('review')})",
                        style: TextStyle(fontSize: responsiveFont(10)),
                      ),
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductReview(
                                productId: productModel.id.toString(),
                              )));
                },
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('see_all'),
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
          SizedBox(
            height: 10,
          ),
          buildReview
        ],
      ),
    );
  }

  Widget commentPart() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildBtnReview = Container(
      child: ListenableProvider.value(
        value: product,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadAddReview) {
            return InkWell(
              onTap: null,
              child: Container(
                width: 80,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), color: Colors.grey),
                alignment: Alignment.center,
                child: customLoading(),
              ),
            );
          }
          return InkWell(
            onTap: () async {
              if (rating != 0 && reviewController.text.isNotEmpty) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                await Provider.of<ProductProvider>(context, listen: false)
                    .addReview(context,
                        productId: productModel.id,
                        rating: rating,
                        review: reviewController.text)
                    .then((value) {
                  setState(() {
                    reviewController.clear();
                    rating = 0;
                  });
                  loadReviewProduct();
                });
              } else {
                snackBar(context,
                    message: 'You must set the rating and review first');
              }
            },
            child: Container(
              width: 80,
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: rating != 0 && reviewController.text.isNotEmpty
                      ? secondaryColor
                      : Colors.grey),
              alignment: Alignment.center,
              child: Text(
                "Submit",
                style: TextStyle(
                    fontSize: responsiveFont(10),
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).translate('add_review'),
            style: TextStyle(
                fontSize: responsiveFont(12), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).translate('comment'),
            style: TextStyle(
                fontSize: responsiveFont(10), fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: reviewController,
            maxLines: 2,
            style: TextStyle(
              fontSize: 10,
            ),
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              hintText: AppLocalizations.of(context).translate('hint_review'),
              hintStyle: TextStyle(fontSize: 10, color: HexColor('9e9e9e')),
            ),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              print(value);
              setState(() {
                rating = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          buildBtnReview
        ],
      ),
    );
  }

  Widget secondPart(ProductModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).translate('description'),
            style: TextStyle(
                fontSize: responsiveFont(12), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          HtmlWidget(
            model.productDescription,
            textStyle: TextStyle(color: HexColor("929292")),
          ),
        ],
      ),
    );
  }

  Widget firstPart(ProductModel model, Widget btnFav) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stringToCurrency(double.parse(model.productPrice), context),
                  style: TextStyle(
                      fontSize: responsiveFont(14),
                      fontWeight: FontWeight.w500)),
              btnFav
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Visibility(
            visible: model.discProduct != 0,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: secondaryColor),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('save_product'),
                        style: TextStyle(
                            fontSize: responsiveFont(8),
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "${model.discProduct.round()}%",
                        style: TextStyle(
                            fontSize: responsiveFont(8), color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  stringToCurrency(
                      double.parse(model.productRegPrice), context),
                  style: TextStyle(
                      fontSize: responsiveFont(11),
                      decoration: TextDecoration.lineThrough,
                      color: HexColor("c4c4c4")),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            model.productName,
            style: TextStyle(fontSize: responsiveFont(11)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "${AppLocalizations.of(context).translate('sold')} ",
                    style: TextStyle(
                        fontSize: responsiveFont(10),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${model.totalSales}",
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
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
                  child: Image.asset("images/product_detail/starGold.png")),
              Text(
                " ${model.avgRating} (${model.ratingCount})",
                style: TextStyle(fontSize: responsiveFont(10)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            model.stockStatus == 'instock' ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
                fontSize: responsiveFont(11),
                fontWeight: FontWeight.bold,
                color:
                    model.stockStatus == 'instock' ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }

  Widget appBar(ProductModel model) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Text(
        model.productName ?? "",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: responsiveFont(14)),
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(
                          isFromHome: false,
                        )));
          },
          child: Container(
            width: 65,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                Positioned(
                  right: 0,
                  top: 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    alignment: Alignment.center,
                    child: Text(
                      cartCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveFont(9),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            shareLinks('product', model.link);
          },
          child: Container(
            margin: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.share,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Widget itemList(
      String title, String discount, String price, String crossedPrice, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductDetail()));
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

class ModalSheetCart extends StatefulWidget {
  final ProductModel product;
  final String type;
  final Future<dynamic> Function() loadCount;
  ModalSheetCart({Key key, this.product, this.type, this.loadCount})
      : super(key: key);

  @override
  _ModalSheetCartState createState() => _ModalSheetCartState();
}

class _ModalSheetCartState extends State<ModalSheetCart> {
  int index = 0;
  int indexColor = 0;
  int counter = 1;

  List<ProductAttributeModel> attributes = [];
  List<ProductVariation> variation = [];

  bool load = false;

  /*add to cart*/
  void addCart(ProductModel product) async {
    print('Add Cart');
    ProductModel productCart = product;

    /*check sharedprefs for cart*/
    if (!Session.data.containsKey('cart')) {
      List<ProductModel> listCart = [];
      productCart.priceTotal =
          (productCart.cartQuantity * double.parse(productCart.productPrice));

      listCart.add(productCart);

      await Session.data.setString('cart', json.encode(listCart));
      List products = await json.decode(Session.data.getString('cart'));
      printLog(products.toString(), name: "Cart Product");
    } else {
      List products = await json.decode(Session.data.getString('cart'));
      printLog(products.toString(), name: "Cart Product");

      List<ProductModel> listCart = products
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      int index = products.indexWhere((prod) =>
          prod["id"] == productCart.id &&
          prod["variant_id"] == productCart.variantId);

      if (index != -1) {
        productCart.cartQuantity =
            listCart[index].cartQuantity + productCart.cartQuantity;

        productCart.priceTotal =
            (productCart.cartQuantity * double.parse(productCart.productPrice));

        listCart[index] = productCart;

        await Session.data.setString('cart', json.encode(listCart));
      } else {
        productCart.priceTotal =
            (productCart.cartQuantity * double.parse(productCart.productPrice));
        listCart.add(productCart);
        await Session.data.setString('cart', json.encode(listCart));
        printLog(products.toString(), name: "Cart Product");
      }
    }
    widget.loadCount();
    Navigator.pop(context);
    snackBar(context, message: "Product successfully added to your cart.");
  }

  /*get variant id, if product have variant*/
  checkProductVariant(ProductModel productModel) async {
    setState(() {
      load = true;
    });
    final product = Provider.of<ProductProvider>(context, listen: false);
    final Future<Map<String, dynamic>> productResponse =
        product.checkVariation(productId: productModel.id, list: variation);

    productResponse.then((value) {
      if (value['status'] == 'success') {
        printLog(value.toString(), name: 'Variation');
        setState(() {
          productModel.variantId = value['variation_id'];
          load = false;
        });
      } else {
        snackBar(context,
            message: value['status'].toString().toUpperCase(),
            color: Colors.red);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.product.cartQuantity = 1;
    initVariation();
  }

  /*init variation & check if variation true*/
  initVariation() {
    if (widget.product.attributes.isNotEmpty) {
      widget.product.attributes.forEach((element) {
        if (element.variation == true) {
          print("Variation True");
          setState(() {
            attributes.add(element);
            element.selectedVariant = element.options.first;
            variation.add(new ProductVariation(
                value: element.options.first, columnName: element.name));
          });
        }
      });
      checkProductVariant(widget.product);
    }
  }

  Future onFinishBuyNow() async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OrderSuccess()));
  }

  buyNow() async {
    print("Buy Now");
    await Provider.of<OrderProvider>(context, listen: false)
        .buyNow(context, widget.product, onFinishBuyNow);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: attributes.isNotEmpty,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: attributes.length,
                    itemBuilder: (context, i) {
                      return buildVariations(i);
                    })),
            Container(
              height: 1,
              width: double.infinity,
              color: HexColor("c4c4c4"),
              margin: EdgeInsets.only(bottom: 15),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                              if (widget.product.cartQuantity > 1) {
                                widget.product.cartQuantity =
                                    widget.product.cartQuantity - 1;
                              }
                            });
                          },
                          child: widget.product.cartQuantity > 1
                              ? Image.asset("images/cart/minusDark.png")
                              : Image.asset("images/cart/minus.png"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text((widget.product.cartQuantity).toString()),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 16.w,
                        height: 16.h,
                        child: InkWell(
                            onTap: widget.product.productStock <=
                                    widget.product.cartQuantity
                                ? null
                                : () {
                                    setState(() {
                                      widget.product.cartQuantity =
                                          widget.product.cartQuantity + 1;
                                    });
                                  },
                            child: widget.product.productStock >
                                    widget.product.cartQuantity
                                ? Image.asset("images/cart/plus.png")
                                : Image.asset("images/cart/plusDark.png")),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.product.productStock == null ||
                  widget.product.productStock == 0,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Current product stock is not available",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: widget.type == 'add',
          child: Align(
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
                          color: load
                              ? Colors.grey
                              : secondaryColor, //Color of the border
                          //Style of the border
                        ),
                        alignment: Alignment.center,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5))),
                    onPressed: load
                        ? null
                        : () {
                            if (widget.product.productStock != null &&
                                widget.product.productStock != 0) {
                              addCart(widget.product);
                            } else {
                              Navigator.pop(context);
                              snackBar(context,
                                  message: 'Product out ouf stock.');
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: responsiveFont(9),
                          color: load ? Colors.grey : secondaryColor,
                        ),
                        Text(
                          "Add to Cart",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveFont(9),
                              color: load ? Colors.grey : secondaryColor),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.type == 'buy',
          child: Align(
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
                  onPressed: () {
                    buyNow();
                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                        color: Colors.white, fontSize: responsiveFont(10)),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildVariations(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Text(
            attributes[index].name,
            style: TextStyle(fontSize: responsiveFont(12)),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: attributes[index].options.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            attributes[index].selectedVariant =
                                attributes[index].options[i];
                          });
                          variation.forEach((element) {
                            if (element.columnName == attributes[index].name) {
                              setState(() {
                                element.value = attributes[index].options[i];
                              });
                            }
                          });
                          checkProductVariant(widget.product);
                        },
                        child:
                            sizeButton(attributes[index].options[i], index, i)),
                    Container(
                      width: 10,
                    ),
                  ],
                );
              }),
        )
      ],
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

  Widget sizeButton(String variant, int groupVariant, int subVariant) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.product.attributes[groupVariant].selectedVariant ==
                    widget.product.attributes[groupVariant].options[subVariant]
                ? Colors.transparent
                : secondaryColor),
        borderRadius: BorderRadius.circular(5),
        color: widget.product.attributes[groupVariant].selectedVariant ==
                widget.product.attributes[groupVariant].options[subVariant]
            ? primaryColor
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        variant,
        style: TextStyle(
            color: widget.product.attributes[groupVariant].selectedVariant ==
                    widget.product.attributes[groupVariant].options[subVariant]
                ? Colors.white
                : primaryColor),
      ),
    );
  }
}
