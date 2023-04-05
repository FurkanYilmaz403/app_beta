import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/screen_widgets/cart_screen_widgets/confirm_cart.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:app_beta/utilities/widgets/pop_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CartBottom extends StatefulWidget {
  const CartBottom({super.key});

  @override
  State<CartBottom> createState() => _CartBottomState();
}

class _CartBottomState extends State<CartBottom> {
  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<num>(
      stream: FirebaseCloud().getCartTotal(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: LinearPercentIndicator(
                  backgroundColor: primaryColor,
                  width: screenSize.width,
                  animation: true,
                  lineHeight: 30.0,
                  percent: (snapshot.data! / minCart) < 1
                      ? (snapshot.data! / minCart)
                      : 1,
                  center: (snapshot.data! / minCart) >= 1
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: successColor,
                        )
                      : const Text(
                          "Min. sepet tutarı $minCart TL",
                          style: TextStyle(color: darkTextColor),
                        ),
                  progressColor: accentColor,
                  barRadius: const Radius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32.0, left: 32.0),
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
                      onPressed: () async {
                        if ((snapshot.data! / minCart) < 1) {
                          popSnackBar(context,
                              "Minimum sepet tutarını aşmanız için en az ${(minCart - snapshot.data!).toStringAsFixed(2)} TL değerinde ürün eklemeniz gerekiyor.");
                        } else {
                          final missingProduct =
                              await FirebaseCloud().checkStock();
                          if (missingProduct != null) {
                            if (mounted) {
                              popSnackBar(context,
                                  "${missingProduct.toCapitalized()} ürününden yeterli stok bulunmamaktadır.");
                            }
                          } else {
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConfirmCart(),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Devam Et",
                        style: TextStyle(color: lightTextColor, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
