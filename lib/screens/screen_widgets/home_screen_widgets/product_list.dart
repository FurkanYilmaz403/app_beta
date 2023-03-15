import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final String categoryName;
  final ElevatedButton returnButton;
  const ProductList(
      {super.key, required this.categoryName, required this.returnButton});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseCloud().getProductsInCategory(categoryName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            int count = 0;
            final rows = <Widget>[];
            final products = <Widget>[
              TitleContainer(
                categoryName: categoryName,
                returnButton: returnButton,
              ),
            ];
            for (final product in snapshot.data!.docs) {
              rows.add(
                FutureBuilder<String>(
                  future: FirebaseCloud()
                      .getImageFromFirebaseStorage("${product.id}.jpg"),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.done) {
                      return ProductCard(
                        imageUrl: imageSnapshot.data!,
                        product: product,
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
                ),
              );
              count++;
              if (count % 2 == 0) {
                products.add(Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rows.toList(),
                ));
                count = 0;
                rows.clear();
              }
            }
            products.add(Row(
              children: rows,
            ));
            products.add(
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: products,
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
            )),
          );
        }
      },
    );
  }
}

class TitleContainer extends StatelessWidget {
  final String categoryName;
  final ElevatedButton returnButton;
  TitleContainer(
      {super.key, required this.categoryName, required this.returnButton});

  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      child: Container(
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: accentColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
          border: Border.all(
              color: primaryColor,
              width: 3,
              strokeAlign: BorderSide.strokeAlignOutside),
        ),
        width: screenSize.width - 80,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 6,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: returnButton,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  categoryName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final QueryDocumentSnapshot product;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  num count = 0;

  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    final bool isKG = (widget.product["ölçü"] == "kg");
    return FadedSlideAnimation(
      beginOffset: const Offset(-1, 0),
      endOffset: Offset.zero,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: primaryColor,
          shadowColor: primaryColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: accentColor, width: 3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 30,
          child: InkWell(
            onTap: () {
              if (count <= 0.01) {
                setState(() {
                  count = 1;
                });
              } else {
                setState(() {
                  count = 0;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                decoration:
                    BoxDecoration(border: Border.all(color: accentColor)),
                duration: Duration.zero,
                width: screenSize.width * 0.38,
                height: (count >= (isKG ? 0.1 : 1)) ? 310 : 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          widget.product.id.toCapitalized(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightTextColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          "${widget.product['fiyat'].toStringAsFixed(2)} TL/${widget.product['ölçü']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: lightTextColor,
                          ),
                        ),
                      ),
                    ),
                    if (count >= (isKG ? 0.1 : 1))
                      FadedSlideAnimation(
                        beginOffset: const Offset(0, -1),
                        endOffset: Offset.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              color: lightTextColor,
                              onPressed: () {
                                setState(() {
                                  if (isKG) {
                                    count -= 0.1;
                                  } else {
                                    count--;
                                  }
                                });
                              },
                            ),
                            Text(
                              isKG
                                  ? "${count.toStringAsFixed(1)} kg"
                                  : "${count.toStringAsFixed(0)} tane",
                              style: const TextStyle(color: lightTextColor),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              color: lightTextColor,
                              onPressed: () {
                                setState(() {
                                  if (isKG) {
                                    count += 0.1;
                                  } else {
                                    count++;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    if (count >= (isKG ? 0.1 : 1))
                      FadedSlideAnimation(
                        beginOffset: const Offset(0, -1),
                        endOffset: Offset.zero,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shadowColor: accentColor,
                              backgroundColor: accentColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: const Text(
                              'Sepete Ekle',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkTextColor,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
