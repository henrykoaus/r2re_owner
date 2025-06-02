import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantInfoProvider extends ChangeNotifier {
  String? image;
  String? name;
  String? category;
  String? region;
  String? address;
  String? telephone;
  String? ownerName;
  String? registration;
  String? intro;
  String? unique;
  Map<String, dynamic>? openingHours;
  Map<String, dynamic>? bankDetails;

  Future<void> fetchRestaurantInfo(String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('restaurantData').doc(uid);
    docRef.snapshots().listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          image = data['image'];
          name = data['name'];
          category = data['category'];
          region = data['region'];
          address = data['address'];
          telephone = data['telephone'];
          ownerName = data['ownerName'];
          registration = data['registration'];
          intro = data['intro'];
          openingHours = data['openingHours'];
          unique = data['unique'];
          bankDetails = data['bankDetails'];
          notifyListeners();
        }
      },
    );
  }
}
