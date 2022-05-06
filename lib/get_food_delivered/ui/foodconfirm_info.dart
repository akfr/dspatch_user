import 'package:dspatch_user/arrange_delivery/ui/bottom_list.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_state.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/payment/payment_page.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class Item {
  final String name;
  final String quantity;

  Item(this.name, this.quantity);
}

class FoodConfirmInfo extends StatefulWidget {
  final FoodDeliveryState state;
  final bool isGroceryOrder;

  FoodConfirmInfo(this.state, this.isGroceryOrder);

  @override
  _FoodConfirmInfoState createState() => _FoodConfirmInfoState();
}

class _FoodConfirmInfoState extends State<FoodConfirmInfo> {
  FoodDeliveryBloc _foodDeliveryBloc;
  double distanceinKm;

  void initState() {
    super.initState();
    _foodDeliveryBloc = BlocProvider.of<FoodDeliveryBloc>(context);
    distanceinKm = Geolocator.distanceBetween(
        widget.state.pickupLatLng.latitude,
        widget.state.pickupLatLng.longitude,
        widget.state.dropLatLng.latitude,
        widget.state.dropLatLng.longitude);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: borderRadius,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(
                  widget.isGroceryOrder ? Icons.store : Icons.local_pizza,
                  color: kMainColor),
              title: RichText(
                text: TextSpan(children: [
                  // TextSpan(
                  //   text: 'Walmart' + '\n',
                  //   style: theme.textTheme.subtitle2
                  //       .copyWith(color: theme.hintColor.withOpacity(0.7)),
                  // ),
                  TextSpan(
                      text: widget.state.pickupName,
                      style: theme.textTheme.headline6
                          .copyWith(color: theme.primaryColorDark, height: 1.5))
                ]),
              ),
              subtitle: Text(
                widget.state.pickupAddress,
                style:
                    Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
              ),
            ),
            SizedBox(height: 12.0),
            ListTile(
              leading: Icon(Icons.navigation, color: kMainColor),
              title: RichText(
                text: TextSpan(children: [
                  // TextSpan(
                  //   text: locale.cityGarden + '\n',
                  //   style: theme.textTheme.subtitle2
                  //       .copyWith(color: theme.hintColor.withOpacity(0.7)),
                  // ),
                  TextSpan(
                      text: widget.state.dropName,
                      style: theme.textTheme.headline6
                          .copyWith(color: theme.primaryColorDark, height: 1.5))
                ]),
              ),
              subtitle: Text(
                widget.state.dropAddress,

                ///TODO
                style:
                    Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
              ),
            ),
            SizedBox(height: 12.0),
            Divider(thickness: 6, color: kButtonColor),
            ListTile(
              title: Text(
                locale.distance,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: theme.hintColor.withOpacity(0.7)),
              ),
              subtitle: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${(distanceinKm / 1000).toStringAsFixed(2)} ${AppLocalizations.of(context).getTranslationOf(Helper().getSettingValue("distance_metric").toLowerCase())}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.navigation, color: kMainColor, size: 20),
                  GestureDetector(
                    onTap: () {
                      Helper.launchMapsUrl(
                        widget.state.pickupLatLng,
                        widget.state.dropLatLng,
                        widget.state.pickupName,
                        widget.state.dropName,
                      );
                    },
                    child: Text(
                      locale.viewMap,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: kMainColor),
                    ),
                  )
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Container(
              height: 28.0,
              child: ListTile(
                title: Text(
                  locale.getTranslationOf(
                      widget.isGroceryOrder ? "grocer_items" : "food_items"),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: theme.hintColor.withOpacity(0.7)),
                ),
                trailing: Text(
                  locale.getTranslationOf("quantity"),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: theme.hintColor.withOpacity(0.7)),
                ),
              ),
            ),
            ListView.builder(
                itemCount: widget.state.foodItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 24,
                    child: ListTile(
                      title: Text(
                        widget.state.foodItems[index].itemName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Text(
                        widget.state.foodItems[index].quantity,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  );
                }),
            ListTile(
              title: Text(
                '\n' + locale.addinfo,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: theme.hintColor.withOpacity(0.7)),
              ),
              subtitle: Text(
                widget.state.notes == null || widget.state.notes.trim().isEmpty
                    ? locale.getTranslationOf("null")
                    : widget.state.notes.trim(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 16),
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Container(
              decoration: BoxDecoration(
                  color: kButtonColor,
                  borderRadius: BorderRadius.circular(30.0)),
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ListTile(
                title: Text(
                  locale.delivMode,
                  style: theme.textTheme.subtitle2
                      .copyWith(color: theme.hintColor.withOpacity(0.7)),
                ),
                subtitle: Text(
                  widget.state.deliveryMode ??
                      AppLocalizations.of(context)
                          .getTranslationOf("selectDelivery"),
                  style: theme.textTheme.bodyText1.copyWith(fontSize: 16),
                ),
                trailing: Text(
                  widget.state.deliveryModePrice != null
                      ? "${Helper().getSettingValue("currency_icon")} ${widget.state.deliveryModePrice}  ▼"
                      : "",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 18.3,
                      ),
                ),
                onTap: () async {
                  await showModalBottomSheet(
                    shape: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide.none,
                    ),
                    context: context,
                    builder: (context) {
                      return ModalBottomSheetPage(
                          deliveryBloc: _foodDeliveryBloc);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  end: 16, start: 50, top: 8.0, bottom: 20.0),
              child: CustomButton(
                  text: locale.proceedPayment + '  ➔',
                  radius: BorderRadius.circular(35.0),
                  padding: 10,
                  onPressed: () {
                    if (widget.state.deliveryMode == null ||
                        widget.state.deliveryMode.isEmpty) {
                      Toaster.showToastBottom(AppLocalizations.of(context)
                          .getTranslationOf("selectDelivery"));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            deliveryBloc: _foodDeliveryBloc,
                            deliveryAmount: widget.state.deliveryModePrice,
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
