import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/cards/rep_menu_card.dart';

class RepMenuProvider extends ChangeNotifier {
  String? menuImage;
  String? menuName;
  List<RepMenuCard> repMenuList = [];

  Future<void> fetchRepMenu(String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('restaurantData').doc(uid);
    docRef.snapshots().listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          Map<String, dynamic>? repMenu = data['repMenu'];
          if (repMenu != null) {
            if (repMenu.isNotEmpty) {
              repMenuList.clear();
              for (var repMenuEntry in repMenu.entries) {
                if (repMenuEntry.value is Map) {
                  Map<String, dynamic> repMenuData = repMenuEntry.value;
                  if (repMenuData.containsKey('menuImage') &&
                      repMenuData.containsKey('menuName')) {
                    menuImage = repMenuData['menuImage'];
                    menuName = repMenuData['menuName'];
                    repMenuList.add(
                      RepMenuCard(menuName: menuName!, menuImage: menuImage!),
                    );
                  }
                }
              }
            }
          }
          notifyListeners();
        }
      },
    );
  }
}
