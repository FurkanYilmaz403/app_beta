import 'package:app_beta/screens/screen_widgets/cart_screen_widgets/cart_bottom.dart';
import 'package:app_beta/screens/screen_widgets/cart_screen_widgets/cart_products.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CartProducts(),
        CartBottom(),
      ],
    );
  }
}
