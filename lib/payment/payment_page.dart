import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_state.dart';
import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/components/card_picker.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/error_final_widget.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pickup_assigned.dart';

// ignore: must_be_immutable
class PaymentPage extends StatelessWidget {
  var deliveryBloc;
  double deliveryAmount;

  PaymentPage({this.deliveryBloc, @required this.deliveryAmount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentBloc>(
      create: (BuildContext context) => PaymentBloc()..add(FetchPaymentEvent()),
      child: Payment(deliveryBloc, deliveryAmount),
    );
  }
}

// ignore: must_be_immutable
class Payment extends StatefulWidget {
  var deliveryBloc;
  double deliveryAmount;

  Payment(this.deliveryBloc, this.deliveryAmount);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var paymentMethodSlug;
  int value;
  bool isLoaderShowing = false;
  List<PaymentMethod> listOfPaymentMethods;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is CreatingOrderState) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is SuccessPaymentState) {
          listOfPaymentMethods = state.listOfPaymentMethods;
        }
        if (state is FailurePlaceOrderState) {
          Toaster.showToastBottom(AppLocalizations.of(context)
              .getTranslationOf(state.errorMessage));
        }
        if (state is SuccessPlaceOrderState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessPaymentPage(state.paymentData),
            ),
          ).then(
            (value) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PickupAssigned(
                    (value != null && value is PaymentStatus)
                        ? value
                        : PaymentStatus(false,
                            state.paymentData.payment.paymentMethod.slug),
                  ),
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        // var taxInPercent = Helper().getSettingValue("tax_in_percent").isEmpty
        //     ? "0"
        //     : Helper().getSettingValue("tax_in_percent");
        // var tax = (double.parse(taxInPercent) * widget.deliveryAmount) / 100;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios)),
                title: Text(
                  locale.paymentMode,
                  style: theme.textTheme.headline5,
                ),
                backgroundColor: kMainColor,
              ),
            ),
          ),
          body: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: kButtonColor,
                borderRadius: borderRadius,
              ),
              child: listOfPaymentMethods != null &&
                      listOfPaymentMethods.isNotEmpty
                  ? Stack(
                      children: <Widget>[
                        ListView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 30.0, top: 24.0, right: 30),
                              title: Text(
                                "Delivery Charge",
                                style: theme.textTheme.headline6
                                    .copyWith(color: theme.primaryColorDark),
                              ),
                              trailing: Text(
                                widget.deliveryAmount.toString(),
                                style: theme.textTheme.bodyText1
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            // ListTile(
                            //   contentPadding:
                            //       EdgeInsets.only(left: 30.0, right: 30),
                            //   title: Text(
                            //     "Service Charge",
                            //     style: theme.textTheme.headline6
                            //         .copyWith(color: theme.primaryColorDark),
                            //   ),
                            //   trailing: Text(
                            //     tax.toString(),
                            //     style: theme.textTheme.bodyText1
                            //         .copyWith(fontSize: 18),
                            //   ),
                            // ),
                            // ListTile(
                            //   contentPadding:
                            //       EdgeInsets.only(left: 30.0, right: 30),
                            //   title: Text(
                            //     "Total",
                            //     style: theme.textTheme.headline6
                            //         .copyWith(color: theme.primaryColorDark),
                            //   ),
                            //   trailing: Text(
                            //     (tax + widget.deliveryAmount).toString(),
                            //     style: theme.textTheme.bodyText1
                            //         .copyWith(fontSize: 18),
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, top: 24.0),
                              child: Text(
                                AppLocalizations.of(context)
                                    .getTranslationOf("choosePayment"),
                                // '${locale.amountPay} \$8.60',
                                style: theme.textTheme.headline6
                                    .copyWith(color: theme.primaryColorDark),
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: listOfPaymentMethods.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  tileColor: Theme.of(context).backgroundColor,
                                  activeColor: Theme.of(context).primaryColor,
                                  value: index,
                                  groupValue: value,
                                  onChanged: (ind) {
                                    setState(() => value = ind);
                                    if (widget.deliveryBloc
                                        is CustomDeliveryBloc)
                                      widget.deliveryBloc.add(
                                          PaymentModeCustomSelectedEvent(
                                              listOfPaymentMethods[index]));
                                    if (widget.deliveryBloc is FoodDeliveryBloc)
                                      widget.deliveryBloc.add(
                                          PaymentModeSelectedEvent(
                                              listOfPaymentMethods[index]));
                                  },
                                  title: Text(
                                    listOfPaymentMethods[index].title,
                                    style: theme.textTheme.bodyText1
                                        .copyWith(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    listOfPaymentMethods[index].slug == "cod"
                                        ? "Offline"
                                        : "Online",
                                    style: theme.textTheme.bodyText2.copyWith(
                                      fontSize: 13.3,
                                      color: Color(0xffc1c1c1),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width,
                          bottom: 0.0,
                          child: CustomButton(
                            text: locale.done,
                            radius: BorderRadius.only(
                                topRight: Radius.circular(35.0)),
                            onPressed: () async {
                              CardInfo cardInfo;
                              if (widget.deliveryBloc.state.paymentMethodSlug ==
                                  null) {
                                Toaster.showToastBottom(
                                    AppLocalizations.of(context)
                                        .getTranslationOf("choosePayment"));
                              } else if (widget
                                      .deliveryBloc.state.paymentMethodSlug ==
                                  "stripe") {
                                CardInfo cardInfoSaved =
                                    await CardPicker.getSavedCard();
                                cardInfo = await CardPicker.pickCard(
                                    context, cardInfoSaved, true);
                              } else {
                                BlocProvider.of<PaymentBloc>(context).add(
                                    CreateOrderEvent(
                                        widget.deliveryBloc.state, cardInfo));

                                // // widget.deliveryBloc.add(PaymentModeSelectedEvent(paymentMethodSlug));
                                // if (widget.deliveryBloc is CustomDeliveryBloc) {
                                //   widget.deliveryBloc.add(SubmittedCustomEvent(
                                //     'instruction',
                                //     cardInfo,
                                //     // 'widget.sourceNumberController.text',
                                //     // 'widget.destinationNumberController.text',
                                //     // MetaCustom('L*w*h', 'frangible', 'box', '20kg', ),
                                //   ));
                                // } else if (widget.deliveryBloc
                                //     is FoodDeliveryBloc) {
                                //   widget.deliveryBloc.add(SubmittedEvent(
                                //     'instruction',
                                //     cardInfo,
                                //     // 'widget.sourceNumberController.text',
                                //     // 'widget.destinationNumberController.text',
                                //     // MetaCustom('L*w*h', 'frangible', 'box', '20kg', ),
                                //   ));
                                // }

                                // Navigator.pop(context);
                                // Navigator.popAndPushNamed(
                                //     context, PageRoutes.pickupAssigned);
                              }
                            },
                          ),
                        )
                      ],
                    )
                  : state is LoadingPaymentState
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        )
                      : ErrorFinalWidget.errorWithRetry(
                          context,
                          AppLocalizations.of(context).getTranslationOf(
                              state is FailurePaymentState
                                  ? "something_wrong"
                                  : "empty_payment_methods"),
                          AppLocalizations.of(context).getTranslationOf(
                              state is FailurePaymentState
                                  ? "retry"
                                  : "reload"),
                          (context) => BlocProvider.of<PaymentBloc>(context)
                            ..add(FetchPaymentEvent()),
                        ),
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
            valueColor: AlwaysStoppedAnimation(kMainColor),
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
}
