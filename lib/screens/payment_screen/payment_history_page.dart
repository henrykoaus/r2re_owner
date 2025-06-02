import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/list_tiles/payment_history_list_tile.dart';
import 'package:r2reowner/state_management/payment_provider.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<void>(
          future: paymentProvider.fetchPaymentHistoryList(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (paymentProvider.paymentHistoryList.isEmpty) {
              return const Center(
                child: Text(
                  '아직 계산내역이 없습니다.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: paymentProvider.paymentHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  final paymentData = paymentProvider.paymentHistoryList[index];
                  return PaymentHistoryListTile(data: paymentData);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
