import 'dart:convert';
import 'dart:math';

import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/custom_delivery/custom_delivery.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:dspatch_user/models/payment_method/wallet_payment_response.dart';
import 'package:dspatch_user/models/wallet_balance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';
// import 'package:stripe_payment/stripe_payment.dart' as StripePayment;

import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  HomeRepository _repository = HomeRepository();

  String _sUrl, _fUrl, _currentPaymentMethod;
  String _stripeTokenId;

  PaymentBloc() : super(InitialPaymentState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is FetchPaymentEvent) {
      yield* _mapFetchPaymentToState(event.slugsToIgnore);
    } else if (event is InitPaymentProcessEvent) {
      yield* _mapInitPaymentProcessToState(event.paymentData);
    } else if (event is SetPaymentProcessedEvent) {
      yield* _mapSetPaymentProcessedToState(event.paid);
    } else if (event is CreateOrderEvent) {
      yield* _mapCreateOrderToState(event.createOrderRequest, event.cardInfo);
    }
  }

  Stream<PaymentState> _mapCreateOrderToState(
      createOrderRequest, cardInfo) async* {
    yield CreatingOrderState();
    if (createOrderRequest.paymentMethodSlug == "wallet") {
      try {
        WalletBalance walletBalance = await _repository.getBalance();
        if (createOrderRequest.deliveryModePrice > walletBalance.balance) {
          yield FailurePlaceOrderState("insufficient_wallet");
        } else {
          yield* _placeOrder(createOrderRequest);
        }
      } catch (e) {
        yield FailurePlaceOrderState("insufficient_wallet_verification");
      }
    } else if (createOrderRequest.paymentMethodSlug == "stripe") {
      try {
        // String stripePublishableKey =
        //     createOrderRequest.paymentMethod.getMetaKey("public_key");
        // if (stripePublishableKey != null) {
        //   StripePayment.StripePayment.setOptions(StripePayment.StripeOptions(
        //       publishableKey: stripePublishableKey));
        //   StripePayment.Token token =
        //       await StripePayment.StripePayment.createTokenWithCard(
        //           StripePayment.CreditCard(
        //               number: cardInfo.cardNumber,
        //               expMonth: cardInfo.cardMonth,
        //               expYear: cardInfo.cardYear,
        //               cvc: cardInfo.cardCvv));
        //   if (token != null && token.tokenId != null) {
        //     _stripeTokenId = token.tokenId;
        //   } else {
        //     yield FailurePlaceOrderState("card_verification_fail");
        //   }
        //   yield* _placeOrder(createOrderRequest);
        // } else {
        //   yield FailurePlaceOrderState("payment_setup_fail");
        // }
      } catch (e) {
        print("StripePaymentError: $e");
        yield FailurePlaceOrderState("card_verification_fail");
      }
    } else if (createOrderRequest.paymentMethodSlug == "payu") {
      try {
        String key = createOrderRequest.paymentMethod.getMetaKey("public_key");
        String salt =
            createOrderRequest.paymentMethod.getMetaKey("private_key");
        if (key != null && salt != null) {
          yield* _placeOrder(createOrderRequest);
        } else {
          yield FailurePlaceOrderState("payment_setup_fail");
        }
      } catch (e) {
        print("PayuPaymentError: $e");
        yield FailurePlaceOrderState("payment_setup_fail");
      }
    } else if (createOrderRequest.paymentMethodSlug == "cod") {
      yield* _placeOrder(createOrderRequest);
    } else {
      yield FailurePlaceOrderState("unsupported_payment_method");
    }
  }

  Stream<PaymentState> _placeOrder(state) async* {
    yield CreatingOrderState();
    try {
      CustomDelivery customDelivery = CustomDelivery(
        sourceContactName: state.pickupName,
        sourceContactNumber: state.pickNumber,
        sourceFormattedAddress: state.pickupAddress,
        sourceAddress1: state.pickupAddress,
        sourceLatitude: state.pickupLatLng.latitude.toString(),
        sourceLongitude: state.pickupLatLng.longitude.toString(),
        destinationContactName: state.dropName,
        destinationContactNumber: state.dropNumber,
        destinationFormattedAddress: state.dropAddress,
        destinationAddress1: state.dropAddress,
        destinationLatitude: state.dropLatLng.latitude.toString(),
        destinationLongitude: state.dropLatLng.longitude.toString(),
        paymentMethodSlug: state.paymentMethodSlug,
        notes: state.notes,
        meta: jsonEncode(state.metaData.toJson()),
        deliveryModeId: state.deliveryModeId,
      );
      OrderData orderData = await _repository.createCustomOrder(customDelivery);
      yield SuccessPlaceOrderState(
        PaymentData(
          payment: orderData.payment,
          payuMeta: PayUMeta(
            name: orderData.user.name.replaceAll(' ', ''),
            mobile: orderData.user.mobileNumber.replaceAll(' ', ''),
            email: orderData.user.email.replaceAll(' ', ''),
            bookingId: "${Random().nextInt(999) + 10}${orderData.id}",
            productinfo: "Custom Order",
          ),
          stripeTokenId: _stripeTokenId,
        ),
      );
    } catch (e) {
      print("placeOrder: $e");
      yield FailurePlaceOrderState("something_went_wrong");
    }
  }

  Stream<PaymentState> _mapFetchPaymentToState(
      [List<String> slugsToIgnore]) async* {
    yield LoadingPaymentState();
    try {
      List<PaymentMethod> listPayment = await _repository.getPaymentMethod();
      listPayment.removeWhere((element) => (element.enabled == null ||
          element.enabled != 1 ||
          (slugsToIgnore != null && slugsToIgnore.contains(element.slug))));
      yield SuccessPaymentState(listPayment);
    } catch (e) {
      yield FailurePaymentState(e);
    }
  }

  Stream<PaymentState> _mapInitPaymentProcessToState(
      PaymentData paymentData) async* {
    yield ProcessingPaymentState();
    _currentPaymentMethod = (paymentData.payment?.paymentMethod?.slug ?? "");
    switch (_currentPaymentMethod) {
      case "cod":
        yield ProcessedPaymentState(PaymentStatus(true, _currentPaymentMethod));
        break;
      case "wallet":
        try {
          WalletPaymentResponse walletPaymentResponse =
              await _repository.payThroughWallet(paymentData.payment?.id ?? -1);
          yield ProcessedPaymentState(PaymentStatus(
              walletPaymentResponse.success, _currentPaymentMethod));
        } catch (e) {
          print("processPayment wallet $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "stripe":
        try {
          WalletPaymentResponse walletPaymentResponse =
              await _repository.payThroughStripe(
                  paymentData.payment?.id ?? -1, paymentData.stripeTokenId);
          yield ProcessedPaymentState(PaymentStatus(
              walletPaymentResponse.success, _currentPaymentMethod));
        } catch (e) {
          print("processPayment stripe $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "payu":
        try {
          String key =
              paymentData.payment.paymentMethod.getMetaKey("public_key");
          String salt =
              paymentData.payment.paymentMethod.getMetaKey("private_key");
          if (key != null && salt != null) {
            String name = paymentData.payuMeta.name;
            String mobile = paymentData.payuMeta.mobile;
            String email = paymentData.payuMeta.email;
            String bookingId = paymentData.payuMeta.bookingId;
            String productinfo = paymentData.payuMeta.productinfo;
            String amt = "${paymentData.payment.amount}";
            String checksum = key +
                "|" +
                bookingId +
                "|" +
                amt +
                "|" +
                productinfo +
                "|" +
                name +
                "|" +
                email +
                '|||||||||||' +
                salt;
            var bytes = utf8.encode(checksum);
            Digest sha512Result = sha512.convert(bytes);
            String encrypttext = sha512Result.toString();
            String furl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=failed";
            String surl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=success";

            String url =
                "${AppConfig.baseUrl}assets/vendor/payment/payumoney/payuBiz.html?amt=$amt&name=$name&mobileNo=$mobile&email=$email&bookingId=$bookingId&productinfo=$productinfo&hash=$encrypttext&salt=$salt&key=$key&furl=$furl&surl=$surl";
            _sUrl = surl;
            _fUrl = furl;
            yield LoadPaymentUrlState(url, surl, furl);
          } else {
            yield ProcessedPaymentState(
                PaymentStatus(false, _currentPaymentMethod));
          }
        } catch (e) {
          print("processPayment payu $e");
          yield ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod));
        }
        break;
      case "paystack":
        String url =
            "${AppConfig.baseUrl}api/payment/paystack/${paymentData.payment.id}";
        _sUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=success";
        _fUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=error";
        yield LoadPaymentUrlState(url, _sUrl, _fUrl);
        break;
      default:
        print("processPayment unknown payment method");
        yield ProcessedPaymentState(
            PaymentStatus(false, _currentPaymentMethod));
        break;
    }
  }

  Stream<PaymentState> _mapSetPaymentProcessedToState(bool paid) async* {
    yield ProcessingPaymentState();
    if (!paid && _currentPaymentMethod != null && _fUrl != null) {
      if (_currentPaymentMethod == "payu")
        await _repository.postUrl(_fUrl);
      else if (_currentPaymentMethod == "paystack")
        await _repository.getUrl(_fUrl);
    }
    yield ProcessedPaymentState(PaymentStatus(paid, _currentPaymentMethod));
  }
}
