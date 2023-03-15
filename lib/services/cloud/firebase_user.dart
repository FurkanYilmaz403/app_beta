import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser {
  final String name;
  final String email;
  final String id;
  final String phone;
  final String userReferenceCode;
  final String usedReferenceCode;
  final String countInvited;

  CloudUser(
      {required this.name,
      required this.email,
      required this.id,
      required this.phone,
      required this.userReferenceCode,
      required this.usedReferenceCode,
      required this.countInvited});

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()["İsim"],
        email = snapshot.data()["E-posta"],
        id = snapshot.data()["Kullanıcı ID"],
        phone = snapshot.data()["Telefon No"],
        userReferenceCode = snapshot.data()["Kullanıcı Referans Kodu"],
        usedReferenceCode = snapshot.data()["Kullanılan Referans Kodu"],
        countInvited = snapshot.data()["Davet Edilen Kişi Sayısı"];
}
