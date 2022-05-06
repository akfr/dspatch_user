// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
// class MapRepository {
//   static const String _API_KEY = 'AIzaSyBsHIW6ICGUBE36qkSZBOajaJh1uZjR6U8';
//   GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _API_KEY);
//   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//
//   Future<Position> getCurrentLocation() async {
//     Position position = await geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);
//     return position;
//   }
//
//   Future<Placemark> getAddressFromLatLng(LatLng latLng) async {
//     List<Placemark> p = await geolocator.placemarkFromCoordinates(
//         latLng.latitude, latLng.longitude);
//     Placemark place = p[0];
//
//     return place;
//   }
//
//   Future<PlaceDetails> getPlaceDetails(String placeId) async {
//     PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);
//     return response.result;
//   }
//
//   LatLng getLatLng(PlaceDetails placeDetails) {
//     LatLng latLng = LatLng(
//         placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
//     return latLng;
//   }
// }
