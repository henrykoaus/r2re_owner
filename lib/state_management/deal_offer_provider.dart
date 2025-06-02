import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/cards/deal_offer_card.dart';

class DealOfferProvider extends ChangeNotifier {
  List<DealOfferCard> dealsList = [];

  Future<void> fetchDealOffers(String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('restaurantData').doc(uid);
    docRef.snapshots().listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          Map<String, dynamic>? deals = data['deals'];
          if (deals != null) {
            dealsList.clear();
            for (var dealEntry in deals.entries) {
              if (dealEntry.value is Map) {
                Map<String, dynamic> dealData = dealEntry.value;
                if (dealData.containsKey('rate') &&
                    dealData.containsKey('price') &&
                    dealData.containsKey('itemName') &&
                    dealData.containsKey('qty')) {
                  num rate = dealData['rate'];
                  num price = dealData['price'];
                  num qty = dealData['qty'];
                  dealsList.add(
                    DealOfferCard(
                      rate: rate,
                      price: price,
                      qty: qty,
                    ),
                  );
                }
              }
            }
            dealsList.sort((a, b) => b.rate.compareTo(a.rate));
          }
          notifyListeners();
        }
      },
    );
  }
}
