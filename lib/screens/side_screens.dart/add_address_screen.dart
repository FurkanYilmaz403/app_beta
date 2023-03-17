import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

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
  final _apartmentController = TextEditingController();
  final LatLng _center = const LatLng(38.423481, 27.142984);

  void _onMapTap(LatLng position) {
    if (mapHeight == 200) {
      setState(() {
        mapHeight = screenSize.height;
        showSubmitButton = true;
      });
    } else {
      setState(() {
        _markerPosition = position;
      });
    }
  }

  void submitLocation() {
    setState(() {
      mapHeight = 200;
      showSubmitButton = false;
    });
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
                        elevation: MaterialStatePropertyAll(10),
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
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
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
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _apartmentController,
                        decoration: InputDecoration(
                          labelText: 'Apartment',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an apartment number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Do something with the input data
                            final address = _addressController.text;
                            final apartment = _apartmentController.text;
                            print('Address: $address');
                            print('Apartment: $apartment');
                          }
                        },
                        child: const Text('Submit'),
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
