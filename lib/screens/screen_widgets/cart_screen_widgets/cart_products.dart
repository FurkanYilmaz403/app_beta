import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  const CartProducts({Key? key}) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseCloud().getCart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final cartProducts = <Widget>[];
            for (final product in snapshot.data!.docs) {
              cartProducts.add(
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: CartProductsCard(
                    count: product["miktar"],
                    product: product,
                  ),
                ),
              );
            }
            return Container(
              height: screenSize.height * 0.6,
              child: ListView(
                children: cartProducts,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Bir hata oluştu.');
          } else {
            return const Text('Ürünler yüklenemedi.');
          }
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: warningColor,
              ),
            ),
          );
        }
      },
    );
  }
}

class CartProductsCard extends StatefulWidget {
  final QueryDocumentSnapshot product;
  num count;
  CartProductsCard({Key? key, required this.product, required this.count})
      : super(key: key);

  @override
  State<CartProductsCard> createState() => _CartProductsCardState();
}

class _CartProductsCardState extends State<CartProductsCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isKG = (widget.product["ölçü"] == "kg");
    return FutureBuilder<String>(
      future: FirebaseCloud()
          .getImageFromFirebaseStorage("${widget.product.id}.jpg"),
      builder: (context, imageSnapshot) {
        if (imageSnapshot.connectionState == ConnectionState.done) {
          return FadedSlideAnimation(
            beginOffset: const Offset(-10, 0),
            endOffset: Offset.zero,
            child: Card(
              color: secondaryColor,
              elevation: 20,
              shadowColor: secondaryColor,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: accentColor, width: 3),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          imageSnapshot.data!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadedSlideAnimation(
                            beginOffset: const Offset(0, -1),
                            endOffset: Offset.zero,
                            child: Text(
                              widget.product.id.toCapitalized(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkTextColor,
                              ),
                            ),
                          ),
                          FadedSlideAnimation(
                            beginOffset: const Offset(0, -1),
                            endOffset: Offset.zero,
                            child: Text(
                              "${widget.product['fiyat'].toStringAsFixed(2)} TL/${widget.product['ölçü']}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: darkTextColor,
                              ),
                            ),
                          ),
                          FadedSlideAnimation(
                            beginOffset: const Offset(0, -1),
                            endOffset: Offset.zero,
                            child: Text(
                              "${(widget.product["fiyat"] * widget.count).toStringAsFixed(2)} TL",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: darkTextColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: FadedSlideAnimation(
                      beginOffset: const Offset(0, -1),
                      endOffset: Offset.zero,
                      child: CounterButton(
                        addIcon: const Icon(
                          Icons.add_circle_outline_outlined,
                          color: accentColor,
                        ),
                        removeIcon: const Icon(
                          Icons.remove_circle_outline_outlined,
                          color: accentColor,
                        ),
                        count: widget.count,
                        onChange: (value) async {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                                    widget.count = value;
                                    isLoading = true;
                                  }));
                          await FirebaseCloud()
                              .addToCart(widget.product, value);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                                    widget.count = value;
                                    isLoading = false;
                                  }));
                        },
                        loading: isLoading,
                        countBoxColor: primaryColor,
                        countColor: lightTextColor,
                        boxColor: secondaryColor,
                        borderColor: accentColor,
                        step: isKG ? 0.5 : 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: CircularProgressIndicator(
              color: warningColor,
            )),
          );
        }
      },
    );
  }
}
