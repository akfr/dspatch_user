import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static showToast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.black.withOpacity(0.5));
  }

  static showToastTop(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black.withOpacity(0.5),
        gravity: ToastGravity.TOP);
  }

  static showToastCenter(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black.withOpacity(0.5),
        gravity: ToastGravity.CENTER);
  }

  static showToastBottom(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black.withOpacity(0.5),
        gravity: ToastGravity.BOTTOM);
  }
}
