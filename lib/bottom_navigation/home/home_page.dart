import 'package:dspatch_user/arrange_delivery/ui/arrange_delivery.dart';
import 'package:dspatch_user/bottom_navigation/home/ads_container.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/banner_bloc/banner_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/banner_bloc/banner_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/banner_bloc/banner_state.dart';
import 'package:dspatch_user/bottom_navigation/home/delivery_type_card.dart';
import 'package:dspatch_user/get_food_delivered/ui/get_food_delivered.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final List<DeliveryCard> cards = [
      DeliveryCard(
        "images/home1.png",
        locale.arrangeDeliv,
        locale.arrangeDelivText,
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArrangeDeliveryPage())),
      ),
      DeliveryCard(
        "images/home2.png",
        locale.getFood,
        locale.getFoodText,
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetFoodDeliveredPage(false))),
      ),
      DeliveryCard(
        "images/home3.png",
        locale.getGrocery,
        locale.getGroceryText,
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetFoodDeliveredPage(true))),
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset("images/banner.png"),
                Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cards.length,
                    itemBuilder: (context, index) =>
                        DeliveryTypeCard(cards[index]),
                  ),
                ),
              ],
            ),
            BlocProvider<BannerBloc>(
              create: (context) => BannerBloc()..add(FetchBannerEvent()),
              child: BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) {
                  return state is SuccessBannerState &&
                          state.listOfBanners.listOfBanner.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "\n${locale.promo}\n",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Container(
                              height: 140,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 20),
                                itemCount:
                                    state.listOfBanners.listOfBanner.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    AdsContainer(Ad(
                                  state.listOfBanners.listOfBanner[index]
                                      .mediaurls.images[0].defaultImage,
                                  state.listOfBanners.listOfBanner[index].title,
                                  state.listOfBanners.listOfBanner[index].meta
                                      .storeName
                                      .toString(),
                                )),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }
}
