import 'dart:async';

import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/components/address_field.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/error_final_widget.dart';
import 'package:dspatch_user/components/my_map_widget.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_bloc.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_event.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_state.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/vendors/vendordata.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupLocation extends StatefulWidget {
  final IconData icon;
  final PageController pageController;
  final FoodDeliveryBloc foodDeliveryBloc;
  final bool isGroceryOrder;

  PickupLocation(this.pageController, this.icon, this.foodDeliveryBloc,
      this.isGroceryOrder);

  @override
  PickupLocationState createState() => PickupLocationState();
}

class PickupLocationState extends State<PickupLocation> {
  GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  TextEditingController _localityController = TextEditingController();
  // TextEditingController _nearestPointController = TextEditingController();
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _phoneController = TextEditingController();
  StoreBloc _storeBloc;
  Vendor _myVendor;
  Timer _debounce;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _storeBloc = BlocProvider.of<StoreBloc>(context);
  }

  @override
  void dispose() {
    _localityController.dispose();
    // _nearestPointController.dispose();
    // _nameController.dispose();
    // _phoneController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return BlocConsumer<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is SuccessStoreState) {
          _myVendor = null;
          _localityController.text = state.filterText;
          List<Vendor> vendorsToUse = [];
          vendorsToUse.addAll(
              state.showOnly != null && state.showOnly.isNotEmpty
                  ? state.showOnly
                  : state.vendors);

          if (vendorsToUse.length == 1) _myVendor = vendorsToUse.first;

          if (_myMapStateKey.currentState != null)
            _doMapStuff(vendorsToUse);
          else
            Future.delayed(
                Duration(milliseconds: 1000), () => _doMapStuff(vendorsToUse));
        }
      },
      builder: (context, storeState) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: storeState is SuccessStoreState &&
                  storeState.vendors.isNotEmpty
              ? Stack(
                  children: [
                    MyMapWidget(
                      _myMapStateKey,
                      MyMapData(
                        LatLng(0.0, 0.0),
                        Map(),
                        Set(),
                        true,
                      ),
                      (LatLng latLng) {
                        setState(() {
                          _myVendor = null;
                        });
                      },
                      (String markerId) {
                        _myMapStateKey.currentState
                            .moveCameraToMarker(markerId);
                        _myMapStateKey.currentState.moveCameraToXY(0, 110);

                        for (Vendor vendor in storeState.vendors) {
                          if (vendor.id.toString() ==
                              markerId
                                  .substring(markerId.lastIndexOf("_") + 1)) {
                            _myVendor =
                                (_myVendor == null || _myVendor.id != vendor.id)
                                    ? vendor
                                    : null;
                            break;
                          }
                        }
                        setState(() {});
                      },
                    ),
                    Column(
                      children: [
                        //  _localityController.text =
                        //         _searchText == null || _searchText.isEmpty
                        //             ? state.pickupAddress
                        //             : _searchText;
                        Container(
                          decoration: BoxDecoration(boxShadow: [boxShadow]),
                          margin: EdgeInsetsDirectional.only(
                              top: 16.0, start: 16.0, end: 10.0),
                          child: AddressField(
                            // readOnly: true,
                            // onTap: () async {
                            //   Prediction prediction =
                            //       await PlacesAutocomplete.show(
                            //     context: context,
                            //     apiKey: AppConfig.mapsApiKey,
                            //     language: AppConfig.languageDefault ?? 'en',
                            //     mode: Mode.overlay,
                            //     components: MapRepository.searchableComponents,
                            //     onError: (response) {
                            //       print(response);
                            //     },
                            //   );
                            //   onLocationSelected(prediction);
                            // },
                            onChanged: (s) {
                              if (s.trim().length > 2) _triggerSearch(s.trim());
                            },
                            controller: _localityController,
                            color: theme.backgroundColor,
                            icon: Icon(
                              widget.icon /*Icons.location_on*/,
                              color: theme.primaryColor,
                            ),
                            suffix: _localityController.text == null ||
                                    _localityController.text.isEmpty
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () => _storeBloc
                                        .add(StoresFilterEvent([], "")),
                                    child: Icon(
                                      Icons.clear /*Icons.location_on*/,
                                      color: kDisabledColor,
                                    ),
                                  ),
                            hint: widget.icon == Icons.location_on
                                ? locale.pickupHint
                                : locale.getTranslationOf(widget.isGroceryOrder
                                    ? 'searchStore'
                                    : 'searchRes'),
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
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.stretch,
                        //             children: <Widget>[
                        //               Text(locale.savedAddresses,
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .caption
                        //                       .copyWith(
                        //                           color: theme.hintColor)),
                        //               ListView.builder(
                        //                   shrinkWrap: true,
                        //                   itemCount:
                        //                       addressState.addresses.length,
                        //                   itemBuilder: (context, index) {
                        //                     return InkWell(
                        //                       onTap: () {},
                        //                       child: buildListTile(addressState
                        //                           .addresses[index].title),
                        //                     );
                        //                   }),
                        //             ],
                        //           ),
                        //         );
                        //       } else {
                        //         return SizedBox.shrink();
                        //       }
                        //     } else if (state is FailureAddressState) {
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
                        _myVendor != null
                            ? Column(
                                children: [
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 24.0, vertical: 16),
                                  //   decoration: BoxDecoration(
                                  //     color: kButtonColor,
                                  //     borderRadius: BorderRadius.vertical(
                                  //         top: Radius.circular(35.0)),
                                  //   ),
                                  //   child: Row(
                                  //     children: [
                                  //       Icon(
                                  //         widget.isGroceryOrder
                                  //             ? Icons.store
                                  //             : Icons.person,
                                  //         color: theme.primaryColor,
                                  //         size: 20,
                                  //       ),
                                  //       SizedBox(
                                  //         width: 16,
                                  //       ),
                                  //       Expanded(
                                  //         child: Text(
                                  //           _myVendor.name ?? "",
                                  //           style: Theme.of(context)
                                  //               .textTheme
                                  //               .bodyText1,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    color: theme.backgroundColor,
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: kButtonColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                widget.isGroceryOrder
                                                    ? Icons.store
                                                    : Icons.person,
                                                color: theme.primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _myVendor.name ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: kButtonColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
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
                                                child: Text(
                                                  _myVendor.address ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: kButtonColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35.0)),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: theme.primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _myVendor
                                                          .user?.mobileNumber ??
                                                      "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        CustomButton(
                                          radius: BorderRadius.circular(35.0),
                                          padding: 10,
                                          text: '     ' +
                                              locale.continueText +
                                              '  ↓    ',
                                          onPressed: () {
                                            widget.foodDeliveryBloc.add(
                                                VendorSelectedEvent(_myVendor));
                                            Future.delayed(
                                              Duration(milliseconds: 300),
                                              () {
                                                widget
                                                    .pageController
                                                    .animateToPage(
                                                        1,
                                                        duration: Duration(
                                                            milliseconds: 350),
                                                        curve: Curves
                                                            .linearToEaseOut);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                )
              : Container(
                  color: kMapColor,
                  child: storeState is LoadingState
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        )
                      : ErrorFinalWidget.errorWithRetry(
                          context,
                          AppLocalizations.of(context).getTranslationOf(
                              storeState is FailureState
                                  ? "something_wrong"
                                  : (widget.isGroceryOrder
                                      ? "empty_stores"
                                      : "empty_restaurants")),
                          AppLocalizations.of(context).getTranslationOf("okay"),
                          (context) => Navigator.pop(context),
                        ),
                ),
        );
      },
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }

  _triggerSearch(String value) {
    if (_debounce != null && _debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      List<Vendor> results = [];

      if (_storeBloc.state is SuccessStoreState) {
        String valueToSearch = value != null ? value.toLowerCase().trim() : "";
        if (valueToSearch.isNotEmpty) {
          for (Vendor vendor
              in (_storeBloc.state as SuccessStoreState).vendors) {
            if ((vendor.name ?? "").toLowerCase().contains(valueToSearch) ||
                (vendor.tagline ?? "").toLowerCase().contains(valueToSearch) ||
                (vendor.area ?? "").toLowerCase().contains(valueToSearch) ||
                (vendor.address ?? "").toLowerCase().contains(valueToSearch) ||
                (vendor.details ?? "").toLowerCase().contains(valueToSearch)) {
              results.add(vendor);
            }
          }
        }
        _storeBloc.add(StoresFilterEvent(results, value));
      }

      if (results.isEmpty) {
        Toaster.showToastTop(
            AppLocalizations.of(context).getTranslationOf("empty_results"));
      }

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild.unfocus();
      }
    });
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

  _doMapStuff(List<Vendor> vendorsToUse) {
    if (_myMapStateKey.currentState != null)
      _myMapStateKey.currentState
          .buildWithVendors(vendorsToUse, widget.isGroceryOrder);

    if (vendorsToUse.length == 1)
      Future.delayed(Duration(milliseconds: 500),
          () => _myMapStateKey.currentState.moveCameraToXY(0, 110));
  }
}
