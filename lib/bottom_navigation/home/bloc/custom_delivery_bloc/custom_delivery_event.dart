import 'package:dspatch_user/components/card_picker.dart';
import 'package:dspatch_user/models/custom_delivery/meta_custom.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CustomDeliveryEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class DeliveryModeCustomSelectedEvent extends CustomDeliveryEvent {
  final int deliveryMode;
  final String deliveryName;
  final double deliveryPrice;

  DeliveryModeCustomSelectedEvent(
      this.deliveryMode, this.deliveryName, this.deliveryPrice);

  @override
  List<Object> get props => [deliveryMode];
}

class PaymentModeCustomSelectedEvent extends CustomDeliveryEvent {
  final PaymentMethod paymentMethod;

  PaymentModeCustomSelectedEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class MetaDataAddedEvent extends CustomDeliveryEvent {
  final MetaCustom meta;
  final String notes;

  MetaDataAddedEvent(this.meta, this.notes);

  @override
  List<Object> get props => [meta];
}

class PickupSelectedEvent extends CustomDeliveryEvent {
  final LatLng pickupLatLng;
  final String pickupAddressFormatted, pickupName, pickupPhoneNumber;

  PickupSelectedEvent(
      {this.pickupLatLng,
      this.pickupAddressFormatted,
      this.pickupName,
      this.pickupPhoneNumber});

  @override
  List<Object> get props =>
      [pickupLatLng, pickupAddressFormatted, pickupName, pickupPhoneNumber];
}

class DropSelectedEvent extends CustomDeliveryEvent {
  final LatLng dropLatLng;
  final String dropAddressFormatted, dropName, dropPhoneNumber;

  DropSelectedEvent(
      {this.dropLatLng,
      this.dropAddressFormatted,
      this.dropName,
      this.dropPhoneNumber});

  @override
  List<Object> get props =>
      [dropLatLng, dropAddressFormatted, dropName, dropPhoneNumber];
}

class ValuesSelectedEvent extends CustomDeliveryEvent {
  final String boxType;

  ValuesSelectedEvent(this.boxType);

  @override
  List<Object> get props => [boxType];
}

class ValuesShowEvent extends CustomDeliveryEvent {}

class SubmittedCustomEvent extends CustomDeliveryEvent {
  final String instruction;
  final CardInfo cardInfo;
  // final String sourceContactNumber;
  // final String destinationContactNumber;
  // final MetaCustom meta;

  SubmittedCustomEvent(this.instruction, [this.cardInfo]
      /*this.sourceContactNumber,
      this.destinationContactNumber,*/
      );

  @override
  List<Object> get props => [
        instruction,
        // sourceContactNumber,
        // destinationContactNumber,
      ];
}
