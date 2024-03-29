import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class ItemEntryProvider extends PsProvider {
  ItemEntryProvider(
      {@required ProductRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('Item Entry Provider: $hashCode');

    itemListStream = StreamController<PsResource<Product>>.broadcast();
    subscription = itemListStream.stream.listen((PsResource<Product> resource) {
      if (resource != null && resource.data != null) {
        _itemEntry = resource;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ProductRepository _repo;
  PsValueHolder psValueHolder;
  PsResource<Product> _itemEntry =
      PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get item => _itemEntry;

  StreamSubscription<PsResource<Product>> subscription;
  StreamController<PsResource<Product>> itemListStream;

  // String selectedCategoryName = '';
  // String selectedSubCategoryName = '';
  // String selectedItemTypeName = '';
  // String selectedItemConditionName = '';
  // String selectedItemPriceTypeName = '';
  // String selectedItemCurrencySymbol = '';
  // String selectedItemLocation = '';
  // String selectedItemDealOption = '';
  String categoryId = '';
  String subCategoryId = '';
  String itemTypeId = '';
  String itemConditionId = '';
  String itemPriceTypeId = '';
  String itemCurrencyId = '';
  String itemDealOptionId = '';
  String itemLocationId = '';
  bool isCheckBoxSelect = true;
  String checkOrNotShop = '1';
  String itemId = '';

  // Existing Image Id
  String firstImageId = '';
  String secondImageId = '';
  String thirdImageId = '';
  String fourthImageId = '';
  String fiveImageId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Entry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemEntry(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemEntry = await _repo.postItemEntry(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemEntry;
    // return null;
  }

  Future<dynamic> getItemFromDB(String itemId) async {
    isLoading = true;

    await _repo.getItemFromDB(
        itemId, itemListStream, PsStatus.PROGRESS_LOADING);
  }
}
