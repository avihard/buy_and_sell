import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutterbuyandsell/api/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/blog/blog_provider.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/product/item_list_from_followers_provider.dart';
import 'package:flutterbuyandsell/provider/product/popular_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/recent_product_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/blog_repository.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_horizontal_list_item.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/blog_product_slider.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/category_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
    this.scrollController,
    this.animationController,
    this.animationControllerForFab,
    this.context,
  );

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder valueHolder;
  CategoryRepository repo1;
  ProductRepository repo2;
  BlogRepository repo3;
  ItemLocationRepository repo4;
  NotificationRepository notificationRepository;
  CategoryProvider _categoryProvider;
  RecentProductProvider _recentProductProvider;
  PopularProductProvider _popularProductProvider;
  BlogProvider _blogProvider;
  UserUnreadMessageProvider _userUnreadMessageProvider;
  ItemListFromFollowersProvider _itemListFromFollowersProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;

  final int count = 8;
  final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    // _categoryProvider.dispose();
    // _recentProductProvider.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (_categoryProvider != null) {
      _categoryProvider.loadCategoryList();
    }

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // setState(() {
        //   _isVisible = false;
        //   //print('**** $_isVisible up');
        // });
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.reverse();
        }
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // setState(() {
        //   _isVisible = true;
        //   //print('**** $_isVisible down');
        // });
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.forward();
        }
      }
    });
  }

  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    repo4 = Provider.of<ItemLocationRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1,
                    psValueHolder: valueHolder,
                    limit: PsConfig.CATEGORY_LOADING_LIMIT);
                _categoryProvider.loadCategoryList();
                return _categoryProvider;
              }),
          ChangeNotifierProvider<RecentProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _recentProductProvider = RecentProductProvider(
                    repo: repo2, limit: PsConfig.RECENT_ITEM_LOADING_LIMIT);
                // _recentProductProvider.productRecentParameterHolder
                //     .itemLocationId = valueHolder.locationId;
                final String loginUserId = Utils.checkUserLoginId(valueHolder);
                _recentProductProvider.loadProductList(loginUserId,
                    _recentProductProvider.productRecentParameterHolder);
                return _recentProductProvider;
              }),
          ChangeNotifierProvider<PopularProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _popularProductProvider = PopularProductProvider(
                    repo: repo2, limit: PsConfig.POPULAR_ITEM_LOADING_LIMIT);
                // _popularProductProvider.productPopularParameterHolder
                //     .itemLocationId = valueHolder.locationId;
                final String loginUserId = Utils.checkUserLoginId(valueHolder);
                _popularProductProvider.loadProductList(loginUserId,
                    _popularProductProvider.productPopularParameterHolder);
                return _popularProductProvider;
              }),
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(
                    repo: repo3, limit: PsConfig.BLOCK_SLIDER_LOADING_LIMIT);
                _blogProvider.loadBlogList();
                return _blogProvider;
              }),
          ChangeNotifierProvider<UserUnreadMessageProvider>(
              lazy: false,
              create: (BuildContext context) {
                _userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository);

                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '') {
                  _userUnreadMessageProvider.userUnreadMessageHolder =
                      UserUnreadMessageParameterHolder(
                          userId: valueHolder.loginUserId,
                          deviceToken: valueHolder.deviceToken);
                  _userUnreadMessageProvider.userUnreadMessageCount(
                      _userUnreadMessageProvider.userUnreadMessageHolder);
                }
                return _userUnreadMessageProvider;
              }),
          ChangeNotifierProvider<ItemListFromFollowersProvider>(
              lazy: false,
              create: (BuildContext context) {
                _itemListFromFollowersProvider = ItemListFromFollowersProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: PsConfig.FOLLOWER_ITEM_LOADING_LIMIT);
                _itemListFromFollowersProvider.loadItemListFromFollowersList(
                    Utils.checkUserLoginId(
                        _itemListFromFollowersProvider.psValueHolder));
                return _itemListFromFollowersProvider;
              }),
        ],
        child: Scaffold(
          /*floatingActionButton: FadeTransition(
            opacity: widget.animationControllerForFab,
            child: ScaleTransition(
              scale: widget.animationControllerForFab,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (await Utils.checkInternetConnectivity()) {
                    Utils.navigateOnUserVerificationView(
                        _categoryProvider, context, () async {
                      Navigator.pushNamed(context, RoutePaths.itemEntry,
                          arguments: ItemEntryIntentHolder(
                              flag: PsConst.ADD_NEW_ITEM, item: Product()));
                    });
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(
                                context, 'error_dialog__no_internet'),
                          );
                        });
                  }
                },
                icon: Icon(Icons.camera_alt, color: PsColors.white),
                backgroundColor: PsColors.mainColor,
                label: Text(Utils.getString(context, 'dashboard__submit_ad'),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: PsColors.white)),
              ),
            ),
          ),
*/
          // floatingActionButton: AnimatedContainer(
          //   duration: const Duration(milliseconds: 300),
          //   child: FloatingActionButton.extended(
          //     onPressed: () async {
          //       if (await Utils.checkInternetConnectivity()) {
          //         Utils.navigateOnUserVerificationView(
          //             _categoryProvider, context, () async {
          //           Navigator.pushNamed(context, RoutePaths.itemEntry,
          //               arguments: ItemEntryIntentHolder(
          //                   flag: PsConst.ADD_NEW_ITEM, item: Product()));
          //         });
          //       } else {
          //         showDialog<dynamic>(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return ErrorDialog(
          //                 message: Utils.getString(
          //                     context, 'error_dialog__no_internet'),
          //               );
          //             });
          //       }
          //     },
          //     icon: _isVisible ? const Icon(Icons.camera_alt) : null,
          //     backgroundColor: PsColors.mainColor,
          //     label: _isVisible
          //         ? Text(Utils.getString(context, 'dashboard__submit_ad'),
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 .copyWith(color: PsColors.white))
          //         : const Text(''),
          //   ),
          //   height: _isVisible ? PsDimens.space52 : 0.0,
          //   width: PsDimens.space200,
          // ),

          // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
          body: Container(
            color: PsColors.coreBackgroundColor,
            child: RefreshIndicator(
                onRefresh: () {
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder);
                  _recentProductProvider.resetProductList(loginUserId,
                      _recentProductProvider.productRecentParameterHolder);

                  _popularProductProvider.resetProductList(loginUserId,
                      _popularProductProvider.productPopularParameterHolder);

                  _blogProvider.resetBlogList();

                  if (valueHolder.loginUserId != null &&
                      valueHolder.loginUserId != '') {
                    _userUnreadMessageProvider.userUnreadMessageCount(
                        _userUnreadMessageProvider.userUnreadMessageHolder);
                  }

                  _itemListFromFollowersProvider.resetItemListFromFollowersList(
                      Utils.checkUserLoginId(
                          _itemListFromFollowersProvider.psValueHolder));

                  return _categoryProvider.resetCategoryList();
                },
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: widget.scrollController,
                  slivers: <Widget>[
                    // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
                    _HomeHeaderWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      psValueHolder: valueHolder,
                      itemNameTextEditingController:
                          userInputItemNameTextEditingController,
                      isGrid: isGrid,
                    ),
                    _HomeCategoryHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _RecentProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    /*_HomePopularProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),*/
                    /*  _HomeBlogProductSliderListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 5, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
*/ /*         _HomeItemListFromFollowersHorizontalListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),*/
                  ],
                )),
          ),
        ));
  }
}

class _HomePopularProductHorizontalListWidget extends StatelessWidget {
  const _HomePopularProductHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularProductProvider>(
        builder: (BuildContext context, PopularProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'home__drawer_menu_popular_item'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_popular_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(context,
                                      'home__drawer_menu_popular_item'),
                                  productParameterHolder:
                                      ProductParameterHolder()
                                          .getPopularParameterHolder()));
                        },
                      ),
                      Container(
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  productProvider.productList.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data[index];
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id,
                                    product:
                                        productProvider.productList.data[index],
                                    onTap: () {
                                      print(productProvider.productList
                                          .data[index].defaultPhoto.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: productProvider
                                                  .productList.data[index].id,
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _RecentProductHorizontalListWidget extends StatefulWidget {
  const _RecentProductHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __RecentProductHorizontalListWidgetState createState() =>
      __RecentProductHorizontalListWidgetState();
}

class __RecentProductHorizontalListWidgetState
    extends State<_RecentProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<RecentProductProvider>(builder: (BuildContext context,
            RecentProductProvider productProvider, Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard_recent_product'),
                    headerDescription:
                        Utils.getString(context, 'dashboard_recent_item_desc'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard_recent_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getRecentParameterHolder()));
                    },
                  ),
                  Container(
                      // height: PsDimens.space340,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 5,
                          ),
                          itemCount: productProvider.productList.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data[index];
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id,
                                product:
                                    productProvider.productList.data[index],
                                onTap: () {
                                  print(productProvider.productList.data[index]
                                      .defaultPhoto.imgPath);

                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: productProvider
                                              .productList.data[index].id,
                                          heroTagImage: productProvider.hashCode
                                                  .toString() +
                                              product.id +
                                              PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle: productProvider.hashCode
                                                  .toString() +
                                              product.id +
                                              PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                          })),
                  const PsAdMobBannerWidget(
                    admobSize: NativeAdmobType.full,
                    // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                    blogProvider.blogList.data.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'home__menu_drawer_blog'),
                        headerDescription: Utils.getString(context, ''),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.blogList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainLightShadowColor,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 20.0),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8, bottom: PsDimens.space20),
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(context, RoutePaths.blogDetail,
                                arguments: blog);
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data.isNotEmpty)
                ? Column(children: <Widget>[
                    _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard__categories'),
                      headerDescription:
                          Utils.getString(context, 'dashboard__category_desc'),
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.categoryList,
                            arguments: 'Categories');
                      },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width - 16,
                      // height: double.maxFinite ,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int index) {
                            if (categoryProvider.categoryList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data[index],
                                onTap: () {
                                  if (PsConfig.isShowSubCategory) {
                                    Navigator.pushNamed(
                                        context, RoutePaths.subCategoryGrid,
                                        arguments: categoryProvider
                                            .categoryList.data[index]);
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    print(categoryProvider.categoryList
                                        .data[index].defaultPhoto.imgPath);
                                    final ProductParameterHolder
                                        productParameterHolder =
                                        ProductParameterHolder()
                                            .getLatestParameterHolder();
                                    productParameterHolder.catId =
                                        categoryProvider
                                            .categoryList.data[index].catId;
                                    Navigator.pushNamed(
                                        context, RoutePaths.filterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: categoryProvider
                                              .categoryList.data[index].catName,
                                          productParameterHolder:
                                              productParameterHolder,
                                        ));
                                  }
                                },
                                // )
                              );
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (itemListFromFollowersProvider.psValueHolder.loginUserId !=
                        '' &&
                    itemListFromFollowersProvider
                            .itemListFromFollowersList.data !=
                        null &&
                    itemListFromFollowersProvider
                        .itemListFromFollowersList.data.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__item_list_from_followers'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_follow_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.itemListFromFollower,
                              arguments: itemListFromFollowersProvider
                                  .psValueHolder.loginUserId);
                        },
                      ),
                      Container(
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (itemListFromFollowersProvider
                                        .itemListFromFollowersList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ProductHorizontalListItem(
                                    coreTagKey: itemListFromFollowersProvider
                                            .hashCode
                                            .toString() +
                                        itemListFromFollowersProvider
                                            .itemListFromFollowersList
                                            .data[index]
                                            .id,
                                    product: itemListFromFollowersProvider
                                        .itemListFromFollowersList.data[index],
                                    onTap: () {
                                      print(itemListFromFollowersProvider
                                          .itemListFromFollowersList
                                          .data[index]
                                          .defaultPhoto
                                          .imgPath);
                                      final Product product =
                                          itemListFromFollowersProvider
                                              .itemListFromFollowersList
                                              .data
                                              .reversed
                                              .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data[index]
                                                      .id,
                                              heroTagImage:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.headerDescription,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String headerDescription;
  final Function viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    //   fit: FlexFit.loose,
                    child: Text(widget.headerName,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PsColors.textPrimaryDarkColor)),
                  ),
                  Text(
                    Utils.getString(context, 'dashboard__view_all'),
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: PsColors.mainColor),
                  ),
                ],
              ),
              /* if (widget.headerDescription == '')
              Container()
            else*/
              /* Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                  ),
                ],
              ),*/
            ]),
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  _HomeHeaderWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder,
      @required this.itemNameTextEditingController,
      @required this.isGrid})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController itemNameTextEditingController;
  bool isGrid;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
            animation: widget.animationController,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _MyHomeHeaderWidget(
                  userInputItemNameTextEditingController:
                      widget.itemNameTextEditingController,
                  selectedLocation: () {
                    Navigator.pushNamed(context, RoutePaths.itemLocationList);
                  },
                  locationName: widget.psValueHolder.locactionName,
                  psValueHolder: widget.psValueHolder,
                  isGrid: widget.isGrid,
                )
              ],
            ),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            }));
  }
}

class _MyHomeHeaderWidget extends StatefulWidget {
  _MyHomeHeaderWidget(
      {Key key,
      @required this.userInputItemNameTextEditingController,
      @required this.selectedLocation,
      @required this.locationName,
      @required this.psValueHolder,
      @required this.isGrid})
      : super(key: key);

  final Function selectedLocation;
  final String locationName;
  final TextEditingController userInputItemNameTextEditingController;
  final PsValueHolder psValueHolder;
  bool isGrid;
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

final ProductParameterHolder productParameterHolder =
    ProductParameterHolder().getLatestParameterHolder();

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: PsDimens.space20,
            top: PsDimens.space20,
            right: PsDimens.space20,
            bottom: PsDimens.space4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  Utils.getString(context, 'app_name'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: PsColors.textPrimaryDarkColor),
                ),
              ),
              const SizedBox(width: PsDimens.space20),
              Text(
                Utils.getString(context, 'dashboard__your_location'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space20,
              right: PsDimens.space20,
              bottom: PsDimens.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                height: 30,
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: widget.selectedLocation,
                    child: Text(
                      widget.locationName,
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                  MySeparator(color: PsColors.grey),
                ],
              ),
            ],
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space24, bottom: PsDimens.space10),
          child: PsTextFieldWidgetWithIcon(
              hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
              textEditingController:
                  widget.userInputItemNameTextEditingController,
              psValueHolder: widget.psValueHolder,
              clickSearchButton: () {
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              },
              clickEnterFunction: () {
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              }),
        ),*/
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({this.height = 1, this.color});
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 10.0;
        final double dashHeight = height;
        const int dashCount = 10; //(boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: PsDimens.space2),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
