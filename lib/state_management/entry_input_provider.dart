import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EntryInputProvider extends ChangeNotifier {
  String? name;
  String? ownerName;
  String? registration;
  String? telephone;
  String? address;
  String? region;
  String? category;
  Map<String, dynamic>? bankDetails;
  String? snsUrl;

  Future<void> fetchEntryInputData(String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('restaurantData').doc(uid);
    docRef.snapshots().listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          name = data['name'];
          category = data['category'];
          region = data['region'];
          address = data['address'];
          telephone = data['telephone'];
          ownerName = data['ownerName'];
          registration = data['registration'];
          bankDetails = data['bankDetails'];
          snsUrl = data['snsUrl'];
        }
      },
    );
  }
}
