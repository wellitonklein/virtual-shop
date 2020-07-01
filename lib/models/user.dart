import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_shop/models/address.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  bool admin = false;

  Address address;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
  });

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    if (document.data.containsKey('address')) {
      address =
          Address.fromMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef =>
      Firestore.instance.document('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Future<void> setAddress(Address address) async {
    this.address = address;

    saveData();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address != null) 'address': address.toMap(),
    };
  }
}
