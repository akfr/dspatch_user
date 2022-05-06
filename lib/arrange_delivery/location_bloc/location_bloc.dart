import 'package:dspatch_user/arrange_delivery/location_bloc/location_event.dart';
import 'package:dspatch_user/arrange_delivery/location_bloc/location_state.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  MapRepository _mapRepository = MapRepository();
  LocationBloc() : super(LocationState(''));
  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is PickupSelectedEvent) {
      // yield* _mapPickupToState(event.pickupPrediction);
    }
  }

//   Stream<LocationState> _mapPickupToState(Prediction pickupPrediction) async* {
//     try {
//       // PlaceDetails placeDetails =
//       // await _mapRepository.getPlaceDetails(pickupPrediction.placeId);
//       // String address = placeDetails.formattedAddress;
//       // LatLng latLng = _mapRepository.getLatLng(placeDetails);
// //       var prefs = await SharedPreferences.getInstance();
// //       prefs.setDouble('lat', latLng.latitude);
// //       prefs.setDouble('lng', latLng.longitude);
// // //      await _mapRepository.sendLatLng(vendorId, latLng.latitude, latLng.longitude);
// //       yield LocationState(address);
//     } catch (e) {
//       throw Exception();
//     }
//   }
}
