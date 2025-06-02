import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class PaymentRequestCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const PaymentRequestCard({
    super.key,
    required this.data,
  });

  @override
  State<PaymentRequestCard> createState() => _PaymentRequestCardState();
}

class _PaymentRequestCardState extends State<PaymentRequestCard> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    late num inputAmount = num.parse(_textEditingController.text);
    late num finalBalance = widget.data["balance"] - inputAmount;
    final restaurantInfoProvider =
        Provider.of<RestaurantInfoProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    Future<void> updateBalance() async {
      final setData = {
        "inputAmount": inputAmount,
        "paymentRequestTime": widget.data["paymentRequestTime"],
        "balance": finalBalance,
        "displayName": widget.data["displayName"],
        "email": widget.data["email"],
        "itemName": widget.data["itemName"],
        "name": widget.data["name"],
        "orderId": widget.data["orderId"],
        "paidTime": widget.data["paidTime"],
        "price": widget.data["price"],
        "rate": widget.data["rate"],
        "uid": widget.data["uid"],
        "unique": widget.data["unique"],
      };
      await FirebaseFirestore.instance
          .collection('restaurantData')
          .doc(currentUser!.uid)
          .collection('paymentRequest')
          .doc(widget.data["orderId"])
          .update({"balance": finalBalance});
      if (context.mounted) {
        await FirebaseFirestore.instance
            .collection('restaurantData')
            .doc(currentUser.uid)
            .collection('paymentHistory')
            .doc(
                '${widget.data['orderId']}+$inputAmount+${widget.data['balance']}')
            .set(setData);
        if (context.mounted) {
          await FirebaseFirestore.instance
              .collection('userData')
              .doc(widget.data["uid"])
              .collection('paymentHistory')
              .doc('purchasedDeals')
              .collection('subCollection')
              .doc(
                  '${widget.data['orderId']}+$inputAmount+${widget.data['balance']}')
              .set(setData);
          if (context.mounted) {
            await FirebaseFirestore.instance
                .collection('userData')
                .doc(widget.data["uid"])
                .collection('purchasedDeals')
                .doc(widget.data["unique"])
                .collection('subCollection')
                .doc(widget.data["orderId"])
                .update({"balance": finalBalance});
            if (context.mounted) {
              await FirebaseFirestore.instance
                  .collection('userData')
                  .doc(widget.data["uid"])
                  .collection('paymentRequest')
                  .doc(widget.data["orderId"])
                  .delete();
              if (context.mounted) {
                await FirebaseFirestore.instance
                    .collection('restaurantData')
                    .doc(currentUser.uid)
                    .collection('paymentRequest')
                    .doc(widget.data["orderId"])
                    .delete();
              }
            }
          }
        }
      }
    }

    return SizedBox(
      height: 150,
      width: size.width / 1.1,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Column(
                  children: [
                    FutureBuilder<String?>(
                      future:
                          Future<String?>.value(restaurantInfoProvider.image),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/basic_photo.png"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        } else {
                          if (snapshot.data != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 90,
                                width: 90,
                                child: (!kIsWeb &&
                                        (Platform.isAndroid || Platform.isIOS))
                                    ? Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      )
                                    : ImageNetwork(
                                        image: snapshot.data!,
                                        height: 90,
                                        width: 90,
                                        fitAndroidIos: BoxFit.fill,
                                        fitWeb: BoxFitWeb.fill,
                                      ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/basic_photo.png"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 120,
                        child: Center(
                          child: AutoSizeText(
                            widget.data['name'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: AutoSizeText(
                        widget.data['itemName'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: widget.data['displayName'] ??
                                  widget.data['email'] ??
                                  '',
                              style: const TextStyle(
                                  color: Colors.purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: ' 님이',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            '계산요청을 하셨습니다.',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: '해당 딜 잔액: ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${widget.data['balance']}원',
                              style: const TextStyle(
                                  color: Colors.pink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              '계산하실 금액을 입력해주세요:',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            scrollable: true,
                            actions: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: TextField(
                                              controller:
                                                  _textEditingController,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.pinkAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.pinkAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.pinkAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: true),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[0-9. -]'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 50,
                                          child: Text(
                                            '원',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              if (_textEditingController
                                                  .text.isEmpty) {
                                                generalDialog(
                                                    context, '금액을 입력해주세요.');
                                              } else if (_textEditingController
                                                      .text.isNotEmpty &&
                                                  widget.data['balance'] >=
                                                      inputAmount) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        '계산금액: $inputAmount원',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .pinkAccent,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: const Text(
                                                        '계산하시겠습니까?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      scrollable: true,
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            dialogIndicator(
                                                                context);
                                                            updateBalance();
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.pop(
                                                                    context);
                                                                if (context
                                                                    .mounted) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  if (context
                                                                      .mounted) {
                                                                    generalDialog(
                                                                        context,
                                                                        '계산이 완료되었습니다.');
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            elevation: 3,
                                                            backgroundColor:
                                                                Colors.purple,
                                                          ),
                                                          child: const Text(
                                                            '확인',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            _textEditingController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            elevation: 3,
                                                            backgroundColor:
                                                                Colors.purple,
                                                          ),
                                                          child: const Text(
                                                            '취소',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (_textEditingController
                                                      .text.isNotEmpty &&
                                                  widget.data['balance'] <
                                                      inputAmount) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                    ),
                                                    title: const Text(
                                                      ' \n 해당 딜 잔액 내의\n금액으로 계산해주세요.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    actions: [
                                                      Center(
                                                        child: Wrap(
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                _textEditingController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                elevation: 3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .purple,
                                                              ),
                                                              child: const Text(
                                                                '닫기',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              elevation: 3,
                                              backgroundColor: Colors.purple,
                                            ),
                                            child: const Text(
                                              '계산하기',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _textEditingController.clear();
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              elevation: 3,
                                              backgroundColor: Colors.purple,
                                            ),
                                            child: const Text(
                                              '취소',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(30)),
                      child: Card(
                        margin: const EdgeInsets.all(2),
                        shape: const CircleBorder(),
                        elevation: 5,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/payment_logo.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    '계산하기',
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
