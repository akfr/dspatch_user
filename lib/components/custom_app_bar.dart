import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showLeadingButton;

  CustomAppBar({this.title, this.showLeadingButton = true});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      leading: showLeadingButton
          ? IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: theme.backgroundColor,
              iconSize: 40,
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title ?? '',
        style: theme.textTheme.headline5,
      ),
    );
  }
}
