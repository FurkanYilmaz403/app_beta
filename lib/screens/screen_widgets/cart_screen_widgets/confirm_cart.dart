import 'package:app_beta/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmCart extends StatefulWidget {
  const ConfirmCart({Key? key}) : super(key: key);

  @override
  State<ConfirmCart> createState() => _ConfirmCartState();
}

class _ConfirmCartState extends State<ConfirmCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: primaryColor,
          shadowColor: accentColor,
          title: const Text(
            "Sepet",
            style: TextStyle(color: lightTextColor, fontSize: 28),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      body: const Center(
        child: Text("sepet onay"),
      ),
    );
  }
}
