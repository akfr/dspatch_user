import 'package:dspatch_user/arrange_delivery/location_bloc/location_bloc.dart';
import 'package:dspatch_user/arrange_delivery/ui/deliveryconfirm_info.dart';
import 'package:dspatch_user/arrange_delivery/ui/drop_location_custom.dart';
import 'package:dspatch_user/arrange_delivery/ui/measurement.dart';
import 'package:dspatch_user/arrange_delivery/ui/pickup_location_custom.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/custom_delivery_bloc/custom_delivery_state.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_bloc.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_event.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/maps/bloc/map_bloc.dart';
import 'package:dspatch_user/models/custom_delivery/meta_custom.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
// import 'package:google_maps_webservice/places.dart';

class ArrangeDeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(),
        ),
        BlocProvider<CustomDeliveryBloc>(
          create: (context) => CustomDeliveryBloc(),
        ),
        BlocProvider<StoreBloc>(
          create: (BuildContext context) =>
              StoreBloc()..add(FetchStoreEvent(null)),
        ),
        BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
      ],
      child: ArrangeDeliveryBody(),
    );
  }
}

class ArrangeDeliveryBody extends StatefulWidget {
  @override
  _ArrangeDeliveryBodyState createState() => _ArrangeDeliveryBodyState();
}

class _ArrangeDeliveryBodyState extends State<ArrangeDeliveryBody> {
  int currentIndex = 0;
  PageController _pageController;
  TextEditingController pickNearestPointController = TextEditingController();
  TextEditingController pickNameController = TextEditingController();
  TextEditingController pickPhoneController = TextEditingController();
  TextEditingController dropNearestPointController = TextEditingController();
  TextEditingController dropNameController = TextEditingController();
  TextEditingController dropPhoneController = TextEditingController();
  TextEditingController courierInfoController = TextEditingController();
  CustomDeliveryBloc _deliveryBloc;
  double weight = 5;
  bool isSwitched = false;
  Measured measured;
  double width = 0;
  double length = 0;
  double height = 0;

  GlobalKey<PickupLocationCustomState> _pickupLocationCustomKey = GlobalKey();
  GlobalKey<DropLocationCustomState> _dropLocationCustomKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // MapRepository.searchableComponents.clear();
    // MapRepository.searchableComponents.add(Component(Component.country, "CI"));

    _pageController = PageController(initialPage: currentIndex);
    _deliveryBloc = BlocProvider.of<CustomDeliveryBloc>(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    pickNameController.dispose();
    pickNearestPointController.dispose();
    pickPhoneController.dispose();
    dropPhoneController.dispose();
    dropNameController.dispose();
    dropNearestPointController.dispose();
    super.dispose();
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
              CustomAppBar(
                title: currentIndex == 0
                    ? locale.pickupLoc
                    : currentIndex == 1
                        ? locale.dropLocation
                        : locale.getTranslationOf("confirm_order"),
              ),
              Spacer(),
              Container(
                height: mediaQuery.size.height * 0.85,
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                              _pageController.animateToPage(currentIndex,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 0
                                  ? theme.backgroundColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.location_on,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              if (_pickupLocationCustomKey.currentState !=
                                  null) {
                                _pickupLocationCustomKey.currentState
                                    .submitData();
                              }
                              Future.delayed(Duration(milliseconds: 400), () {
                                if (_deliveryBloc.canNavToIndex(1)) {
                                  setState(() {
                                    currentIndex = 1;
                                  });
                                  _pageController.animateToPage(currentIndex,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linearToEaseOut);
                                } else {
                                  Toaster.showToastBottom(locale
                                      .getTranslationOf("pickup_invalid"));
                                }
                              });
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 1
                                  ? theme.backgroundColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.navigation,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              if (_dropLocationCustomKey.currentState != null) {
                                _dropLocationCustomKey.currentState
                                    .submitData();
                              }
                              Future.delayed(Duration(milliseconds: 400), () {
                                if (_deliveryBloc.canNavToIndex(2)) {
                                  setState(() {
                                    currentIndex = 2;
                                  });
                                  _pageController.animateToPage(currentIndex,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linearToEaseOut);
                                } else {
                                  Toaster.showToastBottom(
                                      locale.getTranslationOf("drop_invalid"));
                                }
                              });
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 2
                                  ? theme.backgroundColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.shopping_basket,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              submitThirdPage();
                              Future.delayed(Duration(milliseconds: 400), () {
                                if (_deliveryBloc.canNavToIndex(3)) {
                                  setState(() {
                                    currentIndex = 3;
                                  });
                                  _pageController.animateToPage(currentIndex,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linearToEaseOut);
                                }
                              });
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 3
                                  ? theme.backgroundColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.assignment,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        children: [
                          PickupLocationCustom(
                            _pickupLocationCustomKey,
                            _pageController,
                            Icons.location_on,
                            pickNearestPointController,
                            pickNameController,
                            pickPhoneController,
                            _deliveryBloc,
                          ),
                          DropLocationCustom(
                            _dropLocationCustomKey,
                            _pageController,
                            dropNearestPointController,
                            dropNameController,
                            dropPhoneController,
                            _deliveryBloc,
                          ),
                          BlocBuilder<CustomDeliveryBloc, CustomDeliveryState>(
                            builder: (context, state) =>
                                buildCourierInfo(theme, locale, context, state),
                          ),
                          BlocBuilder<CustomDeliveryBloc, CustomDeliveryState>(
                            builder: (context, state) => ConfirmInfo(
                              height.toInt().toString(),
                              width.toInt().toString(),
                              weight.toInt().toString(),
                              length.toInt().toString(),
                              isSwitched ? 'Yes' : 'No',
                              pickNameController,
                              pickPhoneController,
                              dropNameController,
                              dropPhoneController,
                              state,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateAndGetData(BuildContext context) async {
    measured = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Measurement()));
    setState(() {
      height = measured.height;
      length = measured.length;
      width = measured.width;
    });
  }

  Widget buildCourierInfo(ThemeData theme, AppLocalizations locale,
      BuildContext context, CustomDeliveryState state) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: theme.backgroundColor,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    locale.courierType,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _deliveryBloc.courierTypes
                          .map(
                            (e) => Expanded(
                              child: CustomButton(
                                onPressed: () {
                                  _deliveryBloc.courierTypeSelected = e;
                                  _deliveryBloc.add(ValuesSelectedEvent(e));
                                },
                                text: e,
                                padding: 12,
                                color: state.selectedBoxType == e
                                    ? null
                                    : kButtonColor,
                                borderColor: kButtonTextColor.withOpacity(0.6),
                                radius: BorderRadius.circular(30.0),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: state.selectedBoxType == e
                                            ? kTextColor
                                            : theme.hintColor),
                              ),
                            ),
                          )
                          .toList()),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            InkWell(
              onTap: () {
                _navigateAndGetData(context);
              },
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildCalcCard(Icons.arrow_upward, locale.height,
                        height.toString() + ' ' + locale.cm, theme),
                    VerticalDivider(thickness: 6, color: kButtonColor),
                    buildCalcCard(Icons.arrow_forward, locale.width,
                        width.toString() + ' ' + locale.cm, theme),
                    VerticalDivider(thickness: 6, color: kButtonColor),
                    buildCalcCard(Icons.compare_arrows, locale.length,
                        length.toString() + ' ' + locale.cm, theme),
                  ],
                ),
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        locale.weight,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Expanded(
                        child: FlutterSlider(
                          handlerHeight: 60,
                          handler: FlutterSliderHandler(
                            child: Container(
                              height: 16,
                              width: 2,
                              color: theme.primaryColor,
                              margin: EdgeInsets.only(bottom: 20),
                            ),
                            decoration:
                                BoxDecoration(shape: BoxShape.rectangle),
                          ),
                          hatchMark: FlutterSliderHatchMark(
                            density: 0.5,
                            bigLine: FlutterSliderSizedBox(
                                height: 16,
                                width: 2,
                                decoration: BoxDecoration(
                                    color:
                                        theme.disabledColor.withOpacity(0.3))),
                            smallLine: FlutterSliderSizedBox(
                                height: 8,
                                width: 1,
                                decoration: BoxDecoration(
                                    color:
                                        theme.disabledColor.withOpacity(0.3))),
                            displayLines: true,
                            linesAlignment:
                                FlutterSliderHatchMarkAlignment.left,
                            labelsDistanceFromTrackBar: 28,
                            labels: [
                              FlutterSliderHatchMarkLabel(
                                  label: Text(
                                    '0 kg',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  percent: 0),
                              FlutterSliderHatchMarkLabel(
                                  label: Text(
                                    '20 kg',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  percent: 100),
                              FlutterSliderHatchMarkLabel(
                                  label: Text(
                                    '10 kg',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  percent: 50),
                            ],
                          ),
                          values: [weight],
                          min: 0,
                          max: 20,
                          onDragging: (index, lowerValue, upperValue) {
                            setState(() {
                              weight = lowerValue;
                            });
                          },
                          trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 0.1,
                              activeTrackBar: BoxDecoration(
                                color: theme.backgroundColor,
                              ),
                              inactiveTrackBarHeight: 0.1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Divider(thickness: 6, color: kButtonColor),
            ListTile(
              title: Text(
                locale.frangible + ' ?',
                style: theme.textTheme.bodyText1,
              ),
              trailing: FittedBox(
                child: Row(
                  children: [
                    Text(
                      isSwitched ? locale.yes : locale.no,
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: theme.hintColor.withOpacity(0.3),
                      activeColor: theme.primaryColor,
                      inactiveTrackColor: theme.hintColor.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    locale.courierDetail + '\n',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextFormField(
                    controller: courierInfoController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: locale.courierInput,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: theme.hintColor),
                      filled: true,
                      fillColor: kButtonColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                        //gapPadding: 3.3
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: /*160*/ 120, top: 12.0, end: 20.0),
              child: CustomButton(
                radius: BorderRadius.circular(35.0),
                padding: 8,
                text: '\t\t' + locale.continueText + '  ↓\t\t',
                onPressed: () => submitThirdPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitThirdPage() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_deliveryBloc.state.selectedBoxType == null ||
        _deliveryBloc.state.selectedBoxType.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("courierTypeSelect"));
    } else {
      setState(() {
        currentIndex = 3;
      });

      _deliveryBloc.add(
        MetaDataAddedEvent(
          MetaCustom.request(
            '${length.toString()}*${width.toString()}*${height.toString()}',
            isSwitched.toString(),
            _deliveryBloc.state.selectedBoxType,
            weight.toString(),
            'courier',
            [],
          ),
          courierInfoController.text,
        ),
      );
      Future.delayed(Duration(milliseconds: 300), () {
        _pageController.animateToPage(currentIndex,
            duration: Duration(milliseconds: 350),
            curve: Curves.linearToEaseOut);
      });
    }
  }

  ListTile buildListTile(String text, {IconData icon}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: icon != null
          ? Icon(
              icon,
              color: Theme.of(context).primaryColor,
            )
          : Image.asset(
              'images/ic_officeblk.png',
              color: Theme.of(context).primaryColor,
              scale: 3.5,
            ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      dense: true,
    );
  }

  Widget buildCalcCard(
      IconData icon, String text, String measurement, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: theme.primaryColor,
              ),
              SizedBox(
                width: 8,
              ),
              Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: kButtonTextColor, fontSize: 11.7)),
            ],
          ),
          SizedBox(
            height: 7.5,
          ),
          Text(measurement,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: kContainerTextColor))
        ],
      ),
    );
  }
}
