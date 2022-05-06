import 'package:dspatch_user/components/card_picker.dart';
import 'package:dspatch_user/models/food/food_item.dart';
import 'package:dspatch_user/models/food/meta_food.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class FoodDeliveryEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class VendorSelectedEvent extends FoodDeliveryEvent {
  final Vendor vendor;
  VendorSelectedEvent(this.vendor);
  @override
  List<Object> get props => [vendor];
}

class DeliveryModeSelectedEvent extends FoodDeliveryEvent {
  final int deliveryMode;
  final String deliveryName;
  final double deliveryPrice;

  DeliveryModeSelectedEvent(
      this.deliveryMode, this.deliveryName, this.deliveryPrice);

  @override
  List<Object> get props => [deliveryMode];
}

class PaymentModeSelectedEvent extends FoodDeliveryEvent {
  final PaymentMethod paymentMethod;

  PaymentModeSelectedEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class MetaDataAddedEvent extends FoodDeliveryEvent {
  final MetaFood meta;
  final String notes;

  MetaDataAddedEvent(this.meta, this.notes);

  @override
  List<Object> get props => [meta];
}

class DropSelectedEvent extends FoodDeliveryEvent {
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

class ValuesSelectedEvent extends FoodDeliveryEvent {
  final String boxType;

  ValuesSelectedEvent(this.boxType);

  @override
  List<Object> get props => [boxType];
}

class FoodItemsAddedEvent extends FoodDeliveryEvent {
  final List<FoodItem> foodItems;

  FoodItemsAddedEvent(this.foodItems);

  @override
  List<Object> get props => [foodItems];
}

class ValuesShowEvent extends FoodDeliveryEvent {}

class SubmittedEvent extends FoodDeliveryEvent {
  final String instruction;
  final CardInfo cardInfo;
  // final String sourceContactNumber;
  // final String destinationContactNumber;
  // final MetaCustom meta;

  SubmittedEvent(this.instruction, [this.cardInfo]
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
