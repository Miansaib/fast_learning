import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchaseController extends GetxController {
  bool isPremium = true;

  Future<bool> updatePurchaseStatus() async {
    return true;
    try {
      var customerInfo = await Purchases.getCustomerInfo();
      print(customerInfo.latestExpirationDate);
      bool? isActive = customerInfo.entitlements.all['all_features']?.isActive;
      if (isActive == null) {
        customerInfo = await Purchases.restorePurchases();
        isActive = customerInfo.entitlements.all['all_features']?.isActive;
      }
      if (isActive == true) {
        print('yes there is');
        isPremium = true;

        return true;
      } else {
        isPremium = false;

        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
