import 'package:dspatch_user/theme/style.dart';
import 'package:flutter/material.dart';

class DeliveryCard {
  DeliveryCard(this.icon, this.title, this.subtitle, this.onPress);
  String icon;
  String title;
  String subtitle;
  Function onPress;
}

class DeliveryTypeCard extends StatelessWidget {
  final DeliveryCard card;

  DeliveryTypeCard(this.card);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
          boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).backgroundColor),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 12.0,
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(card.icon),
        ),
        title: Text(
          card.title,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          '\n' + card.subtitle,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Theme.of(context).dividerColor),
        ),
        onTap: card.onPress,
      ),
    );
  }
}
