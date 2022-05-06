import 'dart:async';

import 'package:dspatch_user/config/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getTranslationOf(String key) {
    return AppConfig.languagesSupported[locale.languageCode].values[key] != null
        ? AppConfig.languagesSupported[locale.languageCode].values[key]
        : AppConfig.languagesSupported[AppConfig.languageDefault].values[key] !=
                null
            ? AppConfig
                .languagesSupported[AppConfig.languageDefault].values[key]
            : key;
  }

  static List<Locale> getSupportedLocales() {
    List<Locale> toReturn = [];
    for (String langCode in AppConfig.languagesSupported.keys)
      toReturn.add(Locale(langCode));
    return toReturn;
  }

  String get bodyText1 {
    return getTranslationOf('bodyText1');
  }

  String get bodyText2 {
    return getTranslationOf('bodyText2');
  }

  String get phoneText {
    return getTranslationOf('phoneText');
  }

  String get passWordText {
    return getTranslationOf('passWordText');
  }

  String get contactNumber {
    return getTranslationOf('contactNumber');
  }

  String get continueText {
    return getTranslationOf('continueText');
  }

  String get viewProfile {
    return getTranslationOf('viewProfile');
  }

  String get foodText {
    return getTranslationOf('foodText');
  }

  String get orders_past {
    return getTranslationOf('orders_past');
  }

  String get saveAddress {
    return getTranslationOf('saveAddress');
  }

  String get contactUs {
    return getTranslationOf('contactUs');
  }

  String get contactQuery {
    return getTranslationOf('contactQuery');
  }

  String get customText {
    return getTranslationOf('customText');
  }

  String get homeText {
    return getTranslationOf('homeText');
  }

  String get orderText {
    return getTranslationOf('orderText');
  }

  String get accountText {
    return getTranslationOf('accountText');
  }

  String get myAccount {
    return getTranslationOf('myAccount');
  }

  String get savedAddresses {
    return getTranslationOf('savedAddresses');
  }

  String get tnc {
    return getTranslationOf('tnc');
  }

  String get knowtnc {
    return getTranslationOf('knowtnc');
  }

  String get shareApp {
    return getTranslationOf('shareApp');
  }

  String get shareFriends {
    return getTranslationOf('shareFriends');
  }

  String get loggingout {
    return getTranslationOf('loggingout');
  }

  String get sureText {
    return getTranslationOf('sureText');
  }

  String get no {
    return getTranslationOf('no');
  }

  String get yes {
    return getTranslationOf('yes');
  }

  String get signoutAccount {
    return getTranslationOf('signoutAccount');
  }

  String get myProfile {
    return getTranslationOf('myProfile');
  }

  String get courierInfo {
    return getTranslationOf('courierInfo');
  }

  String get courierType {
    return getTranslationOf('courierType');
  }

  String get envelope {
    return getTranslationOf('envelope');
  }

  String get boxPack {
    return getTranslationOf('boxPack');
  }

  String get other {
    return getTranslationOf('other');
  }

  String get height {
    return getTranslationOf('height');
  }

  String get width {
    return getTranslationOf('width');
  }

  String get length {
    return getTranslationOf('length');
  }

  String get weight {
    return getTranslationOf('weight');
  }

  String get update {
    return getTranslationOf('update');
  }

  String get wallet_subtitle {
    return getTranslationOf('wallet_subtitle');
  }

  String get selectDelivery {
    return getTranslationOf('selectDelivery');
  }

  String get ecoDelivery {
    return getTranslationOf('ecoDelivery');
  }

  String get delivMode {
    return getTranslationOf('delivMode');
  }

  String get courierInput {
    return getTranslationOf('courierInput');
  }

  String get courierDetail {
    return getTranslationOf('courierDetail');
  }

  String get proceedPayment {
    return getTranslationOf('proceedPayment');
  }

  String get confirmInfo {
    return getTranslationOf('confirmInfo');
  }

  String get distance {
    return getTranslationOf('distance');
  }

  String get viewMap {
    return getTranslationOf('viewMap');
  }

  String get ecoTime {
    return getTranslationOf('ecoTime');
  }

  String get dropLocation {
    return getTranslationOf('dropLocation');
  }

  String get dropHint {
    return getTranslationOf('dropHint');
  }

  String get landmark {
    return getTranslationOf('landmark');
  }

  String get namePerson {
    return getTranslationOf('namePerson');
  }

  String get pickupLoc {
    return getTranslationOf('pickupLoc');
  }

  String get pickupHint {
    return getTranslationOf('pickupHint');
  }

  String get recentSearch {
    return getTranslationOf('recentSearch');
  }

  String get measurement {
    return getTranslationOf('measurement');
  }

  String get paymentMode {
    return getTranslationOf('paymentMode');
  }

  String get done {
    return getTranslationOf('done');
  }

  String get amountPay {
    return getTranslationOf('amountPay');
  }

  String get pickupAssigned {
    return getTranslationOf('pickupAssigned');
  }

  String get pickupArranged {
    return getTranslationOf('pickupArranged');
  }

  String get thanksText {
    return getTranslationOf('thanksText');
  }

  String get trackCourier {
    return getTranslationOf('trackCourier');
  }

  String get arrangeDeliv {
    return getTranslationOf('arrangeDeliv');
  }

  String get arrangeDelivText {
    return getTranslationOf('arrangeDelivText');
  }

  String get getFood {
    return getTranslationOf('getFood');
  }

  String get getFoodText {
    return getTranslationOf('getFoodText');
  }

  String get getGrocery {
    return getTranslationOf('getGrocery');
  }

  String get getGroceryText {
    return getTranslationOf('getGroceryText');
  }

  String get promo {
    return getTranslationOf('promo');
  }

  String get courier {
    return getTranslationOf('courier');
  }

  String get delivInfo {
    return getTranslationOf('delivInfo');
  }

  String get myDeliv {
    return getTranslationOf('myDeliv');
  }

  String get orders_pending {
    return getTranslationOf('orders_pending');
  }

  String get grocery {
    return getTranslationOf('grocery');
  }

  String get delivered {
    return getTranslationOf('delivered');
  }

  String get feedbackText {
    return getTranslationOf('feedbackText');
  }

  String get yourMessage {
    return getTranslationOf('yourMessage');
  }

  String get entermsg {
    return getTranslationOf('entermsg');
  }

  String get sendmsg {
    return getTranslationOf('sendmsg');
  }

  String get foodInfo {
    return getTranslationOf('foodInfo');
  }

  String get addFood {
    return getTranslationOf('addFood');
  }

  String get addItem {
    return getTranslationOf('addItem');
  }

  String get addMore {
    return getTranslationOf('addMore');
  }

  String get addinfo {
    return getTranslationOf('addinfo');
  }

  String get addinfoInput {
    return getTranslationOf('addinfoInput');
  }

  String get availableText {
    return getTranslationOf('availableText');
  }

  String get delivCall {
    return getTranslationOf('delivCall');
  }

  String get delivCharges {
    return getTranslationOf('delivCharges');
  }

  String get restaurant {
    return getTranslationOf('restaurant');
  }

  String get searchRes {
    return getTranslationOf('searchRes');
  }

  String get nameRes {
    return getTranslationOf('nameRes');
  }

  String get groceryItem {
    return getTranslationOf('groceryItem');
  }

  String get addGrocery {
    return getTranslationOf('addGrocery');
  }

  String get addFresh {
    return getTranslationOf('addFresh');
  }

  String get groceryStore {
    return getTranslationOf('groceryStore');
  }

  String get searchStore {
    return getTranslationOf('searchStore');
  }

  String get nameStore {
    return getTranslationOf('nameStore');
  }

  String get support {
    return getTranslationOf('support');
  }

  String get aboutUs {
    return getTranslationOf('aboutUs');
  }

  String get logout {
    return getTranslationOf('logout');
  }

  String get signIn {
    return getTranslationOf('signIn');
  }

  String get countryText {
    return getTranslationOf('countryText');
  }

  String get nameText {
    return getTranslationOf('nameText');
  }

  String get verificationText {
    return getTranslationOf('verificationText');
  }

  String get checkPhoneNetwork {
    return getTranslationOf('checkPhoneNetwork');
  }

  String get invalidOTP {
    return getTranslationOf('invalidOTP');
  }

  String get enterOTP {
    return getTranslationOf('enterOTP');
  }

  String get otpText {
    return getTranslationOf('otpText');
  }

  String get otpText1 {
    return getTranslationOf('otpText1');
  }

  String get submitText {
    return getTranslationOf('submitText');
  }

  String get resendText {
    return getTranslationOf('resendText');
  }

  String get phoneHint {
    return getTranslationOf('phoneHint');
  }

  String get emailText {
    return getTranslationOf('emailText');
  }

  String get emailHint {
    return getTranslationOf('emailHint');
  }

  String get nameHint {
    return getTranslationOf('nameHint');
  }

  String get signinOTP {
    return getTranslationOf('signinOTP');
  }

  String get orContinue {
    return getTranslationOf('orContinue');
  }

  String get facebook {
    return getTranslationOf('facebook');
  }

  String get google {
    return getTranslationOf('google');
  }

  String get apple {
    return getTranslationOf('apple');
  }

  String get networkError {
    return getTranslationOf('networkError');
  }

  String get invalidNumber {
    return getTranslationOf('invalidNumber');
  }

  String get invalidName {
    return getTranslationOf('invalidName');
  }

  String get invalidEmail {
    return getTranslationOf('invalidEmail');
  }

  String get invalidNameEmail {
    return getTranslationOf('invalidNameEmail');
  }

  String get signinfailed {
    return getTranslationOf('signinfailed');
  }

  String get socialText {
    return getTranslationOf('socialText');
  }

  String get registerText {
    return getTranslationOf('registerText');
  }

  String get selectCountryFromList {
    return getTranslationOf('selectCountryFromList');
  }

  String get cm {
    return getTranslationOf('cm');
  }

  String get kg {
    return getTranslationOf('kg');
  }

  String get frangible {
    return getTranslationOf('frangible');
  }

  String get economyDelivery {
    return getTranslationOf('economyDelivery');
  }

  String get comment1 {
    return getTranslationOf('comment1');
  }

  String get deluxDelivery {
    return getTranslationOf('deluxDelivery');
  }

  String get comment2 {
    return getTranslationOf('comment2');
  }

  String get premiumDelivery {
    return getTranslationOf('premiumDelivery');
  }

  String get comment3 {
    return getTranslationOf('comment3');
  }

  String get cityGarden {
    return getTranslationOf('cityGarden');
  }

  String get boxCourier {
    return getTranslationOf('boxCourier');
  }

  String get comment4 {
    return getTranslationOf('comment4');
  }

  String get cashonPickup {
    return getTranslationOf('cashonPickup');
  }

  String get payWhilePickDelivery {
    return getTranslationOf('payWhilePickDelivery');
  }

  String get cashonDelivery {
    return getTranslationOf('cashonDelivery');
  }

  String get paywhileDropDelivery {
    return getTranslationOf('paywhileDropDelivery');
  }

  String get payPal {
    return getTranslationOf('payPal');
  }

  String get payPayPalAccount {
    return getTranslationOf('payPayPalAccount');
  }

  String get stripe {
    return getTranslationOf('stripe');
  }

  String get payStripeAccount {
    return getTranslationOf('payStripeAccount');
  }

  String get usuallyDeliveryin1hour {
    return getTranslationOf('usuallyDeliveryin1hour');
  }

  String get assured45minutesDelivery {
    return getTranslationOf('assured45minutesDelivery');
  }

  String get dedicatedDeliveryBoyDeliverin2530minutes {
    return getTranslationOf(
        "dedicatedDeliveryBoyDeliverin2530minutesusuallyDeliveryin1hour");
  }

  String get packofEverydayMilk {
    return getTranslationOf('packofEverydayMilk');
  }

  String get frozenChickenPack {
    return getTranslationOf('frozenChickenPack');
  }

  String get coconutOil500 {
    return getTranslationOf('coconutOil500');
  }

  String get keepFrozenChicken {
    return getTranslationOf('keepFrozenChicken');
  }

  String get orderFromUs20Discounts {
    return getTranslationOf('orderFromUs20Discounts');
  }

  String get orderFromUsWepaydeliveryCharge {
    return getTranslationOf("orderFromUsWepaydeliveryCharge");
  }

  String get cityGroceryStore {
    return getTranslationOf('cityGroceryStore');
  }

  String get wayToDeliver {
    return getTranslationOf('wayToDeliver');
  }

  String get office {
    return getTranslationOf('office');
  }

  String get deliveryMan {
    return getTranslationOf('deliveryMan');
  }

  String get paymentViaCashonPickup {
    return getTranslationOf('paymentViaCashonPickup');
  }

  String get companyPrivacyPolicy {
    return getTranslationOf('companyPrivacyPolicy');
  }

  String get hey {
    return getTranslationOf('hey');
  }

  String get makelessSpicyWithLessgravy {
    return getTranslationOf('makelessSpicyWithLessgravy');
  }

  String get enterFullName {
    return getTranslationOf('enterFullName');
  }

  String get fullName {
    return getTranslationOf('fullName');
  }

  String get enterLandmark {
    return getTranslationOf('enterLandmark');
  }

  String get saveAddress2 {
    return getTranslationOf('saveAddress2');
  }

  String get heightWidthLength {
    return getTranslationOf('heightWidthLength');
  }

  String get vegSandwich {
    return getTranslationOf('vegSandwich');
  }

  String get farmPizza {
    return getTranslationOf('farmPizza');
  }

  String get chickenSoup {
    return getTranslationOf('chickenSoup');
  }

  String get privacyPolicy {
    return getTranslationOf('privacyPolicy');
  }

  String get economyText {
    return getTranslationOf('economyText');
  }

  String get paidvia {
    return getTranslationOf('paidvia');
  }

  String get earned {
    return getTranslationOf('earned');
  }

  String get change_language {
    return getTranslationOf('change_language');
  }

  String get change_language_desc {
    return getTranslationOf('change_language_desc');
  }

  String get courierText {
    return getTranslationOf('courierText');
  }

  String get groceryText {
    return getTranslationOf('groceryText');
  }

  String get express {
    return getTranslationOf('express');
  }

  String get earnings {
    return getTranslationOf('earnings');
  }

  String get recentTrans {
    return getTranslationOf('recentTrans');
  }

  String get wallet {
    return getTranslationOf('wallet');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppConfig.languagesSupported.keys.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
