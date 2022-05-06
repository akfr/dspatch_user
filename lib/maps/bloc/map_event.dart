import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UpdateCameraPositionEvent extends MapEvent {
  final CameraPosition position;

  UpdateCameraPositionEvent(this.position);

  @override
  List<Object> get props => [position];
}

class UpdateAddressEvent extends MapEvent {
  final CameraPosition position;

  UpdateAddressEvent(this.position);

  @override
  List<Object> get props => [position];
}

class LocationSelectedEvent extends MapEvent {
  // final Prediction prediction;

  // LocationSelectedEvent(this.prediction);

  // @override
  // List<Object> get props => [prediction];
}

class MarkerMovedEvent extends MapEvent {}

class FetchCurrentLocation extends MapEvent {}

class ShowCardEvent extends MapEvent {}

class SetLocation extends MapEvent {
  final LatLng latLng;
  SetLocation(this.latLng);
  @override
  List<Object> get props => [latLng];
}

class AddressSubmittedEvent extends MapEvent {
  final String title;
  final String formattedAddress;
  final double longitude;
  final double latitude;

  AddressSubmittedEvent(
      this.title, this.formattedAddress, this.longitude, this.latitude);

  @override
  List<Object> get props => [title, formattedAddress, longitude, latitude];
}
