import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/dialogs.dart';

class SalesHistoryListTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const SalesHistoryListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return ListTile(
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '판매품명: ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: data['itemName'],
                    style: const TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '판매일시: ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: data['paidTime'],
                    style: const TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '구매자: ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: data['displayName'],
                    style: const TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '판매금액: ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: '${data['price']}원',
                    style: const TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 50,
        child: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                title: const Text(
                  ' \n 판매내역을 삭제하시겠습니? \n',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                scrollable: true,
                actions: [
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () async {
                          dialogIndicator(context);
                          await FirebaseFirestore.instance
                              .collection('restaurantData')
                              .doc(currentUser!.uid)
                              .collection("salesHistory")
                              .doc(data["orderId"])
                              .delete();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
