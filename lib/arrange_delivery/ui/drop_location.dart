import 'dart:async';

import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/components/address_field.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/my_map_widget.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/maps/bloc/map_bloc.dart';
import 'package:dspatch_user/maps/bloc/map_event.dart';
import 'package:dspatch_user/maps/bloc/map_state.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

class DropLocation extends StatefulWidget {
  final PageController pageController;
  final FoodDeliveryBloc foodDeliveryBloc;

  DropLocation(Key key, this.pageController, this.foodDeliveryBloc)
      : super(key: key);

  @override
  DropLocationState createState() => DropLocationState();
}

class DropLocationState extends State<DropLocation> {
  MapBloc _mapBloc;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _localityController = TextEditingController();
  TextEditingController _nearestPointController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  GlobalKey<MyMapState> _myMapStateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _mapBloc.add(FetchCurrentLocation());
  }

  @override
  void dispose() {
    _localityController.dispose();
    _nearestPointController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) async {
        print("MapState: $state");
        if (_myMapStateKey.currentState != null) {
          if (_myMapStateKey.currentState.mapData.markers.isEmpty) {
            BitmapDescriptor bitmapDescriptor =
                await Helper.getBitmapDescriptorFromIconData(
                    Icons.location_on_rounded, Theme.of(context).primaryColor);

            Map<MarkerId, Marker> markers = Map();
            final MarkerId markerId = MarkerId("marker_me");
            markers[markerId] = Marker(
              markerId: markerId,
              icon: bitmapDescriptor ?? BitmapDescriptor.hueYellow,
              position: state.latLng,
              onTap: () {},
            );

            _myMapStateKey.currentState.buildWith(MyMapData(
              state.latLng,
              markers,
              Set(),
              true,
            ));
          } else {
            _myMapStateKey.currentState
                .updateMarkerLocation("marker_me", state.latLng);
          }
        }
        widget.foodDeliveryBloc.add(DropSelectedEvent(
          dropLatLng: _mapBloc.state.latLng,
          dropAddressFormatted: _mapBloc.state.formattedAddress,
        ));
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(children: [
          Container(
            height: 500,
            child: MyMapWidget(
                _myMapStateKey,
                MyMapData(
                  LatLng(0.0, 0.0),
                  Map(),
                  Set(),
                  true,
                ),
                (LatLng latLng) => _mapBloc.add(SetLocation(latLng))),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(boxShadow: [boxShadow]),
                margin: EdgeInsetsDirectional.only(
                    top: 16.0, start: 16.0, end: 10.0),
                child: AddressField(
                  readOnly: true,
                  onTap: () async {
                    // Prediction prediction = await PlacesAutocomplete.show(
                    //   context: context,
                    //   apiKey: AppConfig.mapsApiKey,
                    //   language: AppConfig.languageDefault ?? 'en',
                    //   components: MapRepository.searchableComponents,
                    //   mode: Mode.overlay,
                    //   onError: (response) {
                    //     print(response);
                    //   },
                    // );
                    // if (prediction != null && prediction.placeId != null)
                    //   _mapBloc.add(LocationSelectedEvent(prediction));
                  },
                  controller: _localityController,
                  color: theme.backgroundColor,
                  icon: Icon(
                    Icons.navigation,
                    color: theme.primaryColor,
                  ),
                  hint: locale.dropHint,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16),
                      decoration: BoxDecoration(
                        color: kButtonColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(35.0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.navigation,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: BlocBuilder<MapBloc, MapState>(
                              builder: (context, mapState) => Text(
                                mapState.formattedAddress,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    color: theme.backgroundColor,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // AddressField(
                        //   controller: _nearestPointController,
                        //   icon: Icon(Icons.star,
                        //       size: 20, color: theme.primaryColor),
                        //   hint: 'Nearest point',
                        //   color: kButtonColor,
                        // ),
                        SizedBox(height: 4),
                        AddressField(
                          controller: _nameController,
                          icon: Icon(Icons.person,
                              size: 20, color: theme.primaryColor),
                          hint: locale.namePerson,
                          // suffix: Icon(Icons.contacts,
                          //     color: theme.primaryColor, size: 20),
                          color: kButtonColor,
                        ),
                        SizedBox(height: 4),
                        AddressField(
                          keyBoardType: TextInputType.phone,
                          controller: _phoneController,
                          icon: Icon(Icons.phone,
                              size: 20, color: theme.primaryColor),
                          hint: locale.phoneText,
                          color: kButtonColor,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        CustomButton(
                          radius: BorderRadius.circular(35.0),
                          padding: 10,
                          text: '     ' + locale.continueText + '  ↓    ',
                          onPressed: () => submitData(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void submitData() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_mapBloc.state.latLng == null ||
        _mapBloc.state.latLng == LatLng(0.0, 0.0)) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("dropSelect"));
    } else if (_nameController.text == null || _nameController.text.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("err_name_valid"));
    } else if (_phoneController.text == null || _phoneController.text.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("phoneHint"));
    } else {
      widget.foodDeliveryBloc.add(DropSelectedEvent(
        dropLatLng: _mapBloc.state.latLng,
        dropAddressFormatted: _mapBloc.state.formattedAddress,
        dropName: _nameController.text,
        dropPhoneNumber: _phoneController.text,
      ));
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.pageController.animateToPage(2,
            duration: Duration(milliseconds: 350),
            curve: Curves.linearToEaseOut);
      });
    }
  }

  ListTile buildListTile(String text, {IconData icon}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: icon != null
          ? Icon(
              icon,
              color: Theme.of(context).primaryColor,
            )
          : Image.asset(
              'images/ic_officeblk.png',
              color: Theme.of(context).primaryColor,
              scale: 3.5,
            ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      dense: true,
    );
  }
}
