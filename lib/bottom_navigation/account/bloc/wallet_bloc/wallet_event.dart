import 'package:dspatch_user/components/card_picker.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchWalletEvent extends WalletEvent {
  final int pageNum;

  FetchWalletEvent(this.pageNum);

  @override
  List<Object> get props => [pageNum];
}

class CancelWalletEvent extends WalletEvent {
  @override
  List<Object> get props => [];
}

class DepositWalletEvent extends WalletEvent {
  final String amount;
  final PaymentMethod paymentMethod;
  final CardInfo cardInfo;

  DepositWalletEvent(this.amount, this.paymentMethod, this.cardInfo);

  @override
  List<Object> get props => [amount, paymentMethod, this.cardInfo];

  @override
  bool get stringify => true;
}
