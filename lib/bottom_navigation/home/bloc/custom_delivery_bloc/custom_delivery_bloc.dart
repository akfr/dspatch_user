import 'package:bloc/bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/models/category.dart';
import 'package:dspatch_user/models/custom_delivery/meta_custom.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:geocoding/geocoding.dart';

import 'custom_delivery_event.dart';
import 'custom_delivery_state.dart';

class CustomDeliveryBloc
    extends Bloc<CustomDeliveryEvent, CustomDeliveryState> {
  MapRepository _mapRepository = MapRepository();
  HomeRepository _repository = HomeRepository();

  List<String> courierTypes = [];
  String courierTypeSelected;

  CustomDeliveryBloc()
      : super(CustomDeliveryState(
          selectedBoxType: '',
          isSelected: false,
          isEnabled: false,
          pickupAddress: '',
          pickupLatLng: null,
          dropAddress: '',
          dropLatLng: null,
          goToNextPage: false,
          instruction: '',
          pickupName: null,
          dropName: null,
          metaData: null,
          deliveryModeId: null,
          deliveryMode: null,
          deliveryModePrice: null,
          paymentMethodSlug: 'cod',
          pickNumber: null,
          dropNumber: null,
          notes: 'None',
        )) {
    _fetchCourierTypes();
  }

  @override
  Stream<CustomDeliveryState> mapEventToState(
      CustomDeliveryEvent event) async* {
    if (event is ValuesSelectedEvent) {
      yield _mapValuesSelectedToState(event.boxType);
    } else if (event is ValuesShowEvent) {
      yield _mapValuesShowToState();
    } else if (event is PickupSelectedEvent) {
      yield* _mapPickupSelectedToState(event);
    } else if (event is DropSelectedEvent) {
      yield* _mapDropSelectedToState(event);
    } else if (event is SubmittedCustomEvent) {
      yield* _mapSubmittedEventToState(event);
    } else if (event is MetaDataAddedEvent) {
      yield _mapMetaDataAddedEventToState(event.meta, event.notes);
    } else if (event is DeliveryModeCustomSelectedEvent) {
      yield _mapDeliveryModeSelectedEventToState(
          event.deliveryMode, event.deliveryName, event.deliveryPrice);
    } else if (event is PaymentModeCustomSelectedEvent) {
      yield _mapPaymentModeSelectedEventToState(event.paymentMethod);
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
        return state.metaData != null && state.metaData.courier_type != null;
      default:
        return false;
    }
  }

  CustomDeliveryState _mapValuesSelectedToState(String boxType) {
    if (boxType.length == 0) {
      return CustomDeliveryState(
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
          notes: state.notes);
    } else {
      return CustomDeliveryState(
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
          notes: state.notes);
    }
  }

  CustomDeliveryState _mapValuesShowToState() {
    return CustomDeliveryState(
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
        notes: state.notes);
  }

  _fetchCourierTypes() async {
    try {
      List<Category> categories =
          await _repository.fetchCategories("courier-type");
      for (Category category in categories) courierTypes.add(category.title);
    } catch (e) {
      print("_fetchCourierTypes $e");
    }
  }

  Stream<CustomDeliveryState> _mapPickupSelectedToState(
      PickupSelectedEvent event) async* {
    yield CustomDeliveryState(
      selectedBoxType: state.selectedBoxType,
      isSelected: false,
      isEnabled: false,
      pickupAddress: event.pickupAddressFormatted ?? state.pickupAddress,
      pickupLatLng: event.pickupLatLng ?? state.pickupLatLng,
      dropAddress: state.dropAddress,
      dropLatLng: state.dropLatLng,
      instruction: state.instruction,
      goToNextPage: false,
      pickupName: event.pickupName ?? state.pickupName,
      dropName: state.dropName,
      metaData: state.metaData,
      deliveryModeId: state.deliveryModeId,
      deliveryMode: state.deliveryMode,
      deliveryModePrice: state.deliveryModePrice,
      paymentMethodSlug: state.paymentMethodSlug,
      pickNumber: event.pickupPhoneNumber ?? state.pickNumber,
      dropNumber: state.dropNumber,
      notes: state.notes,
    );
  }

  Stream<CustomDeliveryState> _mapDropSelectedToState(
      DropSelectedEvent event) async* {
    yield CustomDeliveryState(
      selectedBoxType: state.selectedBoxType,
      isSelected: false,
      isEnabled: false,
      pickupAddress: state.pickupAddress,
      pickupLatLng: state.pickupLatLng,
      dropAddress: event.dropAddressFormatted ?? state.dropAddress,
      dropLatLng: event.dropLatLng ?? state.dropLatLng,
      instruction: state.instruction,
      goToNextPage: false,
      pickupName: state.pickupName,
      dropName: event.dropName ?? state.dropName,
      metaData: state.metaData,
      deliveryModeId: state.deliveryModeId,
      deliveryMode: state.deliveryMode,
      deliveryModePrice: state.deliveryModePrice,
      paymentMethodSlug: state.paymentMethodSlug,
      pickNumber: state.pickNumber,
      dropNumber: event.dropPhoneNumber ?? state.dropNumber,
      notes: state.notes,
    );
  }

  Stream<CustomDeliveryState> _mapSubmittedEventToState(
      SubmittedCustomEvent event) async* {
    //await _repository.createCustomOrder(state);
    yield CustomDeliveryState(
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
        notes: state.notes);
  }

  CustomDeliveryState _mapMetaDataAddedEventToState(
      MetaCustom meta, String notes) {
    return CustomDeliveryState(
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
        notes: notes);
  }

  CustomDeliveryState _mapPaymentModeSelectedEventToState(
      PaymentMethod paymentMethod) {
    return CustomDeliveryState(
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
        notes: state.notes);
  }

  CustomDeliveryState _mapDeliveryModeSelectedEventToState(
      int deliveryModeId, String deliveryMode, double price) {
    return CustomDeliveryState(
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
        notes: state.notes);
  }
}
