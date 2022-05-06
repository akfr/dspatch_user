import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_state.dart';
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

import 'bottom_list.dart';

class ConfirmInfo extends StatefulWidget {
  final String height;
  final String width;
  final String weight;
  final String length;
  final String frangible;
  final TextEditingController sourceNameController;
  final TextEditingController sourceNumberController;
  final TextEditingController destinationNameController;
  final TextEditingController destinationNumberController;
  final CustomDeliveryState state;

  ConfirmInfo(
      this.height,
      this.width,
      this.weight,
      this.length,
      this.frangible,
      this.sourceNameController,
      this.sourceNumberController,
      this.destinationNameController,
      this.destinationNumberController,
      this.state);

  @override
  _ConfirmInfoState createState() => _ConfirmInfoState();
}

class _ConfirmInfoState extends State<ConfirmInfo> {
  CustomDeliveryBloc _deliveryBloc;
  double distanceinKm;

  @override
  void initState() {
    super.initState();
    _deliveryBloc = BlocProvider.of<CustomDeliveryBloc>(context);
    distanceinKm = Geolocator.distanceBetween(
      widget.state.pickupLatLng.latitude,
      widget.state.pickupLatLng.longitude,
      widget.state.dropLatLng.latitude,
      widget.state.dropLatLng.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return BlocListener<CustomDeliveryBloc, CustomDeliveryState>(
      listener: (context, state) {
        // if (state.goToNextPage) {
        //   Navigator.popAndPushNamed(
        //       context, PageRoutes.payment);
        // }
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius, color: theme.backgroundColor),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: kMainColor),
                title: RichText(
                  text: TextSpan(children: [
                    // TextSpan(
                    //   text: 'Walmart' + '\n',
                    //   style: theme.textTheme.subtitle2
                    //       .copyWith(color: theme.hintColor.withOpacity(0.7)),
                    // ),
                    TextSpan(
                        text: widget.state.pickupName,
                        style: theme.textTheme.headline6.copyWith(
                            color: theme.primaryColorDark, height: 1.5))
                  ]),
                ),
                subtitle: Text(
                  widget.state.pickupAddress,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(height: 1.5),
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
                        style: theme.textTheme.headline6.copyWith(
                            color: theme.primaryColorDark, height: 1.5))
                  ]),
                ),
                subtitle: Text(
                  widget.state.dropAddress,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(height: 1.5),
                ),
              ),
              Divider(color: kButtonColor, thickness: 6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${locale.distance}\n",
                            style: theme.textTheme.subtitle2.copyWith(
                              color: theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                          TextSpan(
                            text:
                                "${(distanceinKm / 1000).toStringAsFixed(2)} ${AppLocalizations.of(context).getTranslationOf(Helper().getSettingValue("distance_metric").toLowerCase())}",
                            style: theme.textTheme.bodyText1
                                .copyWith(fontSize: 16),
                          ),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Helper.launchMapsUrl(
                            widget.state.pickupLatLng,
                            widget.state.dropLatLng,
                            widget.sourceNameController.text,
                            widget.destinationNameController.text);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.navigation,
                            color: kMainColor,
                            size: 20,
                          ),
                          Text(
                            locale.viewMap,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: kMainColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: kButtonColor, thickness: 6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${locale.courierType}\n",
                              style: theme.textTheme.subtitle2.copyWith(
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                            TextSpan(
                              text: widget.state.selectedBoxType,
                              style: theme.textTheme.bodyText1
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${locale.frangible}\n",
                            style: theme.textTheme.subtitle2.copyWith(
                                color: theme.hintColor.withOpacity(0.7)),
                          ),
                          TextSpan(
                            text: widget.frangible,
                            style: theme.textTheme.bodyText1
                                .copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "${locale.height} ${locale.width} ${locale.length}\n",
                            style: theme.textTheme.subtitle2.copyWith(
                              color: theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                          TextSpan(
                            text:
                                "${widget.height} x ${widget.width} x ${widget.length} (cm)",
                            style: theme.textTheme.bodyText1
                                .copyWith(fontSize: 16),
                          ),
                        ]),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "${locale.weight}\n",
                          style: theme.textTheme.subtitle2.copyWith(
                              color: theme.hintColor.withOpacity(0.7)),
                        ),
                        TextSpan(
                          text: "${widget.weight} kg",
                          style:
                              theme.textTheme.bodyText1.copyWith(fontSize: 16),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "${locale.courierInfo}\n",
                      style: theme.textTheme.subtitle2
                          .copyWith(color: theme.hintColor.withOpacity(0.7)),
                    ),
                    TextSpan(
                      text: widget.state.notes == null ||
                              widget.state.notes.trim().isEmpty
                          ? locale.getTranslationOf("null")
                          : widget.state.notes.trim(),
                      style: theme.textTheme.bodyText1.copyWith(fontSize: 16),
                    ),
                  ]),
                ),
              ),
              Divider(color: kButtonColor, thickness: 6),
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
                  onTap: () => showModalBottomSheet(
                    shape: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide.none,
                    ),
                    context: context,
                    builder: (context) =>
                        ModalBottomSheetPage(deliveryBloc: _deliveryBloc),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    end: 16, start: /*80*/ 70, top: 8, bottom: 20.0),
                child: CustomButton(
                    text: locale.proceedPayment,
                    radius: BorderRadius.circular(35.0),
                    padding: 10,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (widget.state.selectedBoxType == null ||
                          widget.state.selectedBoxType.isEmpty) {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf("courierTypeSelect"));
                      } else if (widget.state.deliveryMode == null ||
                          widget.state.deliveryMode.isEmpty) {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf("selectDelivery"));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                      deliveryBloc: _deliveryBloc,
                                      deliveryAmount:
                                          widget.state.deliveryModePrice,
                                    )));
                      }
                      // _deliveryBloc.add(SubmittedEvent(
                      //     'instruction',
                      //     widget.sourceNumberController.text,
                      //     widget.destinationNumberController.text,
                      //     MetaCustom('L*w*h', 'frangible', 'box', '20kg')));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
