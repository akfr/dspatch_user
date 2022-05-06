import 'package:equatable/equatable.dart';

abstract class DeliveryModeEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchDeliveryModeEvent extends DeliveryModeEvent {}