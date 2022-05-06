import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final String formattedAddress;
  final LatLng latLng;
  final bool toAnimateCamera;
  final String pickupAddress;
  final LatLng pickupLatLng;
  final String dropAddress;
  final LatLng dropLatLng;

  MapState(
    this.formattedAddress,
    this.latLng,
    this.toAnimateCamera, this.pickupAddress, this.pickupLatLng, this.dropAddress, this.dropLatLng,
  );

  @override
  List<Object> get props => [
        formattedAddress,
        latLng,
        toAnimateCamera,
      ];

  @override
  bool get stringify => true;
}
