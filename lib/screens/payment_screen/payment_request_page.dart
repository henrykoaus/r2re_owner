import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/cards/payment_request_card.dart';
import 'package:r2reowner/state_management/payment_provider.dart';

class PaymentRequestPage extends StatelessWidget {
  const PaymentRequestPage({
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
          future: paymentProvider.fetchPaymentRequestList(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (paymentProvider.paymentRequestList.isEmpty) {
              return const Center(
                child: Text(
                  '아직 요청된 계산이 없습니다.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: paymentProvider.paymentRequestList.length,
                itemBuilder: (BuildContext context, int index) {
                  final paymentData = paymentProvider.paymentRequestList[index];
                  return PaymentRequestCard(data: paymentData);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
