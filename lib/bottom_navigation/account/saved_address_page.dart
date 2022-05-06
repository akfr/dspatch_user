import 'dart:async';

import 'package:dspatch_user/bottom_navigation/account/bloc/address_bloc.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/address_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/address_state.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/components/address_field.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/maps/bloc/map_bloc.dart';
import 'package:dspatch_user/maps/bloc/map_event.dart';
import 'package:dspatch_user/maps/bloc/map_state.dart';
import 'package:dspatch_user/models/address/getaddress_json.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

class SavedAddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
          create: (BuildContext context) =>
              AddressBloc()..add(FetchAddressesEvent()),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(),
        ),
      ],
      child: SavedAddressesBody(),
    );
  }
}

class SavedAddressesBody extends StatefulWidget {
  @override
  _SavedAddressesBodyState createState() => _SavedAddressesBodyState();
}

class _SavedAddressesBodyState extends State<SavedAddressesBody> {
  static int _currentIndex = 0;
  Completer<GoogleMapController> _controller = Completer();
  PageController _pageController = PageController(initialPage: _currentIndex);

  AddressBloc _addressBloc;
  MapBloc _mapBloc;

  List<GetAddress> addressesList = [
    GetAddress(
        0,
        'Home',
        'meta',
        'Please select a location',
        'address1',
        'address2',
        'country',
        'state',
        'city',
        'postcode',
        77.4977,
        27.2046,
        0),
    GetAddress(
        1,
        'Office',
        'meta',
        'Please select a location',
        'address1',
        'address2',
        'country',
        'state',
        'city',
        'postcode',
        77.4977,
        27.2046,
        1),
    GetAddress(
        2,
        'Business',
        'meta',
        'Please select a location',
        'address1',
        'address2',
        'country',
        'state',
        'city',
        'postcode',
        77.4977,
        27.2046,
        2),
  ];

  @override
  void initState() {
    super.initState();
    _addressBloc = BlocProvider.of<AddressBloc>(context);
    _mapBloc = BlocProvider.of<MapBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          child: Column(
            children: [
              Spacer(),
              CustomAppBar(title: locale.savedAddresses),
              Spacer(),
              Container(
                height: mediaQuery.size.height * 0.85,
                width: MediaQuery.of(context).size.width,
                child: BlocListener<AddressBloc, AddressState>(
                  listener: (context, state) {},
                  child: BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      if (state is SuccessAddressState) {
                        return Row(
                          children: [
                            Container(
                                width: 68,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    buildAddressButton(
                                      0,
                                      Icon(
                                        Icons.home,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    buildAddressButton(
                                        1,
                                        ImageIcon(
                                          AssetImage('images/ic_officewt.png'),
                                          color: theme.primaryColor,
                                        )),
                                    SizedBox(height: 20.0),
                                    buildAddressButton(
                                      2,
                                      Icon(
                                        Icons.business,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              child: PageView.builder(
                                physics: BouncingScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemCount: 3 /*state.addresses.length*/,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return buildAddressContainer(
                                      state.addresses.length == 0
                                          ? addressesList[index]
                                          : state.addresses.length == 1
                                              ? index == 0
                                                  ? state.addresses[0]
                                                  : addressesList[index]
                                              : state.addresses.length == 2
                                                  ? index <= 1
                                                      ? state.addresses[index]
                                                      : addressesList[index]
                                                  : state.addresses.length == 3
                                                      ? state.addresses[index]
                                                      : null,
                                      index,
                                      state.addresses.length);
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (state is FailureAddressState) {
                        return Center(
                          child: Text(
                            'Network Failed!',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildAddressButton(int index, Widget icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        _pageController.animateToPage(_currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
      },
      child: CircleAvatar(
          radius: 24,
          backgroundColor: _currentIndex == index
              ? Theme.of(context).backgroundColor
              : kNavigationButtonColor,
          child: icon),
    );
  }

  Widget buildAddressContainer(GetAddress address, int index, int length) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) async {
        if (state.toAnimateCamera) {
          GoogleMapController controller = await _controller.future;
          CameraUpdate cameraUpdate = CameraUpdate.newLatLng(state.latLng);
          await controller.animateCamera(cameraUpdate);
          _mapBloc.add(MarkerMovedEvent());
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, mapState) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(address.latitude, address.longitude),
                    zoom: 10.0,
                  ),
                  mapType: MapType.normal,
                  onCameraMove: mapState.toAnimateCamera ? null : onCameraMove,
                  padding: EdgeInsets.only(top: 100),
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted)
                      _controller.complete(controller);
                  },
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [boxShadow]),
                  margin: EdgeInsets.all(16.0),
                  child: AddressField(
                    readOnly: true,
                    initialValue: address.title,
                    icon: address.title == locale.office
                        ? Image.asset(
                            'images/ic_officewt.png',
                            scale: 3.5,
                            color: theme.primaryColor,
                          )
                        : Icon(
                            address.title == locale.homeText
                                ? Icons.home
                                : Icons.business,
                            size: 20,
                            color: theme.primaryColor),
                    suffix: Icon(Icons.search, color: theme.hintColor),
                    border: BorderSide.none,
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
                      // _mapBloc.add(LocationSelectedEvent(prediction));
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: <Widget>[
                      // Spacer(),
                      Container(
                          decoration: BoxDecoration(
                            color: kButtonColor,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(35.0)),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.navigation,
                                color: theme.primaryColor),
                            title: Text(
                              address.formattedAddress ==
                                      'Please select a location'
                                  ? mapState.formattedAddress == ''
                                      ? 'Please select a location'
                                      : mapState.formattedAddress
                                  : address.formattedAddress,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )),
                      Container(
                        color: theme.backgroundColor,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AddressField(
                              icon: Icon(Icons.star,
                                  size: 20, color: theme.primaryColor),
                              initialValue: address.title,
                              color: kButtonColor,
                            ),
                            SizedBox(height: 4),
                            AddressField(
                              icon: Icon(Icons.person,
                                  size: 20, color: theme.primaryColor),
                              initialValue: address.id.toString(),
                              suffix: Icon(Icons.contacts,
                                  color: theme.primaryColor, size: 20),
                              color: kButtonColor,
                            ),
                            SizedBox(height: 4),
                            AddressField(
                              icon: Icon(Icons.phone,
                                  size: 20, color: theme.primaryColor),
                              initialValue: address.id.toString(),
                              color: kButtonColor,
                            ),
                            CustomButton(
                              radius: BorderRadius.circular(35.0),
                              padding: 10,
                              text: '     ' + locale.saveAddress2 + '     ',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onCameraMove(CameraPosition position) {
    _mapBloc.add(UpdateCameraPositionEvent(position));
  }
}
