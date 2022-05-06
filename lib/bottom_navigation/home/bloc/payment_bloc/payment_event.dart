import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/components/card_picker.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CreateOrderEvent extends PaymentEvent {
  final createOrderRequest;
  final CardInfo cardInfo;
  CreateOrderEvent(this.createOrderRequest, this.cardInfo);
  @override
  List<Object> get props => [createOrderRequest, cardInfo];
}

class FetchPaymentEvent extends PaymentEvent {
  final List<String> slugsToIgnore;
  FetchPaymentEvent([this.slugsToIgnore]);
  @override
  List<Object> get props => [slugsToIgnore];
}

class InitPaymentProcessEvent extends PaymentEvent {
  final PaymentData paymentData;
  InitPaymentProcessEvent(this.paymentData);
  @override
  List<Object> get props => [paymentData];
}

class SetPaymentProcessedEvent extends PaymentEvent {
  final bool paid;
  SetPaymentProcessedEvent(this.paid);
  @override
  List<Object> get props => [paid];
}
