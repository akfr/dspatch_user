import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_bloc.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_event.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_state.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/ui/order_card_widgets.dart';
import 'package:dspatch_user/components/my_map_widget.dart';
import 'package:dspatch_user/components/solid_bottom_sheet.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/utility_functions/string_extension.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_moment/simple_moment.dart';

import 'components/toaster.dart';

class TrackDeliveryPage extends StatelessWidget {
  final OrderData orderData;

  TrackDeliveryPage(this.orderData);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (BuildContext context) => OrderBloc(),
      child: TrackDeliveryBody(orderData),
    );
  }
}

class TrackDeliveryBody extends StatefulWidget {
  final OrderData _orderData;

  TrackDeliveryBody(this._orderData);

  OrderData get getOrderData => _orderData;

  @override
  _TrackDeliveryBodyState createState() => _TrackDeliveryBodyState();
}

class _TrackDeliveryBodyState extends State<TrackDeliveryBody> {
  OrderData orderToShow;
  OrderBloc _orderBloc;

  //map data
  LatLng _latLngDelivery;

  GlobalKey<OrderDetailStatusState> _orderStatusStateKey = GlobalKey();
  GlobalKey<MyMapState> _myMapStateKey = GlobalKey();
  GlobalKey<SolidBottomSheetState> _bottomSheetWidgetKey = GlobalKey();

  bool _isBottomSheetOpen = false;
  AppLocalizations _locale;
  ThemeData _theme;

  @override
  void initState() {
    orderToShow = widget.getOrderData;
    super.initState();
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _orderBloc.add(FetchOrderUpdatesEvent(orderToShow));
    _orderBloc.add(FetchOrderMapEvent(orderToShow, true));
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context);
    _theme = Theme.of(context);
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (previousState, state) {
        return state is SuccessOrderMapState ||
            state is SuccessOrderDeliveryLocationUpdatedState ||
            (state is SuccessOrderUpdatedState &&
                state.order != null &&
                Moment.parse(state.order.updatedAt)
                        .date
                        .millisecondsSinceEpoch >
                    Moment.parse(orderToShow.updatedAt)
                        .date
                        .millisecondsSinceEpoch);
      },
      listener: (context, state) {
        if (state is SuccessOrderUpdatedState) {
          bool hadDelivery = orderToShow.delivery != null &&
              orderToShow.delivery.delivery != null;
          bool hasDelivery = state.order.delivery != null &&
              state.order.delivery.delivery != null;
          orderToShow = state.order;
          //refresh order status
          if (_orderStatusStateKey.currentState != null)
            _orderStatusStateKey.currentState.updateOrder(orderToShow);
          //refresh bottom sheet
          if (hasDelivery && !hadDelivery) {
            BlocProvider.of<OrderBloc>(context)
                .add(FetchOrderMapEvent(orderToShow, false));
            if (_bottomSheetWidgetKey.currentState != null)
              _bottomSheetWidgetKey.currentState.setState(() {});
          }
        }
        if (state is SuccessOrderMapState) {
          if (_myMapStateKey.currentState != null)
            _myMapStateKey.currentState.buildWith(state.toMapData());
        }
        if (state is SuccessOrderDeliveryLocationUpdatedState) {
          if (_latLngDelivery == null || _latLngDelivery != state.latLng) {
            _latLngDelivery = state.latLng;
            if (_myMapStateKey.currentState != null && state.show)
              _myMapStateKey.currentState
                  .updateMarkerLocation("marker_delivery", _latLngDelivery);
          }
        }
      },
      child: WillPopScope(
        child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: AppBar(
                  iconTheme: IconThemeData(color: _theme.primaryColor),
                  title: Text(
                    "${_locale.getTranslationOf("order_id")} #${orderToShow.id}",
                    style: _theme.textTheme.headline5
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                ListTile(
                  leading: Image.asset(
                    orderToShow.meta.order_category == 'grocery'
                        ? 'images/home3.png'
                        : orderToShow.meta.order_category == 'food'
                            ? 'images/home2.png'
                            : 'images/home1.png',
                  ),
                  title: Text(
                    (orderToShow.meta.order_category ?? "").capitalize(),
                    style: _theme.textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    Helper.setupDate(orderToShow.createdAt),
                    style: _theme.textTheme.subtitle2
                        .copyWith(color: Color(0xffc1c1c1), fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OrderCardWidget.orderStatus(
                          _orderStatusStateKey, orderToShow, 2),
                      Text(
                          Helper().getSettingValue("currency_icon") +
                              orderToShow.total.toString(),
                          style: _theme.textTheme.subtitle2
                              .copyWith(color: Color(0xffc1c1c1))),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40)),
                    child: MyMapWidget(
                      _myMapStateKey,
                      MyMapData(
                        LatLng(orderToShow.address.latitude,
                            orderToShow.address.longitude),
                        Map(),
                        Set(),
                        true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: SolidBottomSheet(
              key: _bottomSheetWidgetKey,
              maxHeight: 350,
              onShow: () {
                if (!_isBottomSheetOpen)
                  setState(() => _isBottomSheetOpen = true);
              },
              onHide: () {
                if (_isBottomSheetOpen)
                  setState(() => _isBottomSheetOpen = false);
              },
              headerBar: getBottomHeader(),
              body: getBottomBody(),
            )),
        onWillPop: onBackPressed,
      ),
    );
  }

  Future<bool> onBackPressed() async {
    // You can do some work here.
    // Returning true allows the pop to happen, returning false prevents it.
    if (_bottomSheetWidgetKey != null &&
        _bottomSheetWidgetKey.currentState != null) {
      if (_bottomSheetWidgetKey.currentState.isOpened) {
        _bottomSheetWidgetKey.currentState.hide();
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  getBottomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: <Widget>[
          if (orderToShow.delivery != null &&
              orderToShow.delivery.delivery != null)
            Container(
                decoration: BoxDecoration(
                    boxShadow: [boxShadow],
                    color: _theme.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(35.0))),
                child: ListTile(
                    leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: orderToShow.delivery.delivery.user.image_url !=
                                    null &&
                                orderToShow
                                    .delivery.delivery.user.image_url.isNotEmpty
                            ? NetworkImage(
                                orderToShow.delivery.delivery.user.image_url)
                            : AssetImage('images/empty_dp.png')),
                    title: Text(orderToShow.delivery.delivery.user.name,
                        style: _theme.textTheme.headline6
                            .copyWith(color: _theme.primaryColorDark)),
                    subtitle: Text(_locale.deliveryMan,
                        style: _theme.textTheme.subtitle2.copyWith(
                            color: _theme.hintColor.withOpacity(0.7))),
                    trailing: GestureDetector(
                        onTap: () async {
                          //if (!orderToShow.isComplete()) {
                          bool success = await Helper.launchUrl(
                              "tel:${orderToShow.delivery.delivery.user.mobileNumber}");
                          if (!success)
                            Toaster.showToastBottom(
                                "${_locale.getTranslationOf("unable_dial")}: ${orderToShow.delivery.delivery.user.mobileNumber}");
                          //}
                        },
                        child: CircleAvatar(
                            radius: 22.0,
                            backgroundColor: kMainColor,
                            child: Icon(Icons.phone, size: 16.3, color: kWhiteColor))))),
          if (orderToShow.delivery != null &&
              orderToShow.delivery.delivery != null)
            SizedBox(height: 10.0),
          Stack(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow],
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(35.0),
                      topRight: const Radius.circular(35.0),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ListTile(
                        leading: Icon(Icons.location_on, color: kMainColor),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: orderToShow.sourceAddress.name ??
                                    _locale.getTranslationOf("no_name"),
                                style: _theme.textTheme.headline6.copyWith(
                                  color: _theme.primaryColorDark,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          orderToShow.sourceAddress.formattedAddress ??
                              _locale.getTranslationOf("no_address"),
                          style:
                              _theme.textTheme.bodyText1.copyWith(height: 1.5),
                        ),
                      ),
                      PositionedDirectional(
                        top: 56,
                        start: 16,
                        child: Icon(
                          Icons.more_vert,
                          color: _theme.dividerColor,
                        ),
                      ),
                    ],
                  )),
              PositionedDirectional(
                top: 10.0,
                end: 16.0,
                child: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: kMainColor,
                  child: Icon(
                    _isBottomSheetOpen
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  getBottomBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(35.0),
                  bottomRight: const Radius.circular(35.0),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ListTile(
                    leading: Icon(Icons.navigation, color: kMainColor),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: orderToShow.address.name ??
                                _locale.getTranslationOf("no_name"),
                            style: _theme.textTheme.headline6.copyWith(
                              color: _theme.primaryColorDark,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      orderToShow.address.formattedAddress ??
                          _locale.getTranslationOf("no_address"),
                      style: _theme.textTheme.bodyText1.copyWith(height: 1.5),
                    ),
                  ),
                  PositionedDirectional(
                    top: -16,
                    start: 16,
                    child: Icon(
                      Icons.more_vert,
                      color: _theme.dividerColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [boxShadow],
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                ),
                child: Column(children: <Widget>[
                  orderToShow.meta.order_category == 'courier'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "${_locale.courierType}\n",
                                  style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7)),
                                ),
                                TextSpan(
                                  text: orderToShow.orderType == 'CUSTOM'
                                      ? orderToShow.meta.courier_type
                                      : orderToShow.orderType,
                                  style: _theme.textTheme.bodyText1
                                      .copyWith(fontSize: 16),
                                ),
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "${_locale.frangible}\n",
                                  style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7)),
                                ),
                                TextSpan(
                                  text: _locale.getTranslationOf(
                                      orderToShow.meta.frangible
                                          ? 'yes'
                                          : 'no'),
                                  style: _theme.textTheme.bodyText1
                                      .copyWith(fontSize: 16),
                                ),
                              ]),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _locale.getTranslationOf("food_items"),
                                    style: _theme.textTheme.subtitle2.copyWith(
                                        color:
                                            _theme.hintColor.withOpacity(0.7)),
                                  ),
                                  Text(
                                    _locale.getTranslationOf("quantity"),
                                    style: _theme.textTheme.subtitle2.copyWith(
                                        color:
                                            _theme.hintColor.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderToShow.meta.foodItems.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          orderToShow
                                              .meta.foodItems[index].itemName,
                                          style: _theme.textTheme.subtitle2
                                              .copyWith(
                                                  color:
                                                      _theme.primaryColorDark,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                      Text(
                                          orderToShow
                                              .meta.foodItems[index].quantity,
                                          style: _theme.textTheme.subtitle2
                                              .copyWith(
                                                  color:
                                                      _theme.primaryColorDark,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                    ],
                                  );
                                }),
                          ],
                        ),
                  SizedBox(height: 16),
                  orderToShow.meta.order_category == 'courier'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "${_locale.height} ${_locale.width} ${_locale.length}\n",
                                  style: _theme.textTheme.subtitle2.copyWith(
                                      color: _theme.hintColor.withOpacity(0.7)),
                                ),
                                TextSpan(
                                  text: "${orderToShow.meta.lwh} (cm)",
                                  style: _theme.textTheme.bodyText1
                                      .copyWith(fontSize: 16),
                                ),
                              ]),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${_locale.weight}\n",
                                    style: _theme.textTheme.subtitle2.copyWith(
                                        color:
                                            _theme.hintColor.withOpacity(0.7)),
                                  ),
                                  TextSpan(
                                    text: "${orderToShow.meta.weight} kg",
                                    style: _theme.textTheme.bodyText1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 16),
                  Row(children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "${_locale.getTranslationOf("addinfo")}\n",
                        style: _theme.textTheme.subtitle2
                            .copyWith(color: _theme.hintColor.withOpacity(0.7)),
                      ),
                      TextSpan(
                          text: orderToShow.notes ??
                              _locale.getTranslationOf("null"),
                          style:
                              _theme.textTheme.bodyText1.copyWith(fontSize: 16))
                    ]))
                  ])
                ])),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  // ListTile(
                  //   title: Text(
                  //     "Service Charge",
                  //     style: Theme.of(context).textTheme.bodyText1,
                  //   ),
                  //   trailing: Text(
                  //     Helper().getSettingValue("currency_icon") +
                  //         getServiceFee(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline6
                  //         .copyWith(color: _theme.primaryColorDark),
                  //   ),
                  // ),
                  ListTile(
                    title: Text(
                      orderToShow.deliveryMode.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text(orderToShow.payment.paymentMethod.title,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Color(0xffc2c2c2), fontSize: 11.7)),
                    trailing: Text(
                      Helper().getSettingValue("currency_icon") +
                          orderToShow.deliveryMode.price.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: _theme.primaryColorDark),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  // String getServiceFee() {
  //   var taxInPercent = Helper().getSettingValue("tax_in_percent").isEmpty
  //       ? "0"
  //       : Helper().getSettingValue("tax_in_percent");
  //   return ((double.parse(taxInPercent) * orderToShow.deliveryMode.price) / 100)
  //       .toString();
  // }
}
