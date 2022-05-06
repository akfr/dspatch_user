import 'package:dspatch_user/models/custom_delivery/meta_custom.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class CustomDeliveryState extends Equatable {
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
  final MetaCustom metaData;
  final int deliveryModeId;
  final String deliveryMode;
  final double deliveryModePrice;
  final String paymentMethodSlug;
  final String pickNumber;
  final String dropNumber;
  final String notes;

  PaymentMethod paymentMethod;

  CustomDeliveryState({
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
        notes
      ];

  @override
  bool get stringify => true;
}
