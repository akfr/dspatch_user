import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/routes/routes.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickupAssigned extends StatelessWidget {
  final PaymentStatus paymentStatus;
  PickupAssigned(this.paymentStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              AppLocalizations.of(context).getTranslationOf(
                  paymentStatus.isPaid ? "order_placed" : "order_failed"),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(flex: 2),
            Image.asset(
              'images/pickup.png',
              scale: 3,
            ),
            Spacer(),
            Text(
              AppLocalizations.of(context).getTranslationOf(paymentStatus.isPaid
                  ? "order_placed_msg"
                  : "order_failed_msg"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              AppLocalizations.of(context).thanksText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Color(0xff282828),
                    fontWeight: FontWeight.normal,
                  ),
            ),
            Spacer(flex: 2),
            CustomButton(
              text: AppLocalizations.of(context).getTranslationOf(
                  paymentStatus.isPaid ? "trackCourier" : "okay"),
              radius: BorderRadius.only(topRight: Radius.circular(35.0)),
              onPressed: () => Navigator.popAndPushNamed(
                context,
                PageRoutes.bottomNavigation,
                arguments: paymentStatus.isPaid ? 0 : 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
