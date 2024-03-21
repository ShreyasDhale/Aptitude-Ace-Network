import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSuccess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Text(
          msg,
          style: style.copyWith(color: Colors.white),
        ),
      ),
    ),
    backgroundColor: Colors.green,
    closeIconColor: Colors.white,
    elevation: 4,
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
  ));
}

void showFailure(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Text(
          msg,
          style: style.copyWith(color: Colors.white),
        ),
      ),
    ),
    backgroundColor: Colors.red,
    closeIconColor: Colors.white,
    elevation: 4,
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
  ));
}
