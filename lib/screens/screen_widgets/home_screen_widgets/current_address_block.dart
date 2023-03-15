import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/side_screens.dart/address_screen.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:flutter/material.dart';

class CurrentAddressBlock extends StatefulWidget {
  const CurrentAddressBlock({Key? key}) : super(key: key);

  @override
  State<CurrentAddressBlock> createState() => _AddressState();
}

class _AddressState extends State<CurrentAddressBlock> {
  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddressScreen(),
          ),
        );
      },
      child: Container(
        height: addressSize,
        color: secondaryColor,
        child: const Text(
          "FutureBuilder ile güncel adres seçilecek.",
          style: TextStyle(color: darkTextColor),
        ),
      ),
    );
  }
}
