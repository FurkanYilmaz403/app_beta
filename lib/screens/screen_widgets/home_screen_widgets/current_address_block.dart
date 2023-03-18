import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/side_screens.dart/address_screen.dart';
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
        final addressType = snapshot.data?["Adres Tipi"];
        final openAddress = snapshot.data?["Açık Adres"];
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreen(
                      currentAddress: snapshot.data,
                    ),
                  ),
                );
              },
              child: Container(
                height: addressSize,
                color: secondaryColor,
                child: Text(
                  addressType + openAddress,
                  style: const TextStyle(color: darkTextColor),
                ),
              ),
            );
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
