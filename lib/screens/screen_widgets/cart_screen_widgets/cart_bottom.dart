import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:flutter/material.dart';

class CartBottom extends StatefulWidget {
  const CartBottom({super.key});

  @override
  State<CartBottom> createState() => _CartBottomState();
}

class _CartBottomState extends State<CartBottom> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<num>(
      stream: FirebaseCloud().getCartTotal(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 32.0, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Toplam",
                      style: TextStyle(color: darkTextColor, fontSize: 18),
                    ),
                    Text(
                      "${snapshot.data!.toStringAsFixed(2)} TL",
                      style: const TextStyle(
                        color: darkTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        fontFamily: "DancingScript",
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    shadowColor: MaterialStatePropertyAll(primaryColor),
                    elevation: MaterialStatePropertyAll(20),
                    backgroundColor: MaterialStatePropertyAll(primaryColor),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: accentColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Devam Et",
                    style: TextStyle(color: lightTextColor, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
