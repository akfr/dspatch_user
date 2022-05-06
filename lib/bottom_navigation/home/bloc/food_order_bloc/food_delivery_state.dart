import 'package:dspatch_user/models/food/food_item.dart';
import 'package:dspatch_user/models/food/meta_food.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class FoodDeliveryState extends Equatable {
  final String pickupAddress;
  final LatLng pickupLatLng;
  final String dropAddress;
  final LatLng dropLatLng;
  final String selectedBoxType;
  final String instruction;
  final bool isSelected;
  final bool isEnabled;
  final bool goToNextPage;
  final String pickupName;
  final String dropName;
  final MetaFood metaData;
  final int deliveryModeId;
  final String deliveryMode;
  final double deliveryModePrice;
  final String paymentMethodSlug;
  final String pickNumber;
  final String dropNumber;
  final String notes;
  final List<FoodItem> foodItems;

  PaymentMethod paymentMethod;

  FoodDeliveryState({
    @required this.pickupAddress,
    @required this.pickupLatLng,
    @required this.dropAddress,
    @required this.dropLatLng,
    @required this.selectedBoxType,
    @required this.isSelected,
    @required this.isEnabled,
    @required this.goToNextPage,
    @required this.instruction,
    @required this.pickupName,
    @required this.dropName,
    @required this.metaData,
    @required this.deliveryModeId,
    @required this.deliveryMode,
    @required this.deliveryModePrice,
    @required this.paymentMethodSlug,
    @required this.pickNumber,
    @required this.dropNumber,
    @required this.notes,
    @required this.foodItems,
    this.paymentMethod,
  });

  @override
  List<Object> get props => [
        selectedBoxType,
        isSelected,
        isEnabled,
        pickupAddress,
        pickupLatLng,
        dropAddress,
        dropLatLng,
        instruction,
        goToNextPage,
        pickupName,
        dropName,
        metaData,
        deliveryModeId,
        deliveryMode,
        deliveryModePrice,
        paymentMethodSlug,
        pickNumber,
        dropNumber,
        notes,
        foodItems
      ];

  @override
  bool get stringify => true;
}
