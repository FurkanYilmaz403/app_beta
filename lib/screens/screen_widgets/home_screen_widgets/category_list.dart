import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:app_beta/screens/screen_widgets/home_screen_widgets/product_list.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String shownContainer = "categories";

  @override
  Widget build(BuildContext context) {
    ElevatedButton returnCategories = ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(primaryColor),
        iconColor: MaterialStatePropertyAll(accentColor),
        shape: MaterialStatePropertyAll(
          CircleBorder(side: BorderSide(color: accentColor)),
        ),
        elevation: MaterialStatePropertyAll(10),
        shadowColor: MaterialStatePropertyAll(primaryColor),
      ),
      onPressed: () {
        setState(() {
          shownContainer = "categories";
        });
      },
      child: const Icon(Icons.arrow_back_rounded),
    );
    if (shownContainer == "categories") {
      return FutureBuilder<Map<String, dynamic>>(
        future: FirebaseCloud().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final categories = <Widget>[
                TitleContainer(),
              ];
              for (final category in snapshot.data!.keys) {
                categories.add(
                  FutureBuilder<String>(
                    future: FirebaseCloud()
                        .getImageFromFirebaseStorage("$category.jpg"),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState ==
                          ConnectionState.done) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              shownContainer = category;
                            });
                          },
                          child: FadedScaleAnimation(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 150,
                              margin: const EdgeInsets.all(16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: accentColor,
                                    blurRadius: 15,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(imageSnapshot.data!),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.35),
                                      BlendMode.dstATop),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(50),
                                  bottom: Radius.circular(50),
                                ),
                                border: Border.all(
                                  color: accentColor,
                                  width: 3,
                                ),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            const Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                category.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: darkTextColor,
                                                  decoration:
                                                      TextDecoration.combine([
                                                    TextDecoration.underline,
                                                    TextDecoration.overline
                                                  ]),
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .double,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: const [
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  Icon(Icons.arrow_forward_ios),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                );
              }
              categories.add(
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categories,
              );
            } else if (snapshot.hasError) {
              return const Text('Bir hata oluştu.');
            } else {
              return const Text('Kategoriler yüklenemedi.');
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
    } else {
      return WillPopScope(
          onWillPop: () {
            setState(() {
              shownContainer = "categories";
            });
            return Future.value(false);
          },
          child: ProductList(
            categoryName: shownContainer,
            returnButton: returnCategories,
          ));
    }
  }
}

class TitleContainer extends StatelessWidget {
  TitleContainer({super.key});

  final screenSize = Utils().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
        child: const Center(
          child: Text(
            "Kategoriler",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: darkTextColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
