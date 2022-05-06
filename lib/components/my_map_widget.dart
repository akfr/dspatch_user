import 'dart:math';

import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class MyMapWidget extends StatefulWidget {
  final MyMapData _myMapData;
  final Function(LatLng latLng) onMapTap;
  final Function(String markerId) onMarkerTap;

  MyMapWidget(Key key, this._myMapData, [this.onMapTap, this.onMarkerTap])
      : super(key: key);

  @override
  MyMapState createState() => MyMapState(_myMapData);
}

class MyMapState extends State<MyMapWidget> {
  MyMapData mapData;
  GoogleMapController _googleMapController;

  MyMapState(this.mapData);

  @override
  Widget build(BuildContext context) {
    print("BuildingMapWith: $mapData");
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: mapData.latLngCenter,
        zoom: 6.0,
      ),
      mapType: MapType.normal,
      markers: Set<Marker>.of(mapData.markers.values),
      polylines: mapData.polyLines,
      zoomControlsEnabled: mapData.zoomEnabled,
      onTap: (LatLng latLng) {
        if (widget.onMapTap != null) widget.onMapTap(latLng);
      },
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
        rootBundle
            .loadString('assets/map_style.json')
            .then((string) => _googleMapController.setMapStyle(string));
      },
    );
  }

  void moveCameraToXY(double x, double y) {
    _googleMapController
        .moveCamera(CameraUpdate.scrollBy(x, y))
        .then((value) => print("moveCamera"));
  }

  Marker getMarkerById(String markerId) {
    MarkerId markerIdToCheck = MarkerId(markerId);
    return mapData.markers.containsKey(markerIdToCheck)
        ? mapData.markers[markerIdToCheck]
        : null;
  }

  void moveCameraToMarker(String markerId) {
    Marker markerToCheck = getMarkerById(markerId);
    if (markerToCheck != null) moveCameraToLatLng(markerToCheck.position);
  }

  void moveCameraToLatLng(LatLng latLng) {
    _googleMapController
        .moveCamera(CameraUpdate.newLatLng(latLng))
        .then((value) => print("moveCamera"));
  }

  void buildWith(MyMapData myMapData) {
    setState(() {
      mapData = myMapData;
    });
    Future.delayed(Duration(milliseconds: 500),
        () => moveCameraToLatLng(mapData.latLngCenter));
  }

  void updateMarkerLocation(String markerId, LatLng markerLocation) {
    Marker newMarker = mapData.markers.containsKey(MarkerId(markerId))
        ? mapData.markers[MarkerId(markerId)]
            .copyWith(positionParam: markerLocation)
        : null;
    if (newMarker != null) {
      _googleMapController
          .animateCamera(CameraUpdate.newLatLng(markerLocation))
          .then((value) {
        setState(() {
          mapData.markers
              .removeWhere((key, value) => key == MarkerId(markerId));
          mapData.markers[MarkerId(markerId)] = newMarker;
        });
      });
    }
  }

  void buildWithVendors(List<Vendor> vendors, bool isGroceryOrder) async {
    BitmapDescriptor mapPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        isGroceryOrder ? 'images/ic_grocpin.png' : 'images/ic_restropin.png');
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    for (Vendor event in vendors) {
      final MarkerId markerId = MarkerId("marker_event_${event.id}");
      markers[markerId] = Marker(
        markerId: markerId,
        icon: mapPinIcon,
        position: LatLng(event.latitude, event.longitude),
        onTap: () {
          if (widget.onMarkerTap != null) widget.onMarkerTap(markerId.value);
        },
      );
    }
    if (mapData.markers.isEmpty ||
        !_listEquals(
            mapData.markers.values.toList(), markers.values.toList())) {
      LatLng latLngCenter;
      LatLngBounds latLngBounds;
      try {
        //latLngBounds = await _googleMapController.getVisibleRegion();
        latLngBounds = MyMapHelper.getMarkerBounds(markers.values.toList());
        LatLng centerAll = markers.length == 1
            ? markers.values.first.position
            : LatLng(
                (latLngBounds.northeast.latitude +
                        latLngBounds.southwest.latitude) /
                    2,
                (latLngBounds.northeast.longitude +
                        latLngBounds.southwest.longitude) /
                    2,
              );
        latLngCenter = centerAll;
      } catch (e) {
        print("centerAllError: $e");
      }
      print("latLngCenter: $latLngCenter");
      buildWith(
        MyMapData(latLngCenter != null ? latLngCenter : mapData.latLngCenter,
            markers, Set(), false),
      );
    }
  }

  bool _listEquals(List<Marker> list1, List<Marker> list2) {
    bool toReturn = list1.length == list2.length;
    if (toReturn) {
      for (int i = 0; i < list1.length; i++) {
        if (list1[i].position != list2[i].position) {
          toReturn = false;
          break;
        }
      }
    }
    return toReturn;
  }
}

class MyMapData {
  final LatLng latLngCenter;
  final Map<MarkerId, Marker> markers;
  final Set<Polyline> polyLines;
  final bool zoomEnabled;

  MyMapData(this.latLngCenter, this.markers, this.polyLines, this.zoomEnabled);

  @override
  String toString() {
    return 'MyMapData{center: $latLngCenter, markers: ${markers.length}, polyLines: ${polyLines.length}';
  }
}

class MyMapHelper {
  static Marker genMarker(
      LatLng latLng, String id, BitmapDescriptor descriptor) {
    return Marker(markerId: MarkerId(id), icon: descriptor, position: latLng);
  }

  static LatLngBounds getMarkerBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }
}
