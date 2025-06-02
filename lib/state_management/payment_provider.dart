import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _paymentRequestList = [];
  List<Map<String, dynamic>> _paymentHistoryList = [];

  List<Map<String, dynamic>> get paymentRequestList => _paymentRequestList;
  List<Map<String, dynamic>> get paymentHistoryList => _paymentHistoryList;

  Future<void> fetchPaymentRequestList(String uid) async {
    final paymentRequestDataCollection = FirebaseFirestore.instance
        .collection('restaurantData')
        .doc(uid)
        .collection('paymentRequest');
    try {
      QuerySnapshot snapshot = await paymentRequestDataCollection.get();
      _paymentRequestList = [];
      for (var doc in snapshot.docs) {
        _paymentRequestList.add(doc.data() as Map<String, dynamic>);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPaymentHistoryList(String uid) async {
    final paymentHistoryDataCollection = FirebaseFirestore.instance
        .collection('restaurantData')
        .doc(uid)
        .collection('paymentHistory');
    try {
      QuerySnapshot snapshot = await paymentHistoryDataCollection
          .orderBy('paymentRequestTime', descending: true)
          .get();
      _paymentHistoryList = [];
      for (var doc in snapshot.docs) {
        _paymentHistoryList.add(doc.data() as Map<String, dynamic>);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
