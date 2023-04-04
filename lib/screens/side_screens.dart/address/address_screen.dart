import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/side_screens.dart/address/add_address_screen.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressScreen extends StatefulWidget {
  final DocumentSnapshot? currentAddress;
  final Function refresh;
  const AddressScreen(
      {Key? key, required this.currentAddress, required this.refresh})
      : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool loading1 = false;

  @override
  Widget build(BuildContext context) {
    String? selectedAddress = widget.currentAddress?.id;
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
                addresses.add(
                  Card(
                    color: secondaryColor,
                    shadowColor: secondaryColor,
                    elevation: 20,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: accentColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Stack(children: [
                        Radio(
                          fillColor:
                              const MaterialStatePropertyAll(accentColor),
                          value: address.id,
                          groupValue: selectedAddress,
                          onChanged: (value) async {
                            setState(() {
                              loading1 = true;
                            });
                            await FirebaseCloud().setCurrentAddress(address.id);
                            widget.refresh();
                            setState(() {
                              loading1 = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        if (loading1) const CircularProgressIndicator()
                      ]),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Text(
                        address['Adres Tipi'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                      subtitle: Text(
                        address['Açık Adres'],
                        style: const TextStyle(color: darkTextColor),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: warningColor,
                        ),
                        onPressed: () async {
                          setState(() {
                            loading1 = true;
                          });
                          await FirebaseCloud().deleteAddress(address.id);
                          widget.refresh();
                          setState(() {
                            loading1 = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                );
              }
              addresses.add(const Padding(padding: EdgeInsets.all(16)));
              addresses.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAddressScreen(
                              refresh: () {
                                setState(() {});
                                widget.refresh();
                              },
                            ),
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        shadowColor: MaterialStatePropertyAll(primaryColor),
                        elevation: MaterialStatePropertyAll(10),
                        backgroundColor: MaterialStatePropertyAll(primaryColor),
                        shape: MaterialStatePropertyAll(
                          CircleBorder(
                            side: BorderSide(color: accentColor, width: 2),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              return ListView(
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
