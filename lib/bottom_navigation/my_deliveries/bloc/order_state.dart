import 'package:dspatch_user/components/my_map_widget.dart';
import 'package:dspatch_user/models/base_list_response.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingOrderState extends OrderState {}

class SuccessOrdersState extends OrderState {
  final BaseListResponse<OrderData> orders;

  SuccessOrdersState(this.orders);

  @override
  List<Object> get props => [orders];
}

class SuccessOrderUpdatedState extends OrderState {
  final OrderData order;

  SuccessOrderUpdatedState(this.order);

  @override
  List<Object> get props => [order];
}

class SuccessOrderDeliveryLocationUpdatedState extends OrderState {
  final LatLng latLng;
  final bool show;

  SuccessOrderDeliveryLocationUpdatedState(this.latLng, this.show);

  @override
  List<Object> get props => [latLng, show];
}

class SuccessOrderMapState extends OrderState {
  final LatLng latLngCenter;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final bool zoomEnabled;

  SuccessOrderMapState(
      this.latLngCenter, this.markers, this.polyLines, this.zoomEnabled);

  @override
  List<Object> get props => [latLngCenter, markers, polyLines, zoomEnabled];

  MyMapData toMapData() {
    final Map<MarkerId, Marker> markersMap = Map();
    for (Marker marker in markers) markersMap[marker.markerId] = marker;
    return MyMapData(latLngCenter, markersMap, polyLines, zoomEnabled);
  }
}

class FailureOrderState extends OrderState {
  final e;

  FailureOrderState(this.e);

  @override
  List<Object> get props => [e];
}
