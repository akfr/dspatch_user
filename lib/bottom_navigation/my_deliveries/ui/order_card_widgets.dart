import 'dart:async';

import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/order/get/order_data.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/track_delivery.dart';
import 'package:dspatch_user/utility_functions/string_extension.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

class OrderCardWidget {
  static orderCard(OrderData orderData) {
    return OrderDetail(orderData);
  }

  static orderHeading(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Theme.of(context).hoverColor.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  static orderStatus(Key key, OrderData orderToShow, int type) {
    return _OrderDetailStatus(key, orderToShow, type);
  }
}

class _OrderDetailStatus extends StatefulWidget {
  final OrderData orderData;
  final int type;

  _OrderDetailStatus(Key key, this.orderData, this.type) : super(key: key);

  @override
  OrderDetailStatusState createState() => OrderDetailStatusState();
}

class OrderDetailStatusState extends State<_OrderDetailStatus> {
  Timer _timer;
  int _dateTimeMillisAgainst;
  String timerText;
  AppLocalizations _locale;
  OrderData orderToShow;

  @override
  void initState() {
    orderToShow = widget.orderData;
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context);
    _checkRunTimer();
    var theme = Theme.of(context);
    return widget.type == 1
        ? RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: (timerText == null
                          ? _locale.getTranslationOf(
                              "order_status_" + orderToShow.status)
                          : timerText) +
                      '\n',
                  style: theme.textTheme.bodyText1.copyWith(
                      color: theme.primaryColor,
                      height: 1.5,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: Helper().getSettingValue("currency_icon") +
                      orderToShow.total.toString(),
                  style: theme.textTheme.subtitle1
                      .copyWith(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          )
        : Text(
            (timerText == null
                ? _locale.getTranslationOf("order_status_" + orderToShow.status)
                : timerText),
            //"${_locale.getTranslationOf(orderToShow.status == "accepted" ? "picking" : "delivering")} ${Moment.now().from(DateTime.fromMillisecondsSinceEpoch(DateTime.now().add(Duration(seconds: 1000)).millisecondsSinceEpoch))}",
            style: theme.textTheme.subtitle2.copyWith(
              color: kMainColor,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  void _checkRunTimer() {
    if (_dateTimeMillisAgainst == null) {
      if ((orderToShow.status == "accepted" &&
              orderToShow.meta.estimated_time_pickup != null) ||
          (orderToShow.status == "dispatched" &&
              orderToShow.meta.estimated_time_delivery != null)) {
        try {
          int estimatedTimeValue = int.parse((orderToShow.status == "accepted"
              ? orderToShow.meta.estimated_time_pickup
              : orderToShow.meta.estimated_time_delivery));
          if (estimatedTimeValue > DateTime.now().millisecondsSinceEpoch) {
            _dateTimeMillisAgainst = estimatedTimeValue;
          }
        } catch (e) {
          print("estimatedTimeValue parse error: $e");
        }
      }
      if (_dateTimeMillisAgainst != null) {
        //for initial text.
        if (_dateTimeMillisAgainst > DateTime.now().millisecondsSinceEpoch) {
          setState(() {
            timerText = _locale.getTranslationOf(
                    orderToShow.status == "accepted"
                        ? "picking"
                        : "delivering") +
                " " +
                Moment.now().from(DateTime.fromMillisecondsSinceEpoch(
                    _dateTimeMillisAgainst));
            _dateTimeMillisAgainst -= 1000;
          });
        }

        const oneSec = const Duration(seconds: 30);
        //then for every 30 seconds.
        _timer = new Timer.periodic(
          oneSec,
          (Timer timer) {
            if (DateTime.now().millisecondsSinceEpoch >=
                _dateTimeMillisAgainst) {
              setState(() {
                timerText = null;
                timer.cancel();
              });
            } else {
              setState(() {
                timerText =
                    "${_locale.getTranslationOf(orderToShow.status == "accepted" ? "picking" : "delivering")} ${Moment.now().from(DateTime.fromMillisecondsSinceEpoch(_dateTimeMillisAgainst))}";
                _dateTimeMillisAgainst -= 1000;
              });
            }
          },
        );
      }
    }
  }

  void updateOrder(OrderData newOrder) {
    setState(() {
      _dateTimeMillisAgainst = null;
      orderToShow = newOrder;
    });
  }
}

class OrderDetail extends StatelessWidget {
  final OrderData orderDetails;

  OrderDetail(this.orderDetails);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackDeliveryPage(orderDetails))),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
              boxShadow: [boxShadow],
              borderRadius: BorderRadius.circular(10.0),
              color: theme.backgroundColor),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: Image.asset(
                      orderDetails.meta.order_category == 'grocery'
                          ? 'images/home3.png'
                          : orderDetails.meta.order_category == 'food'
                              ? 'images/home2.png'
                              : 'images/home1.png',
                      scale: 4.5),
                  title: Text(
                    (orderDetails.meta.order_category ?? "").capitalize(),
                    style: theme.textTheme.subtitle1.copyWith(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    Helper.setupDate(orderDetails.createdAt),
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 14),
                  ),
                  trailing: _OrderDetailStatus(null, orderDetails, 1),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        (orderDetails.sourceAddress.name ??
                                AppLocalizations.of(context)
                                    .getTranslationOf("no_name"))
                            .capitalize(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption
                            .copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: theme.primaryColor,
                      size: 21.0,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "•••••••••",
                      style: theme.textTheme.caption
                          .copyWith(color: theme.hoverColor.withOpacity(0.7)),
                    ),
                    Icon(
                      Icons.navigation,
                      color: theme.primaryColor,
                      size: 21.0,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Text(
                        (orderDetails.address.name ??
                                AppLocalizations.of(context)
                                    .getTranslationOf("no_name"))
                            .capitalize(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption
                            .copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
