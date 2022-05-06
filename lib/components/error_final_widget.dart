import 'package:flutter/material.dart';

class ErrorFinalWidget {
  static Widget errorWithRetry(
      BuildContext context, String message, String actionText, Function action,
      [Color textColor, Color actionColor]) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: textColor != null
                    ? Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: textColor)
                    : Theme.of(context).textTheme.subtitle1,
              ),
              FlatButton(
                child: Text(
                  actionText,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: actionColor != null
                          ? actionColor
                          : Theme.of(context).primaryColor),
                ),
                onPressed: () => action(context),
              ),
            ],
          )),
    );
  }
}
