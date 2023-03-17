import 'dart:convert';

import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/firebase_auth_provider.dart';
import 'package:app_beta/utilities/functions/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseCloud {
  final users = FirebaseFirestore.instance.collection('users');
  final storage = FirebaseStorage.instance;

  final user = FirebaseAuthProvider(FirebaseAuth.instance).currentUser;

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> checkReference(
      {required reference}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await users
        .where(
          "Kullanıcı Referans Kodu",
          isEqualTo: reference,
        )
        .get();

    return snapshot.docs.first;
  }

  Future<bool> checkUniquenessReference({required referenceCode}) async {
    try {
      final results = await users
          .where(
            "Kullanıcı Referans Kodu",
            isEqualTo: referenceCode,
          )
          .get();
      if (results.size == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  Future<String> findReference() async {
    String referenceCode = getRandomString(8);
    while (await checkUniquenessReference(referenceCode: referenceCode)) {
      referenceCode = getRandomString(8);
    }
    return referenceCode;
  }

  Future<bool> checkIfUserExists({required phoneNumber}) async {
    try {
      phoneNumber = "+90$phoneNumber";
      final results =
          await users.where("Kullanıcı Telefon", isEqualTo: phoneNumber).get();
      if (results.size == 0) {
        return false;
      } else {
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getCategories() async {
    var kategorilerDoc = await FirebaseFirestore.instance
        .collection('market')
        .doc('kategoriler')
        .get();

    return kategorilerDoc.data()!;
  }

  Future<QuerySnapshot> getProductsInCategory(String categoryName) async {
    return await FirebaseFirestore.instance
        .collection('market')
        .doc('kategoriler')
        .collection(categoryName)
        .get();
  }

  Future<String> getImageFromFirebaseStorage(String imageName) async {
    return await storage
        .ref()
        .child("images")
        .child(imageName)
        .getDownloadURL();
  }

  Future<int> calculateDistance(String origin, String destination) async {
    final String apiUrl =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$googleMapsDistanceMatrixApiKey";
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['rows'][0]['elements'][0]['distance']['value'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String?> setAddress(String location) async {
    final warehouses =
        await FirebaseFirestore.instance.collection("depo").get();
    int minDistance = -1;
    String warehouseId = "Depo Bulunamadı.";
    for (var element in warehouses.docs) {
      final distance = await calculateDistance(element["konum"], location);
      if (distance <= element["menzil"]) {
        if (minDistance.isNegative || minDistance > distance) {
          minDistance = distance;
          warehouseId = element.id;
        }
      }
    }
    if (warehouseId == "Depo Bulunamadı.") {
      return "İstediğiniz adrese şu anlık servis sağlayamıyoruz. Servis menzilimizi genişletene kadar beklediğiniz için teşekkür ederiz.";
    }
    final userDocs =
        await users.where("Kullanıcı ID", isEqualTo: user?.uid).get();
    await userDocs.docs.first.reference.collection("Adres").add({
      "Konum": location,
      "Açık Adres": "ksdljglkdsjgl",
      "Depo": warehouseId,
    });
    return null;
  }

  Future<QuerySnapshot> getAddresses() async {
    final userDocs =
        await users.where("Kullanıcı ID", isEqualTo: user?.uid).get();
    return await userDocs.docs.first.reference.collection("Adres").get();
  }
}
