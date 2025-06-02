import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/list_tiles/sales_history_list_tile.dart';
import 'package:r2reowner/state_management/sales_history_provider.dart';

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final salesHistoryProvider = Provider.of<SalesHistoryProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: FutureBuilder<void>(
        future: salesHistoryProvider.fetchSalesHistoryList(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (salesHistoryProvider.salesHistoryList.isEmpty) {
            return const Center(
              child: Text(
                '아직 판매내역이 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: salesHistoryProvider.salesHistoryList.length,
              itemBuilder: (BuildContext context, int index) {
                final salesHistoryData =
                    salesHistoryProvider.salesHistoryList[index];
                return SalesHistoryListTile(data: salesHistoryData);
              },
            );
          }
        },
      ),
    );
  }
}
