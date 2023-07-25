import 'dart:developer';

import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/services/in_app_purchase_api.dart';
import 'package:Fast_learning/widgets/custom_elevated_button.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class BuySubscriptionPage extends StatefulWidget {
  const BuySubscriptionPage({super.key});

  @override
  State<BuySubscriptionPage> createState() => _BuySubscriptionPageState();
}

class _BuySubscriptionPageState extends State<BuySubscriptionPage> {
  List<Package> packages = [];
  bool isMonthlySelected = true;
  @override
  void initState() {
    super.initState();

    init();
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      Get.put(InAppPurchaseController()).updatePurchaseStatus();
    });
  }

  init() async {
    var offerings = await InAppPurcahseApi.fetchOffers();
    packages = offerings
        .map((offer) => offer.availablePackages)
        .expand((package) => package)
        .toList();
    for (var item in packages) {
      print(item);
    }
    print(packages);
    setState(() {});
  }

  purchase() async {
    Get.dialog(Center(
        child:
            CircularProgressIndicator(color: Theme.of(context).primaryColor)));
    bool success = await InAppPurcahseApi.purchaseSubscription(
        packages[isMonthlySelected ? 0 : 1]);

    log("--------->@purchase success: $success");
    if (success) {
      Get.snackbar(
        'Congratulations',
        'You\'ve successfully purchased the subscription',
      );
      if (mounted) {
        Get.close(1);
      }
    } else {
      Get.back();
    }
  }

  String get getChargesDate {
    DateTime time = DateTime.now().add(Duration(days: 7));
    return DateFormat('MMMM dd, yyyy').format(time);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    Get.close(1);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Get Unlimited Access',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 40),
              packages.isEmpty ? CircularProgressIndicator() : Container(),
              ...List.generate(
                packages.length,
                (index) {
                  var product = packages[index].storeProduct;
                  product.introductoryPrice;
                  bool isMonthly =
                      packages[index].packageType == PackageType.monthly;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Badge(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      badgeColor: Colors.redAccent,
                      position: BadgePosition.topStart(
                          top: -15, start: size.width / 4.4),
                      shape: BadgeShape.square,
                      badgeContent: Text('3 day free trial'),
                      child: CustomElevatedButton(
                        onPressed: () async {
                          if (isMonthly) {
                            setState(() {
                              isMonthlySelected = true;
                            });
                          } else {
                            setState(() {
                              isMonthlySelected = false;
                            });
                          }
                        },
                        title1: (isMonthly
                            ? [
                                '1 month ',
                                '${product.currencyCode} ${double.parse((product.price).toStringAsFixed(2))}'
                              ]
                            : [
                                '12 months ',
                                '${product.currencyCode} ${double.parse((product.price).toStringAsFixed(2))}'
                              ]),
                        title2: isMonthly
                            ? null
                            : '${product.currencyCode}${double.parse((product.price / 12).toStringAsFixed(2))} / Month',
                        isSelected:
                            isMonthly ? isMonthlySelected : !isMonthlySelected,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                  onPressed: purchase, title1: ['Start Free trial']),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Builder(builder: (context) {
                  final date = DateTime.now().add(Duration(days: 3));
                  // ignore: unnecessary_statements
                  """
              Your monthly or annual subscription automatically renews for the same term unless cancelled at least 24 hours prior to the end of the current term. Cancel any time in Google Play at no additional cont; your subscription will then cease at the end of the current term.
              """;
                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),

                      children: <TextSpan>[
                        TextSpan(
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(.9)),
                            text:
                                'Your monthly or annual subscription automatically renews for the same term unless canceled at least 24 hours prior to the end of the current term. Cancel any time in Google Play at no additional cost; your subscription will then cease at the end of the current term.'),
                        // TextSpan(
                        //     text: 'The trial will automatically change to '),
                        // TextSpan(
                        //     text:
                        //         isMonthlySelected ? 'a monthly' : 'an annual'),
                        // TextSpan(text: ' plan on '),
                        // TextSpan(
                        //     text: DateFormat.yMMMMd('en_US').format(date),
                        //     style:
                        //         const TextStyle(fontWeight: FontWeight.bold)),
                        // TextSpan(
                        //     text: ' unless you cancel 24 hours in advance.'),
                      ],
                    ),
                  );
                  // return Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     "The trial will automatically change to an annual plan on ${} unless you cancel 24 hours in advance.",
                  //     textAlign: TextAlign.center,
                  //   ),
                  // );
                }),
              )
            ],
          )),
    );
  }
}
