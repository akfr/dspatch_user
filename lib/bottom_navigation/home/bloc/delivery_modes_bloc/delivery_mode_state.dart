import 'package:dspatch_user/models/custom_delivery/delivery_mode.dart';
import 'package:equatable/equatable.dart';

abstract class DeliveryModeState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingDeliveryModeState extends DeliveryModeState {}

class SuccessDeliveryModeState extends DeliveryModeState {
  final List<DeliveryMode> deliveryModes;

  SuccessDeliveryModeState(this.deliveryModes);

  @override
  List<Object> get props => [deliveryModes];
}

class FailureDeliveryModeState extends DeliveryModeState {
  final e;
  FailureDeliveryModeState(this.e);

  @override
  List<Object> get props => [e];
}
