import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';

class Ad {
  Ad(this.img, this.text, this.location);
  String img;
  String text;
  String location;
}

class AdsContainer extends StatelessWidget {
  final Ad ad;

  AdsContainer(this.ad);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 6.0),
      height: 150.0,
      width: 192.0,
      decoration: BoxDecoration(
          boxShadow: [boxShadow],
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25), BlendMode.darken),
              image: NetworkImage(ad.img),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              ad.text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).backgroundColor),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 18.0,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ad.location,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
