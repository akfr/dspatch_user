import 'package:bloc/bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/home_repository.dart';
import 'package:dspatch_user/maps/bloc/map_event.dart';
import 'package:dspatch_user/maps/bloc/map_state.dart';
import 'package:dspatch_user/models/order/get/address.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  HomeRepository _repository = HomeRepository();
  MapRepository _mapRepository = MapRepository();

  MapBloc()
      : super(MapState(
          '',
          LatLng(0.0, 0.0),
          false,
          '',
          LatLng(0.0, 0.0),
          '',
          LatLng(0.0, 0.0),
        ));

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is UpdateCameraPositionEvent) {
      yield* _mapCameraPositionToState(event.position);
    } else if (event is UpdateAddressEvent) {
      yield* _mapUpdateAddressEventToState(event.position);
    }
    //  else if (event is LocationSelectedEvent) {
    //   yield* _mapLocationSelectedToState(event.prediction);
    // }
    else if (event is MarkerMovedEvent) {
      yield _mapMarkerMovedToState();
    } else if (event is FetchCurrentLocation) {
      yield* _mapFetchLocationEvent();
    } else if (event is SetLocation) {
      yield* _mapSetLocationEvent(event.latLng);
    } else if (event is ShowCardEvent) {
      yield _mapShowCardToState();
    } else if (event is AddressSubmittedEvent) {
      yield* _mapAddressSubmittedToState(
          event.title, event.formattedAddress, event.longitude, event.latitude);
    }
  }

  @override
  Stream<Transition<MapEvent, MapState>> transformEvents(
      Stream<MapEvent> events,
      TransitionFunction<MapEvent, MapState> transitionFn) {
    final nonDebounceStream =
        events.where((event) => (event is! UpdateAddressEvent));
    final debounceStream = events
        .where((event) => (event is UpdateAddressEvent))
        .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  Stream<MapState> _mapCameraPositionToState(CameraPosition position) async* {
    yield MapState(
        state.formattedAddress,
        position.target,
        false,
        state.pickupAddress,
        state.pickupLatLng,
        state.dropAddress,
        state.dropLatLng);
    add(UpdateAddressEvent(position));
  }

  Stream<MapState> _mapUpdateAddressEventToState(
      CameraPosition position) async* {
    String currentAddress;
    try {
      currentAddress = await _mapRepository.getAddress(position.target);
    } catch (e) {
      print("getAddress: $e");
    } finally {
      if (currentAddress == null || currentAddress.isEmpty) {
        currentAddress = "Unknown Location";
      }
    }
    yield MapState(currentAddress, position.target, false, state.pickupAddress,
        state.pickupLatLng, state.dropAddress, state.dropLatLng);
  }

  // Stream<MapState> _mapLocationSelectedToState(Prediction prediction) async* {
  //   PlaceDetails placeDetails =
  //       await _mapRepository.getPlaceDetails(prediction.placeId);
  //   LatLng latLng = _mapRepository.getLatLng(placeDetails);
  //   yield* _mapSetLocationEvent(latLng);
  // }

  MapState _mapMarkerMovedToState() {
    return MapState(
        state.formattedAddress,
        state.latLng,
        false,
        state.pickupAddress,
        state.pickupLatLng,
        state.dropAddress,
        state.dropLatLng);
  }

  Stream<MapState> _mapSetLocationEvent(LatLng latLng) async* {
    String currentAddress;
    try {
      currentAddress = await _mapRepository.getAddress(latLng);
    } catch (e) {
      print("getAddress: $e");
    } finally {
      if (currentAddress == null || currentAddress.isEmpty) {
        currentAddress = "Unknown Location";
      }
    }
    yield MapState(currentAddress, latLng, true, state.pickupAddress,
        state.pickupLatLng, state.dropAddress, state.dropLatLng);
  }

  Stream<MapState> _mapFetchLocationEvent() async* {
    Address savedAddress = await Helper().getCurrentLocation();
    if (savedAddress != null)
      yield MapState(
          savedAddress.formattedAddress,
          LatLng(savedAddress.latitude, savedAddress.longitude),
          true,
          state.pickupAddress,
          state.pickupLatLng,
          state.dropAddress,
          state.dropLatLng);
    Position position = await _mapRepository.getCurrentLocation();
    LatLng latLng = LatLng(position.latitude, position.longitude);

    String currentAddress;
    try {
      currentAddress = await _mapRepository.getAddress(latLng);
    } catch (e) {
      print("getAddress: $e");
    } finally {
      if (currentAddress == null || currentAddress.isEmpty) {
        currentAddress = "Unknown Location";
      }
    }

    await Helper().setCurrentLocation(Address(
      null,
      null,
      null,
      null,
      currentAddress,
      null,
      null,
      position.longitude,
      position.latitude,
      null,
    ));
    yield MapState(currentAddress, latLng, true, state.pickupAddress,
        state.pickupLatLng, state.dropAddress, state.dropLatLng);
  }

  MapState _mapShowCardToState() {
    return MapState(
        state.formattedAddress,
        state.latLng,
        false,
        state.pickupAddress,
        state.pickupLatLng,
        state.dropAddress,
        state.dropLatLng);
  }

  Stream<MapState> _mapAddressSubmittedToState(String title,
      String formattedAddress, double longitude, double latitude) async* {
    try {
      await _repository.postAddress(
          title, formattedAddress, longitude, latitude);

      // await _userRepository.saveAddress(address);
    } catch (e) {
      print(e);
    }
    bool isSignedIn = await Helper().getUserMe() == null ? false : true;
    if (isSignedIn) {
      yield MapState(
          formattedAddress,
          LatLng(longitude, latitude),
          true,
          state.pickupAddress,
          state.pickupLatLng,
          state.dropAddress,
          state.dropLatLng);
    } else {
      yield MapState(
          formattedAddress,
          LatLng(longitude, latitude),
          true,
          state.pickupAddress,
          state.pickupLatLng,
          state.dropAddress,
          state.dropLatLng);
    }
  }
}
