// import 'dart:async';
// import 'package:dspatch_user/bottom_navigation/account/bloc/address_bloc.dart';
// import 'package:dspatch_user/bottom_navigation/account/bloc/address_state.dart';
// import 'package:dspatch_user/components/address_field.dart';
// import 'package:dspatch_user/locale/locales.dart';
// import 'package:dspatch_user/maps/bloc/map_bloc.dart';
// import 'package:dspatch_user/maps/bloc/map_event.dart';
// import 'package:dspatch_user/maps/bloc/map_state.dart';
// import 'package:dspatch_user/maps/ui/location_page.dart';
// import 'package:dspatch_user/theme/colors.dart';
// import 'package:dspatch_user/theme/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:toast/toast.dart';
//
// class PickupLocation extends StatefulWidget {
//   final IconData icon;
//   final int currentIndex;
//   PickupLocation(this.currentIndex,this.icon);
//   @override
//   _PickupLocationState createState() => _PickupLocationState();
// }
//
// class _PickupLocationState extends State<PickupLocation> {
//   MapBloc _mapBloc;
//   Completer<GoogleMapController> _controller = Completer();
//   @override
//   Widget build(BuildContext context) {
//     var locale = AppLocalizations.of(context);
//     var theme  = Theme.of(context);
//       return BlocListener<MapBloc, MapState>(
//         listener: (context, state) async {
//           if (state.toAnimateCamera) {
//             GoogleMapController controller = await _controller.future;
//             CameraUpdate cameraUpdate = CameraUpdate.newLatLng(state.latLng);
//             await controller.animateCamera(cameraUpdate);
//             _mapBloc.add(MarkerMovedEvent());
//           }
//           if (state.goToHomePage) {
//             Navigator.pop(context, selectedAddress);
// //          Navigator.popAndPushNamed(context, PageRoutes.homeOrderAccountPage, arguments: selectedAddress);
//           } else if (state.goToLoginPage) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               child: AlertDialog(
//                 title: Text('AppLocalizations.of(context).notLogin'),
//                 content: Text('AppLocalizations.of(context).loginText'),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text(AppLocalizations.of(context).no),
//                     textColor: kMainColor,
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(color: kTransparentColor)),
//                     onPressed: () {
//                       Toast.show(
//                           'AppLocalizations.of(context).noLoginText', context,
//                           backgroundColor: Colors.black.withOpacity(0.75),
//                           duration: 2,
//                           gravity: Toast.TOP);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   FlatButton(
//                       child: Text(AppLocalizations.of(context).yes),
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(color: kTransparentColor)),
//                       textColor: kMainColor,
//                       onPressed: () {
//                         Navigator.pop(context);
//                         // Navigator.pushNamed(context, PageRoutes.loginNavigator);
//                       })
//                 ],
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
//           return   ClipRRect(
//             borderRadius: borderRadius,
//             child: Stack(
//                 children: [
//                   GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                         target: LatLng(
//                             state.latLng.latitude, state.latLng.longitude),
//                         zoom: 10.0,),
//                     onCameraMove: state.toAnimateCamera ? null : onCameraMove,
//                     mapType: MapType.normal,
//                     myLocationEnabled: true,
//                     zoomControlsEnabled: false,
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(boxShadow: [boxShadow]),
//                         margin:
//                         EdgeInsetsDirectional.only(top: 16.0, start: 16.0, end: 10.0),
//                         child: AddressField(
//                           color: theme.backgroundColor,
//                           icon: Icon(
//                               widget.icon/*Icons.location_on*/,
//                             color: theme.primaryColor,
//                           ),
//                           hint: widget.icon==Icons.location_on?locale.pickupHint:widget.icon==Icons.local_pizza?locale.searchRes:locale.searchStore,
//                         ),
//                       ),
//                       BlocBuilder<AddressBloc, AddressState>(
//                         builder: (context, state){
//                           if(state is SuccessAddressState){
//                             return Container(
//                               decoration: BoxDecoration(
//                                 boxShadow: [boxShadow],
//                                 color: kWhiteColor,
//                                 borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 vertical: 12.0,
//                                 horizontal: 20.0,
//                               ),
//                               margin:
//                               EdgeInsetsDirectional.only(start: 16.0, end: 10.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: <Widget>[
//                                   Text(locale.savedAddresses,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .caption
//                                           .copyWith(color: theme.hintColor)),
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                     itemCount: state.addresses.length,
//                                     itemBuilder: (context,index){
//                                       return buildListTile(state.addresses[index].title);
//                                     }
//                                 )
//                                 ],
//                               ),
//                             );
//                           } else{
//                             return SizedBox.shrink();
//                           }
//                         },
//                       ),
//                       // SizedBox(height: 8),
//                       // Container(
//                       //   decoration: BoxDecoration(
//                       //     boxShadow: [boxShadow],
//                       //     color: kWhiteColor,
//                       //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       //   ),
//                       //   margin:
//                       //   EdgeInsetsDirectional.only(start: 16.0, end: 10.0),
//                       //   padding: EdgeInsets.symmetric(
//                       //     vertical: 12.0,
//                       //     horizontal: 20.0,
//                       //   ),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.stretch,
//                       //     children: <Widget>[
//                       //       Text(
//                       //         locale.recentSearch,
//                       //         style: Theme.of(context)
//                       //             .textTheme
//                       //             .caption
//                       //             .copyWith(color: theme.hintColor),
//                       //       ),
//                       //       buildListTile(
//                       //         'City Centre',
//                       //         icon: Icons.restore,
//                       //       ),
//                       //       buildListTile(
//                       //         'Walmart Campus',
//                       //         icon: Icons.restore,
//                       //       ),
//                       //       buildListTile(
//                       //         'Golden Point',
//                       //         icon: Icons.restore,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ]
//             ),
//           );
//         }),
//       );
//   }
//
//   ListTile buildListTile(String text) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: text.contains('home')
//           ? Icon(
//         Icons.home,
//         color: Theme.of(context).primaryColor,
//       )
//           : text.contains('office')? Image.asset(
//         'images/ic_officeblk.png',
//         color: Theme.of(context).primaryColor,
//         scale: 3.5,
//       ) : Icon(
//         Icons.business,
//         color: Theme.of(context).primaryColor,
//       ),
//       title: Text(
//         text,
//         style: Theme.of(context).textTheme.bodyText1,
//       ),
//       dense: true,
//     );
//   }
//
//   void onCameraMove(CameraPosition position) {
//     _mapBloc.add(UpdateCameraPositionEvent(position));
//   }
// }
