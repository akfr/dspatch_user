import 'dart:async';
import 'dart:ui';

import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_event.dart';
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

class PickupLocationCustom extends StatefulWidget {
  final IconData icon;
  final PageController pageController;
  final TextEditingController
      pickNearestPointController/*= TextEditingController()*/;

  final TextEditingController pickNameController/*= TextEditingController()*/;

  final TextEditingController pickPhoneController/*= TextEditingController()*/;

  final CustomDeliveryBloc deliveryBloc;

  PickupLocationCustom(
      Key key,
      this.pageController,
      this.icon,
      this.pickNearestPointController,
      this.pickNameController,
      this.pickPhoneController,
      this.deliveryBloc)
      : super(key: key);

  @override
  PickupLocationCustomState createState() => PickupLocationCustomState();
}

class PickupLocationCustomState extends State<PickupLocationCustom> {
  MapBloc _mapBloc;
  TextEditingController _localityController = TextEditingController();
  GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  GoogleMapController mapController;
  // Prediction prediction;

  @override
  void initState() {
    super.initState();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _mapBloc.add(FetchCurrentLocation());
  }

  @override
  void dispose() {
    _localityController.dispose();
    // widget.pickNearestPointController.dispose();
    // widget.pickNameController.dispose();
    // widget.pickPhoneController.dispose();
    super.dispose();
  }

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
                    Icons.location_on, Theme.of(context).primaryColor);
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
        widget.deliveryBloc.add(PickupSelectedEvent(
          pickupLatLng: state.latLng,
          pickupAddressFormatted: state.formattedAddress,
        ));
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: MyMapWidget(
                _myMapStateKey,
                MyMapData(
                  LatLng(0.0, 0.0),
                  Map(),
                  Set(),
                  true,
                ),
                (LatLng latLng) => _mapBloc.add(SetLocation(latLng)),
              ),
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
                      // prediction = await PlacesAutocomplete.show(
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
                      widget.icon /*Icons.location_on*/,
                      color: theme.primaryColor,
                    ),
                    hint: widget.icon == Icons.location_on
                        ? locale.pickupHint
                        : widget.icon == Icons.local_pizza
                            ? locale.searchRes
                            : locale.searchStore,
                  ),
                ),
                // BlocBuilder<AddressBloc, AddressState>(
                //   builder: (context, addressState) {
                //     if (addressState is SuccessAddressState) {
                //       if (addressState.addresses.length != 0) {
                //         return Container(
                //           decoration: BoxDecoration(
                //             boxShadow: [boxShadow],
                //             color: kWhiteColor,
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(15.0)),
                //           ),
                //           padding: EdgeInsets.symmetric(
                //             vertical: 12.0,
                //             horizontal: 20.0,
                //           ),
                //           margin: EdgeInsetsDirectional.only(
                //               start: 16.0, end: 10.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.stretch,
                //             children: <Widget>[
                //               Text(locale.savedAddresses,
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .caption
                //                       .copyWith(color: theme.hintColor)),
                //               ListView.builder(
                //                   shrinkWrap: true,
                //                   itemCount: addressState.addresses.length,
                //                   itemBuilder: (context, index) {
                //                     return InkWell(
                //                       onTap: () {},
                //                       child: buildListTile(
                //                           addressState.addresses[index].title),
                //                     );
                //                   }),
                //             ],
                //           ),
                //         );
                //       } else {
                //         return SizedBox.shrink();
                //       }
                //     } else if (addressState is FailureAddressState) {
                //       return Center(child: Text('Network Failure'));
                //     } else {
                //       return CircularProgressIndicator();
                //     }
                //   },
                // ),
                // SizedBox(height: 8),
                // Container(
                //   decoration: BoxDecoration(
                //     boxShadow: [boxShadow],
                //     color: kWhiteColor,
                //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                //   ),
                //   margin:
                //   EdgeInsetsDirectional.only(start: 16.0, end: 10.0),
                //   padding: EdgeInsets.symmetric(
                //     vertical: 12.0,
                //     horizontal: 20.0,
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       Text(
                //         locale.recentSearch,
                //         style: Theme.of(context)
                //             .textTheme
                //             .caption
                //             .copyWith(color: theme.hintColor),
                //       ),
                //       buildListTile(
                //         'City Centre',
                //         icon: Icons.restore,
                //       ),
                //       buildListTile(
                //         'Walmart Campus',
                //         icon: Icons.restore,
                //       ),
                //       buildListTile(
                //         'Golden Point',
                //         icon: Icons.restore,
                //       ),
                //     ],
                //   ),
                // )
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
                      ) /*ListTile(
                              leading:
                              Icon(Icons.navigation, color: theme.primaryColor),
                              title: Text(
                                state.formattedAddress,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            )*/
                      ,
                    ),
                    Container(
                      color: theme.backgroundColor,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          // AddressField(
                          //   controller: widget.pickNearestPointController,
                          //   icon: Icon(Icons.star,
                          //       size: 20, color: theme.primaryColor),
                          //   hint: 'Nearest point',
                          //   color: kButtonColor,
                          // ),
                          // SizedBox(height: 4),
                          AddressField(
                            controller: widget.pickNameController,
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
                            controller: widget.pickPhoneController,
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
          ],
        ),
      ),
    );
  }

  void submitData() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_mapBloc.state.latLng == null ||
        _mapBloc.state.latLng == LatLng(0.0, 0.0)) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("pickupSelect"));
    } else if (widget.pickNameController.text == null ||
        widget.pickNameController.text.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("err_name_valid"));
    } else if (widget.pickPhoneController.text == null ||
        widget.pickPhoneController.text.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("phoneHint"));
    } else {
      widget.deliveryBloc.add(PickupSelectedEvent(
        pickupLatLng: _mapBloc.state.latLng,
        pickupName: widget.pickNameController.text,
        pickupPhoneNumber: widget.pickPhoneController.text,
      ));
      Future.delayed(Duration(milliseconds: 300), () {
        widget.pageController.animateToPage(1,
            duration: Duration(milliseconds: 350),
            curve: Curves.linearToEaseOut);
      });
    }
  }

  ListTile buildListTile(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: text.contains('home')
          ? Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            )
          : text.contains('office')
              ? Image.asset(
                  'images/ic_officeblk.png',
                  color: Theme.of(context).primaryColor,
                  scale: 3.5,
                )
              : Icon(
                  Icons.business,
                  color: Theme.of(context).primaryColor,
                ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      dense: true,
    );
  }
}
