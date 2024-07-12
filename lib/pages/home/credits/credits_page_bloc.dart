import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/PurchaseHandler.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/utils/Common.dart';

class CreditsPageData {
  List<IAPItem> productsDetails = [];

  IAPItem? productDetailsById(String id) {
    int index = productsDetails.indexWhere((p) => p.productId == id);
    if (index == -1) return null;
    return productsDetails[index];
  }
}

class CreditsPageBloc extends Bloc<CreditsPageData> {
  CreditsPageBloc() : super(CreditsPageData()) {
    _getProductsDetails();
  }

  Future<void> _getProductsDetails() async {
    blocData.productsDetails = await PurchaseHandler.getProductsDetails();
    updateUI();
  }

  Future<void> buyProduct(IAPItem productDetails) async {
    try {
      await PurchaseHandler.buy(productDetails);
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }

  void showAdsUnfound() {
    Common.showSnackbar("Les publicités sont indisponibles pour le moment");
  }

  void showMissingGoogleAccount() {
    Common.showSnackbar(
        "Connectez un compte Google sur votre téléphone pour faire un achat");
  }

  Future<void> showAd() async {
    try {
      String? orderId = await blocManager.adsBloc.showAd();
      if (orderId != null) {
        blocManager.adsBloc.adCheckRetreiver(orderId);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }
}
