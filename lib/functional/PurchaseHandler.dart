import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class PurchaseHandler {
  static FlutterInappPurchase _inAppPurchase = FlutterInappPurchase.instance;

  static bool _available = false;

  static List<String> _ids = [
    "buy_credits_10",
    "buy_credits_50",
    "buy_credits_200",
  ];

  static bool _isLoading = false;
  static List<IAPItem> _productsDetails = [];

  static StreamSubscription<PurchasedItem?>? _subscription;

  static Future<void> reset() async {
    _available = false;
    _isLoading = false;
    _productsDetails = [];
    await _subscription?.cancel();
    _subscription = null;
  }

  static Future<void> initialize() async {
    try {
      await FlutterInappPurchase.instance.initialize();
    } catch (e) {
      if (kDebugMode) print("ERROR: $e");
    }
    _available = await FlutterInappPurchase.instance.isReady();
  }

  static void subscribeToPurchaseUpdates() {
    if (!_available) return;

    _subscription = FlutterInappPurchase.purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () async {
        await _reSubscribeToPurchaseUpdates();
      },
      onError: (e) async {
        if (kDebugMode) print(e);
        await _reSubscribeToPurchaseUpdates();
      },
    );
  }

  static Future<void> _reSubscribeToPurchaseUpdates() async {
    await Future.delayed(Duration(seconds: 1));
    await _subscription?.cancel();
    subscribeToPurchaseUpdates();
  }

  static Future<void> _onPurchaseUpdate(PurchasedItem? purchasedItem) async {
    if (purchasedItem == null) return;
    if (purchasedItem.transactionReceipt == null) return;
    if (purchasedItem.purchaseStateAndroid != PurchaseState.purchased) return;
    try {
      await _validatePurchase(purchasedItem);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static Future<void> _validatePurchase(PurchasedItem item) async {
    try {
      bool ready = await Api.ping();
      if (!ready) return;

      await _inAppPurchase.finishTransaction(
        item,
        isConsumable: true,
      );
      await Api.validateReceipt(
        Map<String, dynamic>.from(json.decode(item.transactionReceipt!)),
      );

      await blocManager.userBloc.refresh(
        maxCredits: Api.maxCredits,
        creditGainPeriod: Api.creditGainPeriod,
      );

      Common.showSnackbar(
          "Les crédits liés à votre dernier achat ont été ajoutés");
    } catch (e) {
      if (kDebugMode) print("_validatePurchase: $e");
    }
  }

  static Future<void> validatePastTransactions() async {
    List<PurchasedItem> items;
    try {
      items = (await _inAppPurchase.getAvailablePurchases())!;
    } catch (e) {
      if (kDebugMode) print(e);
      return;
    }

    if (kDebugMode) print("items: ${items.length}");
    try {
      await Future.wait(items.map((item) => _onPurchaseUpdate(item)));
    } catch (e) {
      if (kDebugMode) print(e);
      return;
    }
  }

  static Future<List<IAPItem>> getProductsDetails() async {
    if (!_available) return _productsDetails;

    while (_isLoading) {
      await Future.delayed(Duration(milliseconds: 50));
    }

    if (_productsDetails.isNotEmpty) return _productsDetails;

    _isLoading = true;

    try {
      List<IAPItem> response = await _inAppPurchase.getProducts(_ids);

      _productsDetails = [...response];
      _isLoading = false;
      return _productsDetails;
    } catch (e) {
      if (kDebugMode) print("error getProductsDetails: $e");
      _isLoading = false;
      return _productsDetails;
    }
  }

  static Future<bool> buy(IAPItem item) async {
    return await _inAppPurchase.requestPurchase(
      item.productId!,
      obfuscatedAccountId: blocManager.userBloc.userId,
    );
  }
}
