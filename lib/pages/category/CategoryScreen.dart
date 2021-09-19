import 'package:flutter/material.dart';
import 'package:nyoba/pages/category/BrandProduct.dart';
import 'package:nyoba/pages/search/SearchScreen.dart';
import 'package:nyoba/provider/CategoryProvider.dart';
import 'package:nyoba/widgets/home/categories/GridItemCategory.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryScreen extends StatefulWidget {
  final bool isFromHome;
  CategoryScreen({Key key, this.isFromHome}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  int chosenindex = 0;
  int chosenCountSub = 0;

  String categoryName;

  List<int> indexTab = [0, 1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    final categories = Provider.of<CategoryProvider>(context, listen: false);
    if (categories.allCategories.isEmpty) {
      loadAllCategories();
    }
    if (categories.currentSelectedCategory != null) {
      setState(() {
        chosenindex = categories.currentSelectedCategory;
        chosenCountSub = categories.currentSelectedCountSub;
      });
      print(chosenCountSub);
    }
  }

  loadAllCategories() async {
    final categories = Provider.of<CategoryProvider>(context, listen: false);
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchAllCategories()
        .then((value) => loadPopularCategories())
        .then((value) {
      setState(() {
        chosenindex = categories.allCategories[0].id;
        chosenCountSub = categories.allCategories[0].count;
        categoryName = categories.allCategories[0].title;
        categories.currentSelectedCategory = chosenindex;
        categories.currentSelectedCountSub = chosenCountSub;
      });
    });
  }

  loadPopularCategories() async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchPopularCategories();
  }

  loadSubCategories() async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchSubCategories(chosenindex);
  }

  loadProducts() async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchProductsCategory(chosenindex.toString());
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context, listen: false);

    Widget popularView = Container(
      child: ListenableProvider.value(
        value: categories,
        child: Consumer<CategoryProvider>(
          builder: (context, value, child) {
            if (value.loadingSub) {
              return subShimmer();
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: value.popularCategories.length,
                      itemBuilder: (context, i) {
                        return ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            Text(
                              value.popularCategories[i].title,
                              style: TextStyle(
                                  fontSize: responsiveFont(8),
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: value
                                    .popularCategories[i].categories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 3,
                                        childAspectRatio: 1 / 1),
                                itemBuilder: (context, j) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandProducts(
                                                    categoryId: value
                                                        .popularCategories[i]
                                                        .categories[j]
                                                        .id,
                                                    brandName: value
                                                        .popularCategories[i]
                                                        .categories[j]
                                                        .titleCategories,
                                                  )));
                                    },
                                    child: Image.network(value
                                        .popularCategories[i]
                                        .categories[j]
                                        .image),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 15,
                            ),
                          ],
                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );

    Widget subView = Container(
      child: ListenableProvider.value(
        value: categories,
        child: Consumer<CategoryProvider>(
          builder: (context, value, child) {
            if (value.loadingSub) {
              return subShimmer();
            }
            if (value.subCategories.isEmpty) {
              return emptyCategory;
            }
            return ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: value.subCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1.5),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BrandProducts(
                                        categoryId: value.subCategories[i].id
                                            .toString(),
                                        brandName: value.subCategories[i].name,
                                      )));
                        },
                        child: Column(
                          children: [
                            Image.network(value.subCategories[i].image),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              value.subCategories[i].name,
                              style: TextStyle(
                                fontSize: responsiveFont(8),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    Widget subViewProducts = Container(
      child: ListenableProvider.value(
        value: categories,
        child: Consumer<CategoryProvider>(
          builder: (context, value, child) {
            if (value.loadingSub) {
              return subShimmer();
            }
            if (value.listProductCategory.length < 1) {
              return Container();
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GridView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: value.listProductCategory.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 80 / 140),
                itemBuilder: (context, i) {
                  return GridItemCategory(
                    i: i,
                    itemCount: value.listProductCategory.length,
                    product: value.listProductCategory[i],
                    categoryId: chosenindex,
                    categoryName: categoryName,
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    Widget buildMainCategories = Container(
      child: ListenableProvider.value(
        value: categories,
        child: Consumer<CategoryProvider>(builder: (context, value, child) {
          if (value.loadingAll) {
            return shimmerCategories();
          }
          return Column(
            children: [
              appBar(),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: ListView(
                        children: <Widget>[
                          ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: value.allCategories.length,
                              itemBuilder: (context, i) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  children: [
                                    tabBar(
                                      value.allCategories[i].title,
                                      value.allCategories[i].image,
                                      value.allCategories[i].id,
                                      value.allCategories[i].count,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          color: Colors.grey[100],
                          alignment: Alignment.topLeft,
                          child: chosenindex == 9911
                              ? popularView
                              : chosenCountSub == 0
                                  ? subViewProducts
                                  : subView),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );

    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        appBar: widget.isFromHome
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "Categories",
                  style: TextStyle(color: Colors.black),
                ),
              ),
        body: buildMainCategories,
      ),
    );
  }

  Widget emptyCategory = Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.info_outline,
        size: 48,
        color: primaryColor,
      ),
      Text(
        "Sorry, could not find any brand in this category.",
        textAlign: TextAlign.center,
      )
    ],
  );

  Widget tabBar(String title, String image, int indexTab, int countSub) {
    final categories = Provider.of<CategoryProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        setState(() {
          chosenindex = indexTab;
          chosenCountSub = countSub;
          categoryName = title;
          categories.currentSelectedCategory = chosenindex;
          categories.currentSelectedCountSub = chosenCountSub;
        });
        if (chosenindex == 9911) {
          loadPopularCategories();
        } else {
          if (chosenCountSub != 0) {
            loadSubCategories();
          } else {
            loadProducts();
          }
        }
      },
      child: Container(
        width: 90.w,
        height: 73.h,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: image.isEmpty
                          ? Icon(Icons.broken_image_outlined)
                          : Image.network(image, fit: BoxFit.fitWidth),
                    ),
                    Container(
                      height: 5,
                    ),
                    Flexible(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsiveFont(8),
                            fontWeight: FontWeight.w600,
                            color: indexTab == chosenindex
                                ? primaryColor
                                : Colors.black),
                      ),
                    )
                  ],
                )),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 5,
              height: indexTab == chosenindex ? 90.w : 0,
              color: secondaryColor,
            )
          ],
        ),
      ),
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
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      filled: true,
                      enabled: false,
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
                  ))),
        ));
  }

  Widget shimmerCategories() {
    return Column(
      children: [
        appBar(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height / 1.25,
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: [
                  tabBarShimmer(),
                  SizedBox(
                    height: 3,
                  ),
                  tabBarShimmer(),
                  SizedBox(
                    height: 3,
                  ),
                  tabBarShimmer(),
                  SizedBox(
                    height: 3,
                  ),
                  tabBarShimmer(),
                  SizedBox(
                    height: 3,
                  ),
                  tabBarShimmer(),
                  SizedBox(
                    height: 3,
                  ),
                  tabBarShimmer(),
                ],
              ),
            )),
            Expanded(
                flex: 3,
                child: Shimmer.fromColors(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.25,
                      color: Colors.white,
                      alignment: Alignment.topLeft,
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100]))
          ],
        ),
      ],
    );
  }

  Widget tabBarShimmer() {
    return Container(
      width: 90.w,
      height: 73.h,
      child: Stack(
        children: [
          Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Shimmer.fromColors(
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        width: 60,
                        height: 8,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100])),
        ],
      ),
    );
  }

  Widget appBarShimmer() {
    return Material(
      elevation: 5,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(),
          child: Container(
              height: 70,
              padding:
                  EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
              child: Shimmer.fromColors(
                  child: Container(
                    height: 10,
                    color: Colors.white,
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100]))),
    );
  }

  Widget subShimmer() {
    return Shimmer.fromColors(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.25,
          color: Colors.white,
          alignment: Alignment.topLeft,
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}
