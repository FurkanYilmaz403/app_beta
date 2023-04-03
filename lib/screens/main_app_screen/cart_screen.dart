import 'package:app_beta/screens/screen_widgets/cart_screen_widgets/cart_products.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CartProducts(),
      ],
    );
  }
}
