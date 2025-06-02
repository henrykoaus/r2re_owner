import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/dialogs.dart';

class DealOfferCard extends StatelessWidget {
  final num rate;
  final num price;
  final num qty;

  const DealOfferCard({
    super.key,
    required this.rate,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Stack(
          children: [
            SizedBox(
              height: 110,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Center(
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 110,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        elevation: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 90,
                                width: MediaQuery.of(context).size.height / 9,
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: const CircleBorder(),
                                  shadowColor: Colors.purple,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            '판매',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            minFontSize: 10,
                                            maxFontSize: 18,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      AutoSizeText(
                                        '$price원',
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        minFontSize: 10,
                                        maxFontSize: 18,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Card(
                                margin: const EdgeInsets.all(2),
                                shape: const CircleBorder(),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/payment_logo.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 90,
                                width: MediaQuery.of(context).size.height / 9,
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: const CircleBorder(),
                                  shadowColor: Colors.pink,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            '보너스',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            minFontSize: 10,
                                            maxFontSize: 18,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      AutoSizeText(
                                        '${price * rate ~/ 100}원',
                                        style: const TextStyle(
                                            color: Colors.pink,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        minFontSize: 10,
                                        maxFontSize: 18,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 80,
              child: Stack(
                children: [
                  SizedBox(
                    height: 50,
                    width: 60,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: AutoSizeText(
                                '$rate%딜',
                                style: const TextStyle(
                                    color: Colors.pinkAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 10,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.discount,
                    color: Colors.purple,
                    size: 20,
                  ),
                ],
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / 20,
              bottom: MediaQuery.of(context).size.height / 60,
              child: Text(
                '$qty개',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / 30,
              top: MediaQuery.of(context).size.height / 250,
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
                        ' \n 해당 제공 딜을 삭제하시겠습니? \n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                                    .update(
                                        {'deals.$rate%': FieldValue.delete()});
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Colors.purple,
                              ),
                              child: const Text(
                                '삭제',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                  color: Colors.pink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
