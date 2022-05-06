import 'package:dspatch_user/arrange_delivery/ui/arrange_delivery.dart';
import 'package:dspatch_user/arrange_delivery/ui/measurement.dart';
import 'package:dspatch_user/bottom_navigation/account/language_page.dart';
import 'package:dspatch_user/bottom_navigation/account/privacyPolicy.dart';
import 'package:dspatch_user/bottom_navigation/account/saved_address_page.dart';
import 'package:dspatch_user/bottom_navigation/account/tnc_page.dart';
import 'package:dspatch_user/bottom_navigation/account/wallet_transactions_page.dart';
import 'package:dspatch_user/bottom_navigation/bottom_navigation.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/ui/my_deliveries.dart';
import 'package:dspatch_user/payment/payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageRoutes {
  // static const String trackDelivery = 'track_delivery';
  static const String savedAddressesPage = 'saved_addresses_page';

  // static const String contactUsPage = 'contact_us_page';
  static const String tncPage = 'terms_conditions';
  static const String languagePage = 'language_page';
  static const String privacyPolicy = 'privacy_policy';
  static const String bottomNavigation = 'bottom_navigation';
  static const String deliverypickupLocation = 'deliverypickup_location';
  static const String deliverydropLocation = 'deliverydrop_location';
  static const String courierInfo = 'courier_info';
  static const String deliveryconfirmInfo = 'deliveryconfirm_info';
  static const String measurement = 'measurement';
  static const String deliveries = 'my_deliveries';
  static const String myProfilePage = 'my_profile_page';
  static const String arrangeDeliveryPage = 'arrange_delivery_page';

  // static const String getFoodDeliveredPage = 'get_food_delivered_page';
  static const String earningsPage = 'earnings_page';

  Map<String, WidgetBuilder> routes() {
    return {
      // trackDelivery: (context) => TrackDeliveryBody(),
      savedAddressesPage: (context) => SavedAddressesPage(),
      // contactUsPage: (context) => ContactUsPage(),
      tncPage: (context) => TncPage(),
      privacyPolicy: (context) => PrivacyPolicyPage(),
      deliveries: (context) => MyDeliveriesPage(),
      bottomNavigation: (context) => BottomNavigation(),
      measurement: (context) => Measurement(),
      // myProfilePage: (context) => MyProfilePage(),
      arrangeDeliveryPage: (context) => ArrangeDeliveryPage(),
      // getFoodDeliveredPage: (context) => GetFoodDeliveredPage(),
      earningsPage: (context) => WalletTransactionsPage(),
      languagePage: (context) => LanguagePage(),
    };
  }
}
