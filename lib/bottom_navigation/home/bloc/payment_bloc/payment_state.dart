import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class InitialPaymentState extends PaymentState {}

class LoadingPaymentState extends PaymentState {}

class CreatingOrderState extends PaymentState {}

class ProcessingPaymentState extends PaymentState {}

class SuccessPlaceOrderState extends PaymentState {
  final PaymentData paymentData;

  SuccessPlaceOrderState(this.paymentData);

  @override
  List<Object> get props => [paymentData];
}

class FailurePlaceOrderState extends PaymentState {
  final String errorMessage;

  FailurePlaceOrderState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ProcessedPaymentState extends PaymentState {
  final PaymentStatus paymentStatus;
  ProcessedPaymentState(this.paymentStatus);
  @override
  List<Object> get props => [paymentStatus];
}

class LoadPaymentUrlState extends PaymentState {
  final String paymentLink, sUrl, fUrl;
  LoadPaymentUrlState(this.paymentLink, this.sUrl, this.fUrl);
  @override
  List<Object> get props => [paymentLink];
}

class SuccessPaymentState extends PaymentState {
  final List<PaymentMethod> listOfPaymentMethods;
  SuccessPaymentState(this.listOfPaymentMethods);

  @override
  List<Object> get props => [listOfPaymentMethods];
}

class FailurePaymentState extends PaymentState {
  final e;
  FailurePaymentState(this.e);

  @override
  List<Object> get props => [e];
}
