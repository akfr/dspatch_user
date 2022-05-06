import 'package:dspatch_user/arrange_delivery/location_bloc/location_bloc.dart';
import 'package:dspatch_user/arrange_delivery/ui/drop_location.dart';
import 'package:dspatch_user/arrange_delivery/ui/pickup_location.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/food_order_bloc/food_delivery_state.dart';
import 'package:dspatch_user/bottom_navigation/home/map_repository.dart';
import 'package:dspatch_user/components/address_field.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_bloc.dart';
import 'package:dspatch_user/get_food_delivered/bloc/stores_bloc/stores_event.dart';
import 'package:dspatch_user/get_food_delivered/ui/foodconfirm_info.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/maps/bloc/map_bloc.dart';
import 'package:dspatch_user/maps/bloc/map_event.dart';
import 'package:dspatch_user/models/food/food_item.dart';
import 'package:dspatch_user/models/food/meta_food.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_webservice/geolocation.dart';

class GetFoodDeliveredPage extends StatelessWidget {
  final bool isGroceryOrdering;

  GetFoodDeliveredPage(this.isGroceryOrdering);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodDeliveryBloc>(
          create: (context) => FoodDeliveryBloc(),
        ),
      ],
      child: GetFoodDeliveredBody(isGroceryOrdering),
    );
  }
}

class GetFoodDeliveredBody extends StatefulWidget {
  final bool isGroceryOrdering;

  GetFoodDeliveredBody(this.isGroceryOrdering);

  @override
  _GetFoodDeliveredBodyState createState() => _GetFoodDeliveredBodyState();
}

class FoodItemController {
  final TextEditingController itemNameController;
  final TextEditingController itemQuantityController;

  FoodItemController(this.itemNameController, this.itemQuantityController);
}

class _GetFoodDeliveredBodyState extends State<GetFoodDeliveredBody> {
  int currentIndex = 0;
  PageController _pageController;
  FoodDeliveryBloc _foodDeliveryBloc;

  // int foodItemNum = 3;
  List<FoodItemController> controllerList = [
    FoodItemController(TextEditingController(), TextEditingController()),
    FoodItemController(TextEditingController(), TextEditingController()),
    FoodItemController(TextEditingController(), TextEditingController()),
  ];
  TextEditingController notesController = TextEditingController();
  GlobalKey<DropLocationState> _dropLocationKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // MapRepository.searchableComponents.clear();
    // MapRepository.searchableComponents.add(Component(Component.country, "CI"));

    _foodDeliveryBloc = BlocProvider.of<FoodDeliveryBloc>(context);
    _pageController = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    controllerList.clear();
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
                    ? locale.getTranslationOf(widget.isGroceryOrdering
                        ? "delivery_grocery"
                        : "delivery_food")
                    : currentIndex == 1
                        ? locale.dropLocation
                        : currentIndex == 2
                            ? locale.getTranslationOf(widget.isGroceryOrdering
                                ? "grocer_items"
                                : "confirm_order")
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
                                widget.isGroceryOrdering
                                    ? Icons.store
                                    : Icons.local_pizza,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              if (_foodDeliveryBloc.canNavToIndex(1)) {
                                setState(() {
                                  currentIndex = 1;
                                });
                                _pageController.animateToPage(currentIndex,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                              } else {
                                Toaster.showToastBottom(locale.getTranslationOf(
                                    widget.isGroceryOrdering
                                        ? "select_tocontinue_store"
                                        : "select_tocontinue_restaurant"));
                              }
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
                              if (_dropLocationKey.currentState != null) {
                                _dropLocationKey.currentState.submitData();
                              }
                              Future.delayed(Duration(milliseconds: 400), () {
                                if (_foodDeliveryBloc.canNavToIndex(2)) {
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
                                widget.isGroceryOrdering
                                    ? Icons.shopping_basket
                                    : Icons.restaurant_menu,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              submitThirdPage();
                              Future.delayed(Duration(milliseconds: 400), () {
                                if (_foodDeliveryBloc.canNavToIndex(3)) {
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
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<MapBloc>(
                          create: (context) =>
                              MapBloc()..add(FetchCurrentLocation()),
                        ),
                        // BlocProvider<StoreBloc>(
                        //   create: (BuildContext context) =>
                        //       StoreBloc()..add(FetchStoreEvent()),
                        // ),
                        BlocProvider<LocationBloc>(
                            create: (context) => LocationBloc()),
                        BlocProvider<StoreBloc>(
                            create: (context) => StoreBloc()
                              ..add(FetchStoreEvent(widget.isGroceryOrdering
                                  ? "grocery"
                                  : "food"))),
                      ],
                      child: Expanded(
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
                            PickupLocation(
                              _pageController,
                              widget.isGroceryOrdering
                                  ? Icons.store
                                  : Icons.local_pizza,
                              _foodDeliveryBloc,
                              widget.isGroceryOrdering,
                            ),
                            DropLocation(
                              _dropLocationKey,
                              _pageController,
                              _foodDeliveryBloc,
                            ),
                            foodInfo(theme, locale),
                            BlocBuilder<FoodDeliveryBloc, FoodDeliveryState>(
                              builder: (context, state) => FoodConfirmInfo(
                                  state, widget.isGroceryOrdering),
                            ),
                          ],
                        ),
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

  Widget foodInfo(ThemeData theme, AppLocalizations locale) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${locale.getTranslationOf(widget.isGroceryOrdering ? "addGrocery" : "addFood")}\n",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controllerList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: AddressField(
                                controller:
                                    controllerList[index].itemNameController,
                                hintStyle: TextStyle(fontSize: 13),
                                hint: locale.addItem,
                                color: kButtonColor,
                                icon: Icon(
                                  widget.isGroceryOrdering
                                      ? Icons.shopping_basket
                                      : Icons.restaurant_menu,
                                  color: theme.primaryColor,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35.0),
                                  bottomLeft: Radius.circular(35.0),
                                ),
                                // suffix: Text(
                                //   '\nQtn',
                                //   style: theme.textTheme.caption
                                //       .copyWith(color: theme.hintColor),
                                // ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AddressField(
                                keyBoardType: TextInputType.number,
                                controller: controllerList[index]
                                    .itemQuantityController,
                                hint: AppLocalizations.of(context)
                                    .getTranslationOf("quantity"),
                                color: kButtonColor,
                                hintStyle: TextStyle(fontSize: 12),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(35.0),
                                    bottomRight: Radius.circular(35.0)),
                                // suffix: Text(
                                //   '\nQtn',
                                //   style: theme.textTheme.caption
                                //       .copyWith(color: theme.hintColor),
                                // ),
                              ),
                            ),
                          ],
                        );
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // foodItemNum++;
                        controllerList.add(FoodItemController(
                            TextEditingController(), TextEditingController()));
                      });
                    },
                    child: Text(
                      "\n${locale.addMore}\n",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "${locale.addinfo}\n",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: kContainerTextColor),
                  ),
                  TextFormField(
                    controller: notesController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: locale.addinfoInput,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: theme.hintColor),
                      filled: true,
                      fillColor: kButtonColor,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Container(
              color: kButtonColor,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.getTranslationOf("availableText"),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.delivCall,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.delivCharges,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 100, top: 20),
                    child: CustomButton(
                      text: '     ' + locale.continueText + '  ↓     ',
                      radius: BorderRadius.circular(35.0),
                      padding: 10,
                      onPressed: () => submitThirdPage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitThirdPage() {
    FocusScope.of(context).requestFocus(FocusNode());
    List<FoodItem> foodItems = [];
    for (int i = 0; i < controllerList.length; i++) {
      if (controllerList[i].itemNameController.text.isNotEmpty)
        foodItems.add(FoodItem(
            controllerList[i].itemNameController.text,
            controllerList[i].itemQuantityController.text.isEmpty
                ? "1"
                : controllerList[i].itemQuantityController.text));
    }
    if (foodItems.isEmpty) {
      Toaster.showToastBottom(
          AppLocalizations.of(context).getTranslationOf("err_empty_fields"));
    } else {
      setState(() {
        currentIndex = 3;
      });
      _foodDeliveryBloc.add(MetaDataAddedEvent(
          MetaFood(foodItems, widget.isGroceryOrdering ? 'grocery' : 'food'),
          notesController.text));
      _foodDeliveryBloc.add(FoodItemsAddedEvent(foodItems));
      Future.delayed(Duration(milliseconds: 300), () {
        _pageController.animateToPage(currentIndex,
            duration: Duration(milliseconds: 350),
            curve: Curves.linearToEaseOut);
      });
    }
  }
}
