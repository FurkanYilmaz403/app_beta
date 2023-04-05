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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseCloud().getCart(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final cartProducts = <Widget>[];
          for (final product in snapshot.data!.docs) {
            final productReference = product.reference.path;
            cartProducts.add(
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseCloud().getCartProduct(productReference),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    return Stack(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: CartProductsCard(
                          product: snapshot.data!,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        top: -8,
                        child: FadedScaleAnimation(
                          child: IconButton(
                            onPressed: () async {
                              await FirebaseCloud().cartDeleteProduct(product);
                            },
                            icon: const Icon(
                              Icons.delete_sharp,
                              color: errorColor,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          }
          return Container(
            height: screenSize.height * 0.62,
            decoration: BoxDecoration(
              color: secondaryColor,
              border: Border.all(
                color: primaryColor,
                width: 3,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [BoxShadow(color: primaryColor, blurRadius: 30)],
            ),
            child: ListView(
              children: cartProducts,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Container(
            height: screenSize.height * 0.62,
            width: screenSize.width,
            decoration: BoxDecoration(
              color: secondaryColor,
              border: Border.all(
                color: primaryColor,
                width: 3,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [BoxShadow(color: primaryColor, blurRadius: 30)],
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Sepetiniz şimdilik boş gözüküyor.",
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 32,
                      fontFamily: "DancingScript",
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: primaryColor,
                    size: 72,
                  ),
                ]),
          );
        } else if (snapshot.hasError) {
          return const Text('Bir hata oluştu.');
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

class CartProductsCard extends StatefulWidget {
  final DocumentSnapshot product;
  const CartProductsCard({Key? key, required this.product}) : super(key: key);

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
                              "${(widget.product["fiyat"] * widget.product["miktar"]).toStringAsFixed(2)} TL",
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
                        count: widget.product["miktar"],
                        onChange: (value) async {
                          await FirebaseCloud()
                              .addToCart(widget.product, value);
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
          return const SizedBox(
            height: 124,
            width: 100,
          );
        }
      },
    );
  }
}
