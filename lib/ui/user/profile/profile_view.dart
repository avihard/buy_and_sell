import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/added_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/disabled_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/paid_id_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/pending_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/rejected_product_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/paid_ad_item_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/chat/list/chat_list_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item_for_profile.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad/paid_ad_item_horizontal_list_item.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/delete_user_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    @required this.scaffoldKey,
    @required this.callLogoutCallBack,
    // @required this.scrollController,
    // @required this.animationControllerForFab
  }) : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  final Function callLogoutCallBack;
  // final ScrollController scrollController;
  // final AnimationController animationControllerForFab;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

ScrollController scrollController = ScrollController();
AnimationController animationControllerForFab;

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  PsValueHolder psValueHolder;
  UserProvider provider;

  @override
  void initState() {
    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (animationControllerForFab != null) {
          animationControllerForFab.reverse();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (animationControllerForFab != null) {
          animationControllerForFab.forward();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);

    return Scaffold(
      /*floatingActionButton: FadeTransition(
        opacity: animationControllerForFab,
        child: ScaleTransition(
          scale: animationControllerForFab,
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView(provider, context,
                    () async {
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
      ),*/
      body: SingleChildScrollView(
          child: Material(
        elevation: 10,
        child: Container(
          color: PsColors.coreBackgroundColor,
          height: widget.flag ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
              ? MediaQuery.of(context).size.height - 100
              : MediaQuery.of(context).size.height - 40,
          child: CustomScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                _ProfileDetailWidget(
                    animationController: widget.animationController,
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController,
                        curve: const Interval((1 / 4) * 2, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    userId: widget.userId,
                    provider: provider,
                    callLogoutCallBack: widget.callLogoutCallBack),
                _PaidAdWidget(
                  animationController: widget.animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  userId: widget.userId, //animationController,
                ),
                ListingDataWidget(
                  animationController: widget.animationController,
                  userId: widget.userId,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  headerTitle: Utils.getString(context, 'profile__listing'),
                  status: '1', //animationController,
                ),
                _PendingListingDataWidget(
                  animationController: widget.animationController,
                  userId: widget.userId,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  headerTitle:
                      Utils.getString(context, 'profile__pending_listing'),
                  status: '0', //animationController,
                ),
                _RejectedListingDataWidget(
                  animationController: widget.animationController,
                  userId: widget.userId,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  headerTitle:
                      Utils.getString(context, 'profile__rejected_listing'),
                  status: '3', //animationController,
                ),
                _DisabledListingDataWidget(
                  animationController: widget.animationController,
                  userId: widget.userId,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  headerTitle:
                      Utils.getString(context, 'profile__disable_listing'),
                  status: '2', //animationController,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: PsDimens.space36,
                  ),
                )
              ]),
        ),
      )),
    );
  }
}

class _PaidAdWidget extends StatefulWidget {
  const _PaidAdWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final Animation<double> animation;

  @override
  __PaidAdWidgetState createState() => __PaidAdWidgetState();
}

class __PaidAdWidgetState extends State<_PaidAdWidget> {
  PaidAdItemRepository paidAdItemRepository;
  PsValueHolder psValueHolder;
  ProductParameterHolder parameterHolder;

  @override
  Widget build(BuildContext context) {
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<PaidAdItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final PaidAdItemProvider provider = PaidAdItemProvider(
                  repo: paidAdItemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.loadPaidAdItemList(widget.userId);
              } else {
                provider.loadPaidAdItemList(provider.psValueHolder.loginUserId);
              }

              return provider;
            },
            child: Consumer<PaidAdItemProvider>(builder: (BuildContext context,
                PaidAdItemProvider productProvider, Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (productProvider.paidAdItemList.data != null &&
                          productProvider.paidAdItemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName:
                                Utils.getString(context, 'profile__paid_ad'),
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                context,
                                RoutePaths.paidAdItemList,
                              );
                            },
                          ),
                          Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productProvider
                                      .paidAdItemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (productProvider.paidAdItemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return PaidAdItemHorizontalListItem(
                                        paidAdItem: productProvider
                                            .paidAdItemList.data[index],
                                        onTap: () {
                                          // final Product product = provider.historyList.data.reversed.toList()[index];
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                  productId: productProvider
                                                      .paidAdItemList
                                                      .data[index]
                                                      .item
                                                      .id,
                                                  heroTagImage: productProvider
                                                          .hashCode
                                                          .toString() +
                                                      productProvider
                                                          .paidAdItemList
                                                          .data[index]
                                                          .item
                                                          .id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: productProvider
                                                          .hashCode
                                                          .toString() +
                                                      productProvider
                                                          .paidAdItemList
                                                          .data[index]
                                                          .item
                                                          .id +
                                                      PsConst.HERO_TAG__TITLE);
                                          Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder
                                              // productProvider
                                              //     .paidAdItemList.data[index].item
                                              );
                                        },
                                      );
                                    }
                                  }))
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
            })));
  }
}

class ListingDataWidget extends StatefulWidget {
  const ListingDataWidget(
      {Key key,
      @required this.animationController,
      @required this.status,
      @required this.headerTitle,
      this.userId,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String status;
  final String headerTitle;
  final String userId;
  final Animation<double> animation;

  @override
  _ListingDataWidgetState createState() => _ListingDataWidgetState();
}

class _ListingDataWidgetState extends State<ListingDataWidget> {
  ProductRepository productRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    productRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<AddedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final AddedItemProvider provider = AddedItemProvider(
                  repo: productRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadItemList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadItemList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<AddedItemProvider>(builder: (BuildContext context,
                AddedItemProvider productProvider, Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (productProvider.itemList.data != null &&
                          productProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemListForProfile,
                                  arguments: ItemListIntentHolder(
                                      userId: productProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space340,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      productProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (productProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ProductHorizontalListItemForProfile(
                                        product: productProvider
                                            .itemList.data[index],
                                        coreTagKey: productProvider.hashCode
                                                .toString() +
                                            productProvider
                                                .itemList.data[index].id,
                                        onTap: () {
                                          print(productProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Product product =
                                              productProvider
                                                  .itemList.data.reversed
                                                  .toList()[index];
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                  productId: productProvider
                                                      .itemList.data[index].id,
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
            })));
  }
}

class _PendingListingDataWidget extends StatefulWidget {
  const _PendingListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  ___PendingListingDataWidgetState createState() =>
      ___PendingListingDataWidgetState();
}

class ___PendingListingDataWidgetState
    extends State<_PendingListingDataWidget> {
  ProductRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<PendingProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final PendingProductProvider provider = PendingProductProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<PendingProductProvider>(builder:
                (BuildContext context, PendingProductProvider itemProvider,
                    Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemListForProfile,
                                  arguments: ItemListIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ProductHorizontalListItemForProfile(
                                        product:
                                            itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Product product = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                  productId: itemProvider
                                                      .itemList.data[index].id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
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
            })));
  }
}

class _DisabledListingDataWidget extends StatefulWidget {
  const _DisabledListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  __DisabledListingDataWidgetState createState() =>
      __DisabledListingDataWidgetState();
}

class __DisabledListingDataWidgetState
    extends State<_DisabledListingDataWidget> {
  ProductRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<DisabledProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final DisabledProductProvider provider = DisabledProductProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<DisabledProductProvider>(builder:
                (BuildContext context, DisabledProductProvider itemProvider,
                    Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemListForProfile,
                                  arguments: ItemListIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ProductHorizontalListItemForProfile(
                                        product:
                                            itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Product product = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                  productId: itemProvider
                                                      .itemList.data[index].id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
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
            })));
  }
}

class _RejectedListingDataWidget extends StatefulWidget {
  const _RejectedListingDataWidget(
      {Key key,
      @required this.animationController,
      this.userId,
      @required this.headerTitle,
      @required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final String headerTitle;
  final String status;
  final Animation<double> animation;

  @override
  ___RejectedListingDataWidgetState createState() =>
      ___RejectedListingDataWidgetState();
}

class ___RejectedListingDataWidgetState
    extends State<_RejectedListingDataWidget> {
  ProductRepository itemRepository;

  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<RejectedProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final RejectedProductProvider provider = RejectedProductProvider(
                  repo: itemRepository, psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.addedUserParameterHolder.addedUserId = widget.userId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(
                    widget.userId, provider.addedUserParameterHolder);
              } else {
                provider.addedUserParameterHolder.addedUserId =
                    provider.psValueHolder.loginUserId;
                provider.addedUserParameterHolder.status = widget.status;
                provider.loadProductList(provider.psValueHolder.loginUserId,
                    provider.addedUserParameterHolder);
              }

              return provider;
            },
            child: Consumer<RejectedProductProvider>(builder:
                (BuildContext context, RejectedProductProvider itemProvider,
                    Widget child) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: (itemProvider.itemList.data != null &&
                          itemProvider.itemList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _HeaderWidget(
                            headerName: widget.headerTitle,
                            viewAllClicked: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.userItemListForProfile,
                                  arguments: ItemListIntentHolder(
                                      userId: itemProvider
                                          .psValueHolder.loginUserId,
                                      status: widget.status,
                                      title: widget.headerTitle));
                            },
                          ),
                          Container(
                              height: PsDimens.space320,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemProvider.itemList.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (itemProvider.itemList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.white,
                                          child: Row(children: const <Widget>[
                                            PsFrameUIForLoading(),
                                          ]));
                                    } else {
                                      return ProductHorizontalListItemForProfile(
                                        product:
                                            itemProvider.itemList.data[index],
                                        coreTagKey:
                                            itemProvider.hashCode.toString() +
                                                itemProvider
                                                    .itemList.data[index].id,
                                        onTap: () {
                                          print(itemProvider
                                              .itemList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final Product product = itemProvider
                                              .itemList.data.reversed
                                              .toList()[index];
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                                  productId: itemProvider
                                                      .itemList.data[index].id,
                                                  heroTagImage: itemProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                                  heroTagTitle: itemProvider
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
            })));
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget(
      {Key key,
      this.animationController,
      this.animation,
      @required this.userId,
      @required this.provider,
      @required this.callLogoutCallBack})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;
  final Function callLogoutCallBack;
  final UserProvider provider;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = SizedBox(
      height: 16,
    );

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(widget.provider.getCurrentFirebaseUser());
            if (widget.provider.psValueHolder.loginUserId == null ||
                widget.provider.psValueHolder.loginUserId == '') {
              widget.provider.userParameterHolder.id = widget.userId;
              widget.provider.getUser(widget.userId);
              // provider.getMyUserData(provider.userParameterHolder.toMap());
            } else {
              widget.provider.userParameterHolder.id =
                  widget.provider.psValueHolder.loginUserId;
              widget.provider
                  .getUser(widget.provider.psValueHolder.loginUserId);
              // provider.getMyUserData(provider.userParameterHolder.toMap());
            }

            return widget.provider;
          },
          child: Consumer<UserProvider>(builder:
              (BuildContext context, UserProvider provider, Widget child) {
            if (provider.user != null &&
                provider.user.data != null &&
                provider.user.data != null) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24))),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              // _FavAndSettingWidget(
                              //     userProvider: provider,
                              //     callLogoutCallBack:
                              //         widget.callLogoutCallBack),
                              _ImageAndTextWidget(
                                  userProvider: provider,
                                  callLogoutCallBack: widget.callLogoutCallBack,
                                  animationController: animationController),
                              //
                              //     // _JoinDateWidget(userProvider: provider),
                              //     _VerifiedWidget(
                              //       data: provider.user.data,
                              //     ),
                              //     _DeactivateAccWidget(
                              //       userProvider: provider,
                              //       callLogoutCallBack: widget.callLogoutCallBack,
                              //     ),
                              //     _dividerWidget,
                              //      InkWell(
                              //   onTap: (){
                              //  //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListView(),));
                              //   },
                              //   child: ChatListView(
                              //     animationController: animationController,
                              //   ),
                              // )
                              SizedBox(
                                height: 35,
                                width: double.infinity,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          height: 70,
                          //width: MediaQuery.of(context).size.width - 50,

                          decoration: BoxDecoration(
                              color: PsColors.mainLightColor,
                              borderRadius: BorderRadius.circular(24)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _VerifiedWidget(
                                data: provider.user.data,
                              ),
                              _DeactivateAccWidget(
                                userProvider: provider,
                                callLogoutCallBack: widget.callLogoutCallBack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            } else {
              return Container();
            }
          })),
    );
  }
}

class _VerifiedWidget extends StatelessWidget {
  const _VerifiedWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
      ),
      child: Row(
        children: <Widget>[
          Text(
            Utils.getString(context, 'seller_info_tile__verified'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          if (data.facebookVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.facebook_official,
              ),
            )
          else
            Container(),
          if (data.googleVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.google,
              ),
            )
          else
            Container(),
          if (data.phoneVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.phone,
              ),
            )
          else
            Container(),
          if (data.emailVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                MaterialCommunityIcons.email,
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          top: PsDimens.space16,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Text(Utils.getString(context, 'profile__join_on'),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(
                  userProvider.user.data.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(userProvider.user.data.addedDate),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            )));
  }
}

class _DeactivateAccWidget extends StatelessWidget {
  const _DeactivateAccWidget(
      {@required this.userProvider, @required this.callLogoutCallBack});
  final UserProvider userProvider;
  final Function callLogoutCallBack;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space8,
            bottom: PsDimens.space8),
        child: InkWell(
          child: Container(
            child: Ink(
              color: PsColors.backgroundColor,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Utils.getString(context, 'profile__deactivate_acc'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.normal, color: PsColors.mainColor),
                ),
              ),
            ),
          ),
          onTap: () {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialogView(
                      description: Utils.getString(
                          context, 'profile__deactivate_confirm_text'),
                      leftButtonText:
                          Utils.getString(context, 'dialog__cancel'),
                      rightButtonText: Utils.getString(context, 'dialog__ok'),
                      onAgreeTap: () async {
                        Navigator.pop(context);
                        await PsProgressDialog.showDialog(context);
                        final DeleteUserHolder deleteUserHolder =
                            DeleteUserHolder(
                                userId: userProvider.psValueHolder.loginUserId);
                        final PsResource<ApiStatus> _apiStatus =
                            await userProvider
                                .postDeleteUser(deleteUserHolder.toMap());
                        if (_apiStatus.data != null) {
                          if (callLogoutCallBack != null) {
                            callLogoutCallBack(
                                userProvider.psValueHolder.loginUserId);
                          }
                        }
                        PsProgressDialog.dismissDialog();
                      });
                });
          },
        ));
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  const _FavAndSettingWidget({this.userProvider, this.callLogoutCallBack});

  final UserProvider userProvider;
  final Function callLogoutCallBack;
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return SizedBox();
    /*Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteProductList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () async {
                */ /*  final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData != null && returnData is bool) {
                  userProvider.getUser(userProvider.psValueHolder.loginUserId);
                }*/ /*

                final dynamic returnData = await Navigator.pushNamed(
                    //  context, RoutePaths.editProfile
                    context,
                    RoutePaths.more,
                    arguments: userProvider.user.data.userName);
                if (returnData) {
                  if (callLogoutCallBack != null) {
                    callLogoutCallBack(userProvider.psValueHolder.loginUserId);
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__more'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );*/
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget(
      {@required this.userProvider, this.animationController});
  final UserProvider userProvider;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space48,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        InkWell(
          child: Text(
            Utils.getString(context, 'rating_entry__message'),
            softWrap: false,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold),
          ),
          /*height: 50,
      minWidth: 100,*/
          onTap: () async {
            Navigator.push<MaterialPageRoute>(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListView(
                    animationController: animationController,
                  ),
                ));
          },
        ),
        /* _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 0,
        ),*/

        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutePaths.followerUserList,
            );
          },
          child: Column(
            children: [
              Text(
                userProvider.user.data.followerCount,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                Utils.getString(context, 'profile__follower'),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        /* _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 1,
        ),*/

        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutePaths.followingUserList,
            );
          },
          child: Column(
            children: [
              Text(
                userProvider.user.data.followingCount,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                Utils.getString(context, 'profile__following'),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
        /* _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 2,
        )*/
      ],
    );
  }
}

/*
class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key key,
    @required this.userProvider,
    @required this.checkText,
  }) : super(key: key);

  final UserProvider userProvider;
  final int checkText;

  @override
  Widget build(BuildContext context) {
    if (checkText == 0) {
      return Container();
    } else {
      return Expanded(
          child: InkWell(
             */
/* height: 50,
              minWidth: double.infinity,*/ /*

              onTap: () async {
                if (checkText == 1) {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.followerUserList,
                  );
                } else if (checkText == 2) {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.followingUserList,
                  );
                }
              },
              child: checkText == 1
                  ?
                  :
          ));
    }
  }
}
*/

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key key,
    @required this.headerName,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(headerName,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
            InkWell(
              child: Text(
                Utils.getString(context, 'profile__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: PsColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget(
      {this.userProvider, this.callLogoutCallBack, this.animationController});
  final UserProvider userProvider;
  final Function callLogoutCallBack;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider.user.data.userProfilePhoto,
      width: PsDimens.space100,
      height: PsDimens.space100,
      boxfit: BoxFit.cover,
      onTap: () {},
    );
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space6,
    );
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      elevation: 10,
      child: Container(
        height: 320,
        width: double.infinity,
        margin: const EdgeInsets.only(
            top: PsDimens.space16, bottom: PsDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.favouriteProductList,
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          _sizedBoxWidget,
                          Text(
                            Utils.getString(context, 'profile__favourite'),
                            textAlign: TextAlign.start,
                            softWrap: false,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      onPressed: () async {
                        /*  final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData != null && returnData is bool) {
                  userProvider.getUser(userProvider.psValueHolder.loginUserId);
                }*/

                        final dynamic returnData = await Navigator.pushNamed(
                            //  context, RoutePaths.editProfile
                            context,
                            RoutePaths.more,
                            arguments: userProvider.user.data.userName);
                        if (returnData) {
                          if (callLogoutCallBack != null) {
                            callLogoutCallBack(
                                userProvider.psValueHolder.loginUserId);
                          }
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.more_horiz,
                              color: Theme.of(context).iconTheme.color),
                          _sizedBoxWidget,
                          Text(
                            Utils.getString(context, 'profile__more'),
                            softWrap: false,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                _imageWidget,
                Positioned(
                  top: 70,
                  left: 65, //(MediaQuery.of(context).size.width / 2) - 130,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: PsColors.mainColor),
                      child: InkWell(
                          onTap: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                              context,
                              RoutePaths.editProfile,
                            );
                            if (returnData != null && returnData is bool) {
                              userProvider.getUser(
                                  userProvider.psValueHolder.loginUserId);
                            }
                          },
                          child: Icon(Icons.edit))),
                )
              ],
            ),
            SizedBox(height: PsDimens.space16),
            Text(
              userProvider.user.data.userName,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5,
              maxLines: 1,
            ),
            _spacingWidget,
            Text(
              userProvider.user.data.userPhone != ''
                  ? userProvider.user.data.userPhone
                  : Utils.getString(context, 'profile__phone_no'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: PsColors.textPrimaryLightColor),
              maxLines: 1,
            ),
            _spacingWidget,
            /*Align(
                alignment: Alignment.,
                child: Row(
                  children: <Widget>[
                    Text(Utils.getString(context, 'profile__join_on'),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1),
                    const SizedBox(
                      width: PsDimens.space2,
                    ),
                    Text(
                      userProvider.user.data.addedDate == ''
                          ? ''
                          : Utils.getDateFormat(
                              userProvider.user.data.addedDate),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                )),*/
            SizedBox(height: PsDimens.space16),
            _EditAndHistoryRowWidget(
              userProvider: userProvider,
              animationController: animationController,
            ),
          ],
        ),
      ),
    );
  }
}
