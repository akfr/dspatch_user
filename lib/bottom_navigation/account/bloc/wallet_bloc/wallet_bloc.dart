import 'dart:math';

import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/base_list_response.dart';
import 'package:dspatch_user/models/order/get/payment.dart';
import 'package:dspatch_user/models/wallet_balance.dart';
import 'package:dspatch_user/models/wallet_transaction.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(LoadingWalletState());

  HomeRepository _repository = HomeRepository();
  CancelToken _cancelationToken;
  String _stripeTokenId;

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is FetchWalletEvent) {
      yield* _mapFetchWalletToState(event.pageNum);
    } else if (event is CancelWalletEvent) {
      if (_cancelationToken != null) {
        _cancelationToken.cancel("cancelled");
        _cancelationToken = null;
      }
    } else if (event is DepositWalletEvent) {
      yield* _mapDepositWalletToState(event);
    }
  }

  Stream<WalletState> _mapDepositWalletToState(
      DepositWalletEvent depositWalletEvent) async* {
    yield LoadingWalletState();
    try {
      if (depositWalletEvent.paymentMethod.slug == "stripe") {
        try {
          String stripePublishableKey =
              depositWalletEvent.paymentMethod.getMetaKey("public_key");
          // if (stripePublishableKey != null) {
          //   StripePayment.setOptions(
          //       StripeOptions(publishableKey: stripePublishableKey));
          //   Token token = await StripePayment.createTokenWithCard(CreditCard(
          //       number: depositWalletEvent.cardInfo.cardNumber,
          //       expMonth: depositWalletEvent.cardInfo.cardMonth,
          //       expYear: depositWalletEvent.cardInfo.cardYear,
          //       cvc: depositWalletEvent.cardInfo.cardCvv));
          //   if (token != null && token.tokenId != null) {
          //     _stripeTokenId = token.tokenId;
          //   } else {
          //     yield FailureWalletState("card_verification_fail");
          //   }
          //   yield* _depositWallet(
          //     depositWalletEvent.amount,
          //     depositWalletEvent.paymentMethod.slug,
          //   );
          // } else {
          //   yield FailureWalletState("payment_setup_fail");
          // }
        } catch (e) {
          print("StripePaymentError: $e");
          yield FailureWalletState("card_verification_fail");
        }
      } else if (depositWalletEvent.paymentMethod.slug == "payu") {
        try {
          String key =
              depositWalletEvent.paymentMethod.getMetaKey("public_key");
          String salt =
              depositWalletEvent.paymentMethod.getMetaKey("private_key");
          if (key != null && salt != null) {
            yield* _depositWallet(
              depositWalletEvent.amount,
              depositWalletEvent.paymentMethod.slug,
            );
          } else {
            yield FailureWalletState("payment_setup_fail");
          }
        } catch (e) {
          print("PayuPaymentError: $e");
          yield FailureWalletState("payment_setup_fail");
        }
      } else {
        yield* _depositWallet(
          depositWalletEvent.amount,
          depositWalletEvent.paymentMethod.slug,
        );
      }
    } catch (e) {
      print("_mapDepositWalletToState: $e");
      yield FailureWalletState("something_went_wrong");
    }
  }

  Stream<WalletState> _depositWallet(
      String amount, String paymentMethodSlug) async* {
    yield LoadingWalletState();
    try {
      Payment payment =
          await _repository.depositWallet(amount, paymentMethodSlug);
      UserInformation userInfo = await Helper().getUserMe();
      yield WalletDepositState(
        PaymentData(
          payment: payment,
          payuMeta: PayUMeta(
            name: userInfo.name.replaceAll(' ', ''),
            mobile: userInfo.mobileNumber.replaceAll(' ', ''),
            email: userInfo.email.replaceAll(' ', ''),
            bookingId: "${Random().nextInt(999) + 10}${payment.id}",
            productinfo: "Wallet Recharge",
          ),
          stripeTokenId: _stripeTokenId,
        ),
      );
    } catch (e) {
      print("depositWallet: $e");
      yield FailureWalletState("something_went_wrong");
    }
  }

  Stream<WalletState> _mapFetchWalletToState(int pageNum) async* {
    _cancelationToken = CancelToken();
    if (pageNum == null || pageNum == 1) {
      try {
        WalletBalance walletBalance =
            await _repository.getBalance(_cancelationToken);
        yield SuccessWalletBalanceState(walletBalance);
      } catch (e) {
        print(e);
        yield SuccessWalletBalanceState(WalletBalance(0));
      }
    }
    yield LoadingWalletState();
    try {
      BaseListResponse<WalletTransaction> walletTransactions =
          await _repository.walletTransactions(
              (pageNum != null && pageNum > 0) ? pageNum : 1,
              _cancelationToken);
      yield SuccessWalletTransactionsState(walletTransactions);
    } catch (e) {
      print(e);
      if (!(e is DioError && CancelToken.isCancel(e)))
        yield FailureWalletState(e);
    }
  }
}
