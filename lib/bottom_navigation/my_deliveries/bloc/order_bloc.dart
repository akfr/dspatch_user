import 'dart:async';
import 'dart:convert';

import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_event.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_state.dart';
import 'package:dspatch_user/components/my_map_widget.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/auth/responses/user_info.dart';
import 'package:dspatch_user/models/base_list_response.dart';
import 'package:dspatch_user/models/meta_list.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  HomeRepository _repository = HomeRepository();
  MapRepository _mapRepository = MapRepository();
  List<OrderData> _orders = [];
  MetaList _metaLast;
  Polyline _polylineVendorHome;
  StreamSubscription<Event> _ordersStreamSubscription,
      _orderStreamSubscription,
      _orderDeliveryLocationStreamSubscription;

  OrderBloc() : super(LoadingOrderState());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    switch (event.runtimeType) {
      case FetchOrderEvent:
        yield* _mapFetchOrderToState((event as FetchOrderEvent).pageNum);
        break;
      case FetchOrderUpdatesEvent:
        yield* _mapFetchOrderUpdatesToState(
            (event as FetchOrderUpdatesEvent).order);
        break;
      case FetchOrderUpdatedEvent:
        yield SuccessOrderUpdatedState(
            (event as FetchOrderUpdatedEvent).orderData);
        break;
      case FetchOrderDeliveryLocationUpdatedEvent:
        yield SuccessOrderDeliveryLocationUpdatedState(
            LatLng(
                double.parse(
                    (event as FetchOrderDeliveryLocationUpdatedEvent).latitude),
                double.parse((event as FetchOrderDeliveryLocationUpdatedEvent)
                    .longitude)),
            true);
        break;
      case FetchOrderMapEvent:
        yield* _mapFetchOrderMapToState((event as FetchOrderMapEvent).order,
            (event as FetchOrderMapEvent).reCenter);
        break;
    }
  }

  Stream<OrderState> _mapFetchOrderMapToState(OrderData orderToShow,
      [bool reCenterAll]) async* {
    Set<Marker> markers = Set();
    Set<Polyline> polyLines = Set();
    LatLng latLngCenter =
        LatLng(orderToShow.address.latitude, orderToShow.address.longitude);
    BitmapDescriptor srcIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            /*devicePixelRatio: 4*/
            size: Size.fromHeight(10)),
        'images/map_icon1.png');
    BitmapDescriptor destIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            /*devicePixelRatio: 4*/
            size: Size.fromHeight(10)),
        'images/map_icon2.png');
    markers.add(MyMapHelper.genMarker(
        LatLng(orderToShow.address.latitude, orderToShow.address.longitude),
        "marker_home",
        destIcon));
    markers.add(MyMapHelper.genMarker(
        LatLng(orderToShow.sourceAddress.latitude,
            orderToShow.sourceAddress.longitude),
        "marker_vendor",
        srcIcon));

    if (_polylineVendorHome == null) {
      _polylineVendorHome = Polyline(
          width: 3,
          polylineId: PolylineId('polyline_vendor_home'),
          points: await _mapRepository.getPolylineCoordinates(
              LatLng(orderToShow.sourceAddress.latitude,
                  orderToShow.sourceAddress.longitude),
              LatLng(orderToShow.address.latitude,
                  orderToShow.address.longitude)));
    }
    polyLines.add(_polylineVendorHome);

    if (!orderToShow.isComplete() &&
        orderToShow.delivery != null &&
        orderToShow.delivery.delivery != null &&
        orderToShow.delivery.delivery.latitude != null &&
        orderToShow.delivery.delivery.longitude != null) {
      BitmapDescriptor driverIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
              /*devicePixelRatio: 4*/
              size: Size.fromHeight(10)),
          'images/delivery_bike.png');
      markers.add(MyMapHelper.genMarker(
          LatLng(orderToShow.delivery.delivery.latitude,
              orderToShow.delivery.delivery.longitude),
          "marker_delivery",
          driverIcon));

      //delivery guy's base location
      yield SuccessOrderDeliveryLocationUpdatedState(
          LatLng(orderToShow.delivery.delivery.latitude,
              orderToShow.delivery.delivery.longitude),
          false);
    }

    if (reCenterAll != null && reCenterAll) {
      try {
        LatLngBounds latLngBounds =
            MyMapHelper.getMarkerBounds(markers.toList());
        LatLng centerAll = LatLng(
          (latLngBounds.northeast.latitude + latLngBounds.southwest.latitude) /
              2,
          (latLngBounds.northeast.longitude +
                  latLngBounds.southwest.longitude) /
              2,
        );
        latLngCenter = centerAll;
      } catch (e) {
        print("centerAllError: $e");
      }
    }

    yield SuccessOrderMapState(latLngCenter, markers, polyLines, true);
  }

  Stream<OrderState> _mapFetchOrderToState(int pageNum) async* {
    yield LoadingOrderState();
    try {
      BaseListResponse<OrderData> ordersNew =
          await _repository.listOrdersAll(pageNum != null ? pageNum : 1);
      if (ordersNew.data != null && ordersNew.data.isNotEmpty)
        _orders.addAll(ordersNew.data);
      _metaLast = ordersNew.meta;
      if (ordersNew.data != null && ordersNew.data.isNotEmpty) _reFilter();
      yield SuccessOrdersState(BaseListResponse<OrderData>(_orders, _metaLast));
      await _registerOrdersUpdates();
    } catch (e) {
      yield FailureOrderState(e);
    }
  }

  Stream<OrderState> _mapFetchOrderUpdatesToState(OrderData order) async* {
    print(
        "FetchOrderUpdatesEvent: ${order.id}. Success: ${_orderStreamSubscription == null}");
    if (_orderStreamSubscription == null) {
      UserInformation userMe = await Helper().getUserMe();
      _orderStreamSubscription = _repository
          .getOrderFirebaseDbRef(userMe.id, order.id)
          .listen((Event event) {
        if (event.snapshot != null && event.snapshot.value != null) {
          try {
            Map requestMap = event.snapshot.value;
            OrderData orderUpdated =
                OrderData.fromJson(jsonDecode(jsonEncode(requestMap)));
            if (orderUpdated != null &&
                orderUpdated.id != null &&
                orderUpdated.status != null) {
              add(FetchOrderUpdatedEvent(orderUpdated));
              add(FetchOrderUpdatesEvent(orderUpdated));
            }
          } catch (e) {
            print("requestMapCastError: $e");
          }
        }
      });
    }

    if (order.delivery != null && order.delivery.delivery != null) {
      if (_orderDeliveryLocationStreamSubscription == null) {
        _orderDeliveryLocationStreamSubscription = _repository
            .getOrderDeliveryLocationFirebaseDbRef(order.delivery.delivery.id)
            .listen((Event event) {
          if (event.snapshot != null && event.snapshot.value != null) {
            try {
              Map requestMap = event.snapshot.value;
              if (requestMap.containsKey("latitude") &&
                  requestMap.containsKey("longitude")) {
                add(FetchOrderDeliveryLocationUpdatedEvent(
                    requestMap["latitude"].toString(),
                    requestMap["longitude"].toString()));
              }
            } catch (e) {
              print("requestMapCastError: $e");
            }
          }
        });
      }
    }
  }

  _reFilter() {
    OrderData orderProgress = OrderData.orderLabel("orders_pending");
    OrderData orderPast = OrderData.orderLabel("orders_past");

    String statusesPast = "cancelled,rejected,refund,failed,complete";

    List<OrderData> allOrders = [];
    allOrders.add(orderProgress);
    for (OrderData order in _orders)
      if (order.id != null &&
          order.id > 0 &&
          !statusesPast.contains(order.status)) allOrders.add(order);

    allOrders.add(orderPast);

    for (OrderData order in _orders)
      if (order.id != null &&
          order.id > 0 &&
          statusesPast.contains(order.status)) allOrders.add(order);

    if (allOrders[1].id < 0) allOrders.removeAt(0);
    if (allOrders[allOrders.length - 1].id < 0)
      allOrders.removeAt(allOrders.length - 1);

    _orders = allOrders.length > 0 ? allOrders : [];
  }

  Stream<OrderState> _updateOrderInList(OrderData orderUpdated) async* {
    int index = -1;
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == orderUpdated.id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      _orders[index] = orderUpdated;
      yield SuccessOrdersState(BaseListResponse<OrderData>(_orders, _metaLast));
    }
  }

  Future<void> _registerOrdersUpdates() async {
    if (_ordersStreamSubscription == null) {
      UserInformation userMe = await Helper().getUserMe();
      _ordersStreamSubscription =
          _repository.getOrdersFirebaseDbRef(userMe.id).listen((Event event) {
        if (event.snapshot != null && event.snapshot.value != null) {
          try {
            Map requestMap = event.snapshot.value;
            OrderData orderUpdated =
                OrderData.fromJson(jsonDecode(jsonEncode(requestMap)));
            if (orderUpdated != null &&
                orderUpdated.id != null &&
                orderUpdated.status != null) {
              _updateOrderInList(orderUpdated);
            }
          } catch (e) {
            print("requestMapCastError: $e");
          }
        }
      });
    }
  }

  _unRegisterOrdersUpdates() async {
    if (_ordersStreamSubscription != null) {
      await _ordersStreamSubscription.cancel();
      _ordersStreamSubscription = null;
    }
  }

  _unRegisterOrderUpdates() async {
    if (_orderStreamSubscription != null) {
      await _orderStreamSubscription.cancel();
      _orderStreamSubscription = null;
    }
  }

  _unRegisterOrderDeliveryLocationUpdates() async {
    if (_orderDeliveryLocationStreamSubscription != null) {
      await _orderDeliveryLocationStreamSubscription.cancel();
      _orderDeliveryLocationStreamSubscription = null;
    }
  }

  @override
  Future<void> close() async {
    await _unRegisterOrdersUpdates();
    await _unRegisterOrderUpdates();
    await _unRegisterOrderDeliveryLocationUpdates();
    return super.close();
  }
}
