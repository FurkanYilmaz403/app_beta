import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:app_beta/utilities/widgets/pop_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  final Function refresh;
  const AddAddressScreen({Key? key, required this.refresh}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late GoogleMapController mapController;
  LatLng? _markerPosition;
  double mapHeight = 200;
  bool showSubmitButton = false;
  final screenSize = Utils().getScreenSize();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _addressTypeController = TextEditingController();
  final LatLng _center = const LatLng(38.423481, 27.142984);
  bool _isLoading = false;

  void _onMapTap(LatLng position) {
    if (mapHeight == 200) {
      setState(() {
        mapHeight = screenSize.height * 0.8;
        showSubmitButton = true;
      });
    } else {
      setState(() {
        _markerPosition = position;
      });
    }
  }

  void submitLocation() {
    if (_markerPosition == null) {
      popSnackBar(
        context,
        "Lütfen haritadan teslimat konumu seçiniz.",
      );
    } else {
      setState(() {
        mapHeight = 200;
        showSubmitButton = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
      body: ListView(
        physics: showSubmitButton
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accentColor,
                      width: 3,
                    ),
                  ),
                  duration: Duration.zero,
                  height: mapHeight,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    myLocationEnabled: true,
                    onTap: _onMapTap,
                    markers: _markerPosition == null
                        ? {}
                        : {
                            Marker(
                              markerId: const MarkerId('marker'),
                              position: _markerPosition!,
                            ),
                          },
                  ),
                ),
              ),
              if (showSubmitButton)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ElevatedButton(
                      onPressed: submitLocation,
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
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Onayla",
                          style: TextStyle(
                            color: lightTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (!showSubmitButton)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                    color: secondaryColor,
                    shadowColor: secondaryColor,
                    elevation: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Açık Adres',
                                labelStyle:
                                    const TextStyle(color: darkTextColor),
                                hintText: "Detaylı Adres Açıklaması",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: errorColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: accentColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen detaylı şekilde açık adresinizi giriniz.';
                                }
                                return null;
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            TextFormField(
                              controller: _addressTypeController,
                              decoration: InputDecoration(
                                labelText: 'Adres Başlığı',
                                labelStyle:
                                    const TextStyle(color: darkTextColor),
                                hintText: "Ev",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: errorColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: const BorderSide(
                                    color: accentColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen bir adres başlığı giriniz.';
                                } else if (value.length > 8) {
                                  return 'Lütfen en fazla 8 karakterli bir başlık giriniz.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  shadowColor:
                                      MaterialStatePropertyAll(primaryColor),
                                  elevation: MaterialStatePropertyAll(20),
                                  backgroundColor:
                                      MaterialStatePropertyAll(primaryColor),
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
                                  if (_markerPosition == null) {
                                    popSnackBar(
                                      context,
                                      "Lütfen haritadan teslimat konumu seçiniz.",
                                    );
                                    return;
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      // Show loading animation
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      // Do something with the input data
                                      final address = _addressController.text;
                                      final addressType =
                                          _addressTypeController.text;
                                      final error = await FirebaseCloud()
                                          .setAddress(
                                              '${_markerPosition!.latitude},${_markerPosition!.longitude}',
                                              address,
                                              addressType);

                                      // Hide loading animation
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (error == null) {
                                        if (mounted) {
                                          popSnackBar(context,
                                              "Adres başarıyla eklendi.");
                                        }
                                      } else {
                                        if (mounted) {
                                          popSnackBar(context, error);
                                        }
                                      }
                                      widget.refresh();
                                      await Future.delayed(
                                          const Duration(milliseconds: 2250));
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    if (!_isLoading)
                                      const Text(
                                        'Kaydet',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    if (_isLoading)
                                      const CircularProgressIndicator(
                                        color: warningColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))
        ],
      ),
    );
  }
}
