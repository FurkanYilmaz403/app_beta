import 'package:app_beta/constants/constants.dart';
import 'package:flutter/material.dart';

void popSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2),
    backgroundColor: warningColor,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Tamam',
      disabledTextColor: infoColor,
      textColor: lightTextColor,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
