import 'package:dspatch_user/config/app_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

class MapRepository {
  // static List<Component> searchableComponents = [];
  // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.mapsApiKey);
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(
        /*forceAndroidLocationManager: true, */ desiredAccuracy:
            LocationAccuracy.best);
  }

  Future<Placemark> getLatLngPlacemark(LatLng latLng) async {
    List<Placemark> p = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = p[0];
    return place;
  }

  Future<List<LatLng>> getPolyline(
      LatLng pickupLatLng, LatLng dropLatLng) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapsApiKey,
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  // Future<PlaceDetails> getPlaceDetails(String placeId) async {
  //   PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);
  //   return response.result;
  // }

  // LatLng getLatLng(PlaceDetails placeDetails) {
  //   LatLng latLng = LatLng(
  //       placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
  //   return latLng;
  // }

  Stream<Event> getDeliveryLatLng(int deliveryId) {
    return _databaseReference.child('deliveries/$deliveryId/location').onValue;
  }

  Future<List<LatLng>> getPolylineCoordinates(
      LatLng source, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapsApiKey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  Future<String> getAddress(LatLng latLng) async {
    Placemark place = await getLatLngPlacemark(latLng);
    // searchableComponents.clear();
    // //searchableComponents.add(Component(Component.locality, place.locality));
    // searchableComponents
    //     .add(Component(Component.country, place.isoCountryCode));

    print("Address For: ${place.toJson()}");
    bool full = true;
    String currentAddress = "";
    List<String> addressComponents = [];
    if (place.name != null && place.name.isNotEmpty)
      addressComponents.add(place.name);
    if (place.subLocality != null && place.subLocality.isNotEmpty)
      addressComponents.add(place.subLocality);
    if (place.locality != null && place.locality.isNotEmpty)
      addressComponents.add(place.locality);
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea.isNotEmpty)
      addressComponents.add(place.subAdministrativeArea);
    if (place.administrativeArea != null && place.administrativeArea.isNotEmpty)
      addressComponents.add(place.administrativeArea);
    if (place.postalCode != null && place.postalCode.isNotEmpty)
      addressComponents.add(place.postalCode);
    if (place.country != null && place.country.isNotEmpty)
      addressComponents.add(place.country);
    if (addressComponents.isNotEmpty)
      currentAddress = full
          ? addressComponents.join(", ")
          : (double.tryParse(addressComponents[0]) == null
              ? addressComponents[0]
              : addressComponents[1]);
    return currentAddress;
  }
}
