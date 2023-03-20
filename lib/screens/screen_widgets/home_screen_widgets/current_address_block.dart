import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/side_screens.dart/address/address_screen.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return FutureBuilder<DocumentSnapshot?>(
      future: FirebaseCloud().getCurrentAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              final addressType = snapshot.data?["Adres Tipi"];
              final openAddress = snapshot.data?["Açık Adres"];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressScreen(
                        currentAddress: snapshot.data,
                        refresh: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        secondaryColor.withOpacity(1),
                        secondaryColor.withOpacity(0.6)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: const Border.symmetric(
                      horizontal: BorderSide(
                        color: accentColor,
                        width: 3,
                      ),
                    ),
                  ),
                  height: addressSize,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(addressSize / 2),
                            bottomRight: Radius.circular(addressSize / 2),
                          ),
                          color: primaryColor,
                          border: Border.all(
                            color: accentColor,
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        height: addressSize,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Center(
                            child: Text(
                              addressType,
                              style: const TextStyle(
                                color: lightTextColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            openAddress,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: const TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressScreen(
                        currentAddress: null,
                        refresh: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: secondaryColor,
                    border: const Border.symmetric(
                      horizontal: BorderSide(
                        color: accentColor,
                        width: 3,
                      ),
                    ),
                  ),
                  height: addressSize,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Text(
                      "Lütfen teslimat adresi seçiniz.",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return const Text('Bir hata oluştu.');
          } else {
            return const Text('Adresler yüklenemedi.');
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
