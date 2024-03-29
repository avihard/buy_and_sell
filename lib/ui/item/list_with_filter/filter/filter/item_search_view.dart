import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/search_product_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_special_check_text_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/condition_of_item.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/viewobject/item_price_type.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:provider/provider.dart';

class ItemSearchView extends StatefulWidget {
  const ItemSearchView({
    @required this.productParameterHolder,
  });

  final ProductParameterHolder productParameterHolder;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<ItemSearchView> {
  ProductRepository repo1;
  SearchProductProvider _searchProductProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'home_search__search'),
        onPressed: () {
          if (userInputItemNameTextEditingController.text != null) {
            _searchProductProvider.productParameterHolder.searchTerm =
                userInputItemNameTextEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.searchTerm = '';
          }
          if (userInputMaximunPriceEditingController.text != null) {
            _searchProductProvider.productParameterHolder.maxPrice =
                userInputMaximunPriceEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.maxPrice = '';
          }
          if (userInputMinimumPriceEditingController.text != null) {
            _searchProductProvider.productParameterHolder.minPrice =
                userInputMinimumPriceEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.minPrice = '';
          }

          if (_searchProductProvider.itemTypeId != null) {
            _searchProductProvider.productParameterHolder.itemTypeId =
                _searchProductProvider.itemTypeId;
          }
          if (_searchProductProvider.itemConditionId != null) {
            _searchProductProvider.productParameterHolder.conditionOfItemId =
                _searchProductProvider.itemConditionId;
          }
          if (_searchProductProvider.itemPriceTypeId != null) {
            _searchProductProvider.productParameterHolder.itemPriceTypeId =
                _searchProductProvider.itemPriceTypeId;
          }
          if (_searchProductProvider.itemDealOptionId != null) {
            _searchProductProvider.productParameterHolder.dealOptionId =
                _searchProductProvider.itemDealOptionId;
          }

          print('userInputText' + userInputItemNameTextEditingController.text);

          Navigator.pop(context, _searchProductProvider.productParameterHolder);
        });

    repo1 = Provider.of<ProductRepository>(context);

    return PsWidgetWithAppBar<SearchProductProvider>(
        appBarTitle: Utils.getString(context, 'search__filter') ?? '',
        initProvider: () {
          return SearchProductProvider(repo: repo1);
        },
        onProviderReady: (SearchProductProvider provider) {
          _searchProductProvider = provider;
          _searchProductProvider.productParameterHolder =
              widget.productParameterHolder;

          userInputItemNameTextEditingController.text =
              widget.productParameterHolder.searchTerm;
          userInputMinimumPriceEditingController.text =
              widget.productParameterHolder.minPrice;
          userInputMaximunPriceEditingController.text =
              widget.productParameterHolder.maxPrice;
        },
        actions: <Widget>[
          IconButton(
              icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                  color: PsColors.mainColor),
              onPressed: () {
                print('Click Clear Button');
                userInputItemNameTextEditingController.text = '';
                userInputMaximunPriceEditingController.text = '';
                userInputMinimumPriceEditingController.text = '';
                _searchProductProvider.isfirstRatingClicked = false;
                _searchProductProvider.isSecondRatingClicked = false;
                _searchProductProvider.isThirdRatingClicked = false;
                _searchProductProvider.isfouthRatingClicked = false;
                _searchProductProvider.isFifthRatingClicked = false;

                _searchProductProvider.isSwitchedFeaturedProduct = false;
                _searchProductProvider.isSwitchedDiscountPrice = false;
                setState(() {});
              }),
        ],
        builder: (BuildContext context, SearchProductProvider provider,
            Widget child) {
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      _ProductNameWidget(
                        userInputItemNameTextEditingController:
                            userInputItemNameTextEditingController,
                      ),
                      _PriceWidget(
                        userInputMinimumPriceEditingController:
                            userInputMinimumPriceEditingController,
                        userInputMaximunPriceEditingController:
                            userInputMaximunPriceEditingController,
                      ),
                      PsDropdownBaseWidget(
                          title: Utils.getString(context, 'item_entry__type'),
                          selectedText: Provider.of<SearchProductProvider>(
                                  context,
                                  listen: false)
                              .selectedItemTypeName,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final SearchProductProvider provider =
                                Provider.of<SearchProductProvider>(context,
                                    listen: false);

                            final dynamic itemTypeResult =
                                await Navigator.pushNamed(
                                    context, RoutePaths.itemType);

                            if (itemTypeResult != null &&
                                itemTypeResult is ItemType) {
                              provider.itemTypeId = itemTypeResult.id;
                              setState(() {
                                provider.selectedItemTypeName =
                                    itemTypeResult.name;
                              });
                            }
                          }),
                      PsDropdownBaseWidget(
                          title: Utils.getString(
                              context, 'item_entry__item_condition'),
                          selectedText: Provider.of<SearchProductProvider>(
                                  context,
                                  listen: false)
                              .selectedItemConditionName,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final SearchProductProvider provider =
                                Provider.of<SearchProductProvider>(context,
                                    listen: false);

                            final dynamic itemConditionResult =
                                await Navigator.pushNamed(
                                    context, RoutePaths.itemCondition);

                            if (itemConditionResult != null &&
                                itemConditionResult is ConditionOfItem) {
                              provider.itemConditionId = itemConditionResult.id;

                              setState(() {
                                provider.selectedItemConditionName =
                                    itemConditionResult.name;
                              });
                            }
                          }),
                      PsDropdownBaseWidget(
                          title: Utils.getString(
                              context, 'item_entry__price_type'),
                          selectedText: Provider.of<SearchProductProvider>(
                                  context,
                                  listen: false)
                              .selectedItemPriceTypeName,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final SearchProductProvider provider =
                                Provider.of<SearchProductProvider>(context,
                                    listen: false);

                            final dynamic itemPriceTypeResult =
                                await Navigator.pushNamed(
                                    context, RoutePaths.itemPriceType);

                            if (itemPriceTypeResult != null &&
                                itemPriceTypeResult is ItemPriceType) {
                              provider.itemPriceTypeId = itemPriceTypeResult.id;

                              setState(() {
                                provider.selectedItemPriceTypeName =
                                    itemPriceTypeResult.name;
                              });
                            }
                          }),
                      PsDropdownBaseWidget(
                          title: Utils.getString(
                              context, 'item_entry__deal_option'),
                          selectedText: Provider.of<SearchProductProvider>(
                                  context,
                                  listen: false)
                              .selectedItemDealOptionName,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final SearchProductProvider provider =
                                Provider.of<SearchProductProvider>(context,
                                    listen: false);

                            final dynamic itemDealOptionResult =
                                await Navigator.pushNamed(
                                    context, RoutePaths.itemDealOption);

                            if (itemDealOptionResult != null &&
                                itemDealOptionResult is DealOption) {
                              provider.itemDealOptionId =
                                  itemDealOptionResult.id;

                              setState(() {
                                provider.selectedItemDealOptionName =
                                    itemDealOptionResult.name;
                              });
                            }
                          }),
                      // _RatingRangeWidget(),
                      // _SpecialCheckWidget(),

                      const Divider(
                        height: PsDimens.space1,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(PsDimens.space12),
                        child: Text(Utils.getString(context, 'filter__sorting'),
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                      InkWell(
                        child: SortingView(
                            image:
                                'assets/images/baesline_access_time_black_24.png',
                            titleText:
                                Utils.getString(context, 'item_filter__latest'),
                            checkImage: _searchProductProvider
                                        .productParameterHolder.orderBy ==
                                    PsConst.FILTERING__ADDED_DATE
                                ? 'assets/images/baseline_check_green_24.png'
                                : ''),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print('sort by latest product');
                          _searchProductProvider.productParameterHolder
                              .orderBy = PsConst.FILTERING__ADDED_DATE;
                          _searchProductProvider.productParameterHolder
                              .orderType = PsConst.FILTERING__DESC;

                          Navigator.pop(context,
                              _searchProductProvider.productParameterHolder);
                        },
                      ),
                      const Divider(
                        height: PsDimens.space1,
                      ),
                      InkWell(
                        child: SortingView(
                            image: 'assets/images/baseline_graph_black_24.png',
                            titleText: Utils.getString(
                                context, 'item_filter__popular'),
                            checkImage: _searchProductProvider
                                        .productParameterHolder.orderBy ==
                                    PsConst.FILTERING__TRENDING
                                ? 'assets/images/baseline_check_green_24.png'
                                : ''),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print('sort by popular product');
                          _searchProductProvider.productParameterHolder
                              .orderBy = PsConst.FILTERING_TRENDING;
                          _searchProductProvider.productParameterHolder
                              .orderType = PsConst.FILTERING__DESC;

                          Navigator.pop(context,
                              _searchProductProvider.productParameterHolder);
                        },
                      ),
                      const Divider(
                        height: PsDimens.space1,
                      ),
                      InkWell(
                        child: SortingView(
                            image:
                                'assets/images/baseline_price_down_black_24.png',
                            titleText: Utils.getString(context,
                                'item_filter__lowest_to_highest_letter'),
                            checkImage: _searchProductProvider
                                            .productParameterHolder.orderBy ==
                                        PsConst.FILTERING_NAME &&
                                    _searchProductProvider
                                            .productParameterHolder.orderType ==
                                        PsConst.FILTERING__ASC
                                ? 'assets/images/baseline_check_green_24.png'
                                : ''),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print('sort by lowest letter');
                          _searchProductProvider.productParameterHolder
                              .orderBy = PsConst.FILTERING_NAME;
                          _searchProductProvider.productParameterHolder
                              .orderType = PsConst.FILTERING__ASC;

                          Navigator.pop(context,
                              _searchProductProvider.productParameterHolder);
                        },
                      ),
                      const Divider(
                        height: PsDimens.space1,
                      ),
                      InkWell(
                        child: SortingView(
                            image:
                                'assets/images/baseline_price_up_black_24.png',
                            titleText: Utils.getString(context,
                                'item_filter__highest_to_lowest_letter'),
                            checkImage: _searchProductProvider
                                            .productParameterHolder.orderBy ==
                                        PsConst.FILTERING_NAME &&
                                    _searchProductProvider
                                            .productParameterHolder.orderType ==
                                        PsConst.FILTERING__DESC
                                ? 'assets/images/baseline_check_green_24.png'
                                : ''),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print('sort by highest letter ');
                          _searchProductProvider.productParameterHolder
                              .orderBy = PsConst.FILTERING_NAME;
                          _searchProductProvider.productParameterHolder
                              .orderType = PsConst.FILTERING__DESC;

                          Navigator.pop(context,
                              _searchProductProvider.productParameterHolder);
                        },
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space16,
                            top: PsDimens.space16,
                            right: PsDimens.space16,
                            bottom: PsDimens.space40),
                        child: _searchButtonWidget,
                      ),
                    ],
                  )),
                ),
              ),
            ],
          );
        });
  }
}

class SortingView extends StatefulWidget {
  const SortingView(
      {@required this.image,
      @required this.titleText,
      @required this.checkImage});

  final String titleText;
  final String image;
  final String checkImage;

  @override
  State<StatefulWidget> createState() => _SortingViewState();
}

class _SortingViewState extends State<SortingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: PsDimens.space60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Image.asset(
                  widget.image,
                  width: PsDimens.space24,
                  height: PsDimens.space24,
                ),
              ),
              const SizedBox(
                width: PsDimens.space10,
              ),
              Text(widget.titleText,
                  style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: PsDimens.space20, left: PsDimens.space20),
            child: widget.checkImage != ''
                ? Image.asset(
                    widget.checkImage,
                    width: PsDimens.space16,
                    height: PsDimens.space16,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

dynamic setAllRatingFalse(SearchProductProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _ProductNameWidget extends StatefulWidget {
  const _ProductNameWidget({this.userInputItemNameTextEditingController});
  final TextEditingController userInputItemNameTextEditingController;
  @override
  __ProductNameWidgetState createState() => __ProductNameWidgetState();
}

class __ProductNameWidgetState extends State<_ProductNameWidget> {
  @override
  Widget build(BuildContext context) {
    // final Widget _productTextWidget = Text(
    //     Utils.getString(context, 'home_search__product_name'),
    //     textAlign: TextAlign.left,
    //     style:
    //         Theme.of(context).textTheme.headline6.copyWith(fontSize: PsDimens.space16));

    // final Widget _productTextFieldWidget = TextField(
    //   controller: userInputItemNameTextEditingController,
    //   style: Theme.of(context).textTheme.bodyText1,
    //   decoration: InputDecoration(
    //       contentPadding: const EdgeInsets.all(PsDimens.space12),
    //       border: InputBorder.none,
    //       hintText: Utils.getString(context, 'home_search__not_set')),
    // );

    print('*****' + widget.userInputItemNameTextEditingController.text);
    return Column(
      children: <Widget>[
        // Container(
        //   margin: const EdgeInsets.only(left: PsDimens.space12, top: PsDimens.space12),
        //   alignment: Alignment.centerLeft,
        //   child: PsTextFieldWidget(
        //       titleText: Utils.getString(context, 'home_search__product_name'),
        //       hintText: Utils.getString(context, 'home_search__not_set'),
        //       textEditingController: userInputItemNameTextEditingController),
        // ),
        // Container(
        //   width: double.infinity,
        //   height: PsDimens.space44,
        //   margin: const EdgeInsets.all(PsDimens.space12),
        //   decoration: BoxDecoration(
        //     color: Utils.isLightMode(context)
        //         ? Colors.white60
        //         : Colors.black54,
        //     borderRadius: BorderRadius.circular(PsDimens.space4),
        //     border: Border.all(
        //         color: Utils.isLightMode(context)
        //             ? Colors.grey[200]
        //             : Colors.black87),
        //   ),
        //   child: _productTextFieldWidget,
        // ),
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'home_search__product_name'),
            hintText: Utils.getString(context, 'home_search__not_set'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
      ],
    );
  }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key key,
    @required this.title,
    @required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor = PsColors.backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: PsDimens.space104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : PsColors.mainColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? PsColors.iconColor : PsColors.white,
            ),
            const SizedBox(
              height: PsDimens.space2,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: checkColor ? PsColors.iconColor : PsColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context, listen: false);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        // isfirstRatingClicked = true;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        // isfirstRatingClicked = false;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Text(Utils.getString(context, 'home_search__rating_range'),
              style: Theme.of(context).textTheme.bodyText2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceWidget extends StatelessWidget {
  const _PriceWidget(
      {this.userInputMinimumPriceEditingController,
      this.userInputMaximunPriceEditingController});
  final TextEditingController userInputMinimumPriceEditingController;
  final TextEditingController userInputMaximunPriceEditingController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Text(Utils.getString(context, 'home_search__price'),
              style: Theme.of(context).textTheme.bodyText2),
        ),
        _PriceTextWidget(
          title: Utils.getString(context, 'home_search__lowest_price'),
          textField: TextField(
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: PsDimens.space8, bottom: PsDimens.space12),
              border: InputBorder.none,
              hintText: Utils.getString(context, 'home_search__not_set'),
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: PsColors.textPrimaryLightColor),
            ),
            keyboardType: TextInputType.number,
            controller: userInputMinimumPriceEditingController,
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        _PriceTextWidget(
          title: Utils.getString(context, 'home_search__highest_price'),
          textField: TextField(
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: PsDimens.space8, bottom: PsDimens.space12),
              border: InputBorder.none,
              hintText: Utils.getString(context, 'home_search__not_set'),
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: PsColors.textPrimaryLightColor),
            ),
            keyboardType: TextInputType.number,
            controller: userInputMaximunPriceEditingController,
          ),
        ),
      ],
    );
  }
}

class _PriceTextWidget extends StatelessWidget {
  const _PriceTextWidget({
    Key key,
    @required this.title,
    @required this.textField,
  }) : super(key: key);

  final String title;
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PsColors.mainDividerColor),
                ),
                width: PsDimens.space120,
                height: PsDimens.space36,
                child: textField),
          ],
        ),
      ),
    );
  }
}

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          width: double.infinity,
          child: Text(Utils.getString(context, 'home_search__special_check'),
              style: Theme.of(context).textTheme.bodyText2),
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__featured_product'),
            icon: FontAwesome5.gem,
            checkTitle: 1,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__discount_price'),
            icon: Feather.percent,
            checkTitle: 2,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
      ],
    );
  }
}
