import 'package:equatable/equatable.dart';
// import 'package:google_maps_webservice/places.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object> get props => [];
  @override
  bool get stringify => true;
}

class PickupSelectedEvent extends LocationEvent {
  // final Prediction pickupPrediction;
  // PickupSelectedEvent(this.pickupPrediction);
  // @override
  // List<Object> get props => [pickupPrediction];
}
