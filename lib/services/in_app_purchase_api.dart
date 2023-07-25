import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurcahseApi {
  static String _apiKey = 'goog_qzUludmLrULijJAcZzSPJndjSsD';
  static init() async {
    // await Purchases.setDebugLogsEnabled(true);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      Offering? current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException {
      return [];
    }
  }

  static Future<bool> purchaseSubscription(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      log("--->${e.toString()}");
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    log('this is startinng');
    print(await Purchases.appUserID);
    print(await Purchases.isAnonymous);
    print(Purchases.collectDeviceIdentifiers());
    CustomerInfo info = await Purchases.restorePurchases();
    print(info.originalAppUserId);
    print(info.activeSubscriptions);
    print(info.originalApplicationVersion);
  }

  static updatePurchaseStatus() async {
    var customerInfo = await Purchases.getCustomerInfo();
    bool isActive = customerInfo.entitlements.all['all_features']!.isActive;
    if (isActive) {
      return true;
    } else {
      return false;
    }
  }
}
