import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/screen_widgets/home_screen_widgets/current_address_block.dart';
import 'package:app_beta/screens/screen_widgets/home_screen_widgets/greetings.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:app_beta/screens/screen_widgets/home_screen_widgets/category_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CurrentAddressBlock(),
        const Greetings(),
        Container(
          constraints: BoxConstraints(minHeight: screenSize.height * 0.7),
          width: screenSize.width * 0.5,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.5),
                  spreadRadius: 10,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              color: secondaryColor,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
                bottom: Radius.circular(40),
              ),
              border: Border.all(color: primaryColor, width: 3)),
          child: const CategoryList(),
        ),
      ],
    );
  }
}
