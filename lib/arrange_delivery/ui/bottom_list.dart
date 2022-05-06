import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/delivery_modes_bloc/delivery_mode_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/delivery_modes_bloc/delivery_mode_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/delivery_modes_bloc/delivery_mode_state.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/custom_delivery/delivery_mode.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ModalBottomSheetPage extends StatelessWidget {
  var deliveryBloc;

  ModalBottomSheetPage({this.deliveryBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeliveryModeBloc>(
        create: (context) => DeliveryModeBloc()..add(FetchDeliveryModeEvent()),
        child: ModalBottomWidget(deliveryBloc: deliveryBloc));
  }
}

// ignore: must_be_immutable
class ModalBottomWidget extends StatefulWidget {
  var deliveryBloc;

  ModalBottomWidget({this.deliveryBloc});

  @override
  _ModalBottomWidgetState createState() => _ModalBottomWidgetState();
}

class _ModalBottomWidgetState extends State<ModalBottomWidget> {
  DeliveryMode deliveryMode;
  int value;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Stack(
      children: [
        ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                locale.selectDelivery,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
            ),
            BlocBuilder<DeliveryModeBloc, DeliveryModeState>(
              builder: (context, state) {
                if (state is SuccessDeliveryModeState) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    //padding: EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: RadioListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          tileColor: Theme.of(context).backgroundColor,
                          activeColor: Theme.of(context).primaryColor,
                          value: index,
                          groupValue: value,
                          onChanged: (ind) {
                            setState(() => value = ind);
                            deliveryMode = state.deliveryModes[index];
                          },
                          title: Text(
                            state.deliveryModes[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 18.3, color: kContainerTextColor),
                          ),
                          subtitle: Text(
                            state.deliveryModes[index].detail,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Theme.of(context).hintColor),
                          ),
                          secondary: Text(
                              "${Helper().getSettingValue("currency_icon")} ${state.deliveryModes[index].price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorDark)),
                        ),
                      );
                    },
                    itemCount: state.deliveryModes.length,
                  );
                }
                if (state is FailureDeliveryModeState) {
                  return Center(child: Text('Could\'nt load delivery modes'));
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ));
                }
              },
            ),
            SizedBox(height: 64),
          ],
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 0.0,
          child: CustomButton(
              text: locale.update,
              radius: BorderRadius.only(topRight: Radius.circular(35.0)),
              onPressed: () {
                if (widget.deliveryBloc is FoodDeliveryBloc)
                  widget.deliveryBloc.add(DeliveryModeSelectedEvent(
                      deliveryMode.id,
                      deliveryMode.title,
                      deliveryMode.price.toDouble()));
                else if (widget.deliveryBloc is CustomDeliveryBloc)
                  widget.deliveryBloc.add(DeliveryModeCustomSelectedEvent(
                      deliveryMode.id,
                      deliveryMode.title,
                      deliveryMode.price.toDouble()));
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
