import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchOrderEvent extends OrderEvent {
  final int pageNum;

  FetchOrderEvent(this.pageNum);

  @override
  List<Object> get props => [pageNum];
}

class FetchOrderUpdatesEvent extends OrderEvent {
  final OrderData order;

  FetchOrderUpdatesEvent(this.order);

  @override
  List<Object> get props => [order];
}

class FetchOrderUpdatedEvent extends OrderEvent {
  final OrderData orderData;

  FetchOrderUpdatedEvent(this.orderData);

  @override
  List<Object> get props => [orderData];
}

class FetchOrderDeliveryLocationUpdatedEvent extends OrderEvent {
  final String latitude, longitude;

  FetchOrderDeliveryLocationUpdatedEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class FetchOrderMapEvent extends OrderEvent {
  final OrderData order;
  final bool reCenter;

  FetchOrderMapEvent(this.order, this.reCenter);

  @override
  List<Object> get props => [order, reCenter];
}
