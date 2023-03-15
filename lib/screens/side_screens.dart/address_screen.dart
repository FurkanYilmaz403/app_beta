import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/side_screens.dart/add_address_screen.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: primaryColor,
          shadowColor: accentColor,
          title: Image.asset(
            logo,
            width: logoSize,
            height: logoSize,
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseCloud().getAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final addresses = <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ];
              for (final address in snapshot.data!.docs) {
                //ListView olarak adresleri sıralayacağız
              }
              addresses.add(
                const Spacer(),
              );
              addresses.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddressScreen(),
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        shadowColor: MaterialStatePropertyAll(primaryColor),
                        elevation: MaterialStatePropertyAll(10),
                        backgroundColor: MaterialStatePropertyAll(primaryColor),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              color: accentColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 30,
                        ),
                        child: Text(
                          "Adres Ekle",
                          style: TextStyle(
                            color: lightTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: addresses,
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
      ),
    );
  }
}
