import 'package:bloc/bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_state.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/models/food/food_item.dart';
import 'package:dspatch_user/models/food/meta_food.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodDeliveryBloc extends Bloc<FoodDeliveryEvent, FoodDeliveryState> {
  MapRepository _mapRepository = MapRepository();

  FoodDeliveryBloc()
      : super(
          FoodDeliveryState(
            selectedBoxType: '',
            isSelected: false,
            isEnabled: false,
            pickupAddress: null,
            pickupLatLng: null,
            dropAddress: null,
            dropLatLng: null,
            goToNextPage: false,
            instruction: '',
            pickupName: null,
            dropName: null,
            metaData: null,
            deliveryModeId: null,
            deliveryMode: null,
            deliveryModePrice: null,
            paymentMethodSlug: null,
            pickNumber: null,
            dropNumber: null,
            notes: 'None',
            foodItems: [],
          ),
        );

  @override
  Stream<FoodDeliveryState> mapEventToState(FoodDeliveryEvent event) async* {
    if (event is ValuesSelectedEvent) {
      yield _mapValuesSelectedToState(event.boxType);
    } else if (event is ValuesShowEvent) {
      yield _mapValuesShowToState();
    } else if (event is DropSelectedEvent) {
      yield* _mapDropSelectedToState(event);
    } else if (event is SubmittedEvent) {
      yield* _mapSubmittedEventToState(event);
    } else if (event is MetaDataAddedEvent) {
      yield _mapMetaDataAddedEventToState(event.meta, event.notes);
    } else if (event is DeliveryModeSelectedEvent) {
      yield _mapDeliveryModeSelectedEventToState(
          event.deliveryMode, event.deliveryName, event.deliveryPrice);
    } else if (event is PaymentModeSelectedEvent) {
      yield _mapPaymentModeSelectedEventToState(event.paymentMethod);
    } else if (event is FoodItemsAddedEvent) {
      yield _mapFoodItemsAddedEventToState(event.foodItems);
    } else if (event is VendorSelectedEvent) {
      yield* _mapVendorSelectedEventToState(event.vendor);
    }
  }

  bool canNavToIndex(int toIndex) {
    switch (toIndex) {
      case 0:
        return true;
      case 1:
        return state.pickupLatLng != null &&
            state.pickupName != null &&
            state.pickNumber != null;
      case 2:
        return state.dropLatLng != null &&
            state.dropName != null &&
            state.dropNumber != null;
      case 3:
        return state.foodItems != null && state.foodItems.isNotEmpty;
      default:
        return false;
    }
  }

  FoodDeliveryState _mapValuesSelectedToState(String boxType) {
    if (boxType.length == 0) {
      return FoodDeliveryState(
          selectedBoxType: boxType,
          isSelected: false,
          isEnabled: false,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: state.instruction,
          goToNextPage: false,
          pickupName: state.pickupName,
          dropName: state.dropName,
          metaData: state.metaData,
          deliveryModeId: state.deliveryModeId,
          deliveryMode: state.deliveryMode,
          deliveryModePrice: state.deliveryModePrice,
          paymentMethodSlug: state.paymentMethodSlug,
          pickNumber: state.pickNumber,
          dropNumber: state.dropNumber,
          notes: state.notes,
          foodItems: state.foodItems);
    } else {
      return FoodDeliveryState(
          selectedBoxType: boxType,
          isSelected: false,
          isEnabled: true,
          pickupAddress: state.pickupAddress,
          pickupLatLng: state.pickupLatLng,
          dropAddress: state.dropAddress,
          dropLatLng: state.dropLatLng,
          instruction: state.instruction,
          goToNextPage: false,
          pickupName: state.pickupName,
          dropName: state.dropName,
          metaData: state.metaData,
          deliveryModeId: state.deliveryModeId,
          deliveryMode: state.deliveryMode,
          deliveryModePrice: state.deliveryModePrice,
          paymentMethodSlug: state.paymentMethodSlug,
          pickNumber: state.pickNumber,
          dropNumber: state.dropNumber,
          notes: state.notes,
          foodItems: state.foodItems);
    }
  }

  FoodDeliveryState _mapValuesShowToState() {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: true,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  Stream<FoodDeliveryState> _mapVendorSelectedEventToState(
      Vendor vendor) async* {
    LatLng latLng = LatLng(vendor.latitude ?? 0.0, vendor.longitude ?? 0.0);
    String address = vendor.address;
    if (address == null || address.isEmpty) {
      try {
        address = await _mapRepository.getAddress(latLng);
      } catch (e) {
        print("getAddress: $e");
      } finally {
        if (address == null || address.isEmpty) {
          address = "Unknown Location";
        }
      }
    }

    yield FoodDeliveryState(
      selectedBoxType: state.selectedBoxType,
      isSelected: false,
      isEnabled: false,
      pickupAddress: vendor.address,
      pickupLatLng: latLng,
      dropAddress: state.dropAddress,
      dropLatLng: state.dropLatLng,
      instruction: state.instruction,
      goToNextPage: false,
      pickupName: vendor.name,
      dropName: state.dropName,
      metaData: state.metaData,
      deliveryModeId: state.deliveryModeId,
      deliveryMode: state.deliveryMode,
      deliveryModePrice: state.deliveryModePrice,
      paymentMethodSlug: state.paymentMethodSlug,
      pickNumber: vendor.user.mobileNumber,
      dropNumber: state.dropNumber,
      notes: state.notes,
      foodItems: state.foodItems,
    );
  }

  Stream<FoodDeliveryState> _mapDropSelectedToState(
      DropSelectedEvent event) async* {
    yield FoodDeliveryState(
      selectedBoxType: state.selectedBoxType,
      isSelected: false,
      isEnabled: false,
      pickupAddress: state.pickupAddress,
      pickupLatLng: state.pickupLatLng,
      dropAddress: event.dropAddressFormatted ?? state.dropAddress,
      dropLatLng: event.dropLatLng,
      instruction: state.instruction,
      goToNextPage: false,
      pickupName: state.pickupName,
      dropName: event.dropName,
      metaData: state.metaData,
      deliveryModeId: state.deliveryModeId,
      deliveryMode: state.deliveryMode,
      deliveryModePrice: state.deliveryModePrice,
      paymentMethodSlug: state.paymentMethodSlug,
      pickNumber: state.pickNumber,
      dropNumber: event.dropPhoneNumber,
      notes: state.notes,
      foodItems: state.foodItems,
    );
  }

  Stream<FoodDeliveryState> _mapSubmittedEventToState(
      SubmittedEvent event) async* {
    //await _repository.createFoodOrder(state);
    yield FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: true,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapDropNameSelectedEventToState(String dropName) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapDropNumberSelectedEventToState(String dropNumber) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapMetaDataAddedEventToState(MetaFood meta, String notes) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: meta,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapPaymentModeSelectedEventToState(
      PaymentMethod paymentMethod) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: paymentMethod.slug,
        paymentMethod: paymentMethod,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapDeliveryModeSelectedEventToState(
      int deliveryModeId, String deliveryMode, double price) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: deliveryModeId,
        deliveryMode: deliveryMode,
        deliveryModePrice: price,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: state.foodItems);
  }

  FoodDeliveryState _mapFoodItemsAddedEventToState(List<FoodItem> foodItems) {
    return FoodDeliveryState(
        selectedBoxType: state.selectedBoxType,
        isSelected: false,
        isEnabled: false,
        pickupAddress: state.pickupAddress,
        pickupLatLng: state.pickupLatLng,
        dropAddress: state.dropAddress,
        dropLatLng: state.dropLatLng,
        instruction: state.instruction,
        goToNextPage: false,
        pickupName: state.pickupName,
        dropName: state.dropName,
        metaData: state.metaData,
        deliveryModeId: state.deliveryModeId,
        deliveryMode: state.deliveryMode,
        deliveryModePrice: state.deliveryModePrice,
        paymentMethodSlug: state.paymentMethodSlug,
        pickNumber: state.pickNumber,
        dropNumber: state.dropNumber,
        notes: state.notes,
        foodItems: foodItems);
  }
}
