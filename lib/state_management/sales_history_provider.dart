import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesHistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _salesHistoryList = [];

  List<Map<String, dynamic>> get salesHistoryList => _salesHistoryList;

  Future<void> fetchSalesHistoryList(String uid) async {
    final salesHistoryDataCollection = FirebaseFirestore.instance
        .collection('restaurantData')
        .doc(uid)
        .collection('salesHistory');
    try {
      QuerySnapshot snapshot = await salesHistoryDataCollection
          .orderBy('paidTime', descending: true)
          .get();
      _salesHistoryList = [];
      for (var doc in snapshot.docs) {
        _salesHistoryList.add(doc.data() as Map<String, dynamic>);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
