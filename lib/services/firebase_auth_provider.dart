import 'dart:async';

import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/utilities/widgets/pop_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider {
  final FirebaseAuth _auth;
  FirebaseAuthProvider(this._auth);

  User get user => _auth.currentUser!;

  // Email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      popSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // PHONE SIGN IN
  Future<String?> signUpWithPhone(
    String? phoneNumber,
  ) async {
    String? error;
    // FOR ANDROID, IOS
    await _auth.verifyPhoneNumber(
      phoneNumber: "+90$phoneNumber",
      verificationCompleted: (phoneAuthCredential) {},
      codeSent: (String verificationId, forceResendingToken) {
        verificationIdSaved = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationIdSaved = verificationId;
      },
      verificationFailed: (e) {
        error = e.code;
      },
    );
    return error;
  }

  Future<String?> verifyOTP(String otp) async {
    UserCredential credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationIdSaved,
        smsCode: otp,
      ),
    );
    return credentials.user != null ? null : "Hatalı kod";
  }

  Future<String?> addUserInfo(
    String email,
    String name,
    String reference,
  ) async {
    try {
      String referenceCode = await FirebaseCloud().findReference();

      if (reference.isEmpty) {
        await FirebaseFirestore.instance.collection("users").add({
          "İsim": name,
          "E-posta": email,
          "Kullanıcı ID": user.uid,
          "Kullanıcı Telefon": user.phoneNumber,
          "Kullanıcı Referans Kodu": referenceCode,
          "Referans": false,
          "Kullanılan Referans Kodu": "",
          "Referans ID": "",
          "Davet Edilen Kişi Sayısı": 0,
        });
      } else {
        QueryDocumentSnapshot<Map<String, dynamic>> referenceUser =
            await FirebaseCloud().checkReference(reference: reference);

        String referenceUserID = referenceUser.id;
        Map<String, dynamic> referenceUserData = referenceUser.data();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(referenceUserID)
            .update(
          {"Davet Edilen Kişi Sayısı": FieldValue.increment(1)},
        );

        await FirebaseFirestore.instance.collection("users").add({
          "İsim": name,
          "E-posta": email,
          "Kullanıcı ID": user.uid,
          "Kullanıcı Telefon": user.phoneNumber,
          "Kullanıcı Referans Kodu": referenceCode,
          "Referans": true,
          "Kullanılan Referans Kodu":
              referenceUserData["Kullanıcı Referans Kodu"],
          "Referans ID": referenceUserData["Kullanıcı ID"],
          "Davet Edilen Kişi Sayısı": 0,
        });
      }
      user.updateEmail(email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      popSnackBar(context, e.message!); // Displaying the error message
    }
  }
}
