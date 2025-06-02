import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/state_management/deal_offer_provider.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class DealOfferPage extends StatefulWidget {
  const DealOfferPage({super.key});

  @override
  State<DealOfferPage> createState() => _DealOfferPageState();
}

class _DealOfferPageState extends State<DealOfferPage> {
  final TextEditingController _rateEditor = TextEditingController();
  final TextEditingController _priceEditor = TextEditingController();
  final TextEditingController _qtyEditor = TextEditingController();

  @override
  void dispose() {
    _rateEditor.dispose();
    _priceEditor.dispose();
    _qtyEditor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dealOfferProvider = Provider.of<DealOfferProvider>(context);
    final restaurantInfoProvider = Provider.of<RestaurantInfoProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    late num? rate = num.parse(_rateEditor.text);
    late num? price = num.parse(_priceEditor.text);
    late num? qty = num.parse(_qtyEditor.text);

    updateDeals() async {
      final docRef = FirebaseFirestore.instance
          .collection("restaurantData")
          .doc(currentUser!.uid);
      try {
        await docRef.update({
          "deals.$rate%.itemName": "${restaurantInfoProvider.name} $rate%딜",
          "deals.$rate%.price": price,
          "deals.$rate%.qty": qty,
          "deals.$rate%.rate": rate
        });
      } catch (e) {
        return;
      }
    }

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Scaffold(
                            resizeToAvoidBottomInset: false,
                            backgroundColor: Colors.transparent,
                            body: AlertDialog(
                              title: const Text(
                                '딜제공 추가하기',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              scrollable: true,
                              actions: [
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                controller: _rateEditor,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(r'[0-9]'),
                                                  ),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const SizedBox(
                                            width: 80,
                                            child: Text(
                                              '%딜 제공',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                controller: _priceEditor,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(r'[0-9]'),
                                                  ),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const SizedBox(
                                            width: 80,
                                            child: Text(
                                              '원에 판매',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                controller: _qtyEditor,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0.5,
                                                            color: Colors
                                                                .pinkAccent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(r'[0-9]'),
                                                  ),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const SizedBox(
                                            width: 80,
                                            child: Text(
                                              '개',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              if (_priceEditor.text.isEmpty ||
                                                  _rateEditor.text.isEmpty ||
                                                  _qtyEditor.text.isEmpty ||
                                                  _priceEditor.text == '' ||
                                                  _rateEditor.text == '' ||
                                                  _qtyEditor.text == '') {
                                                generalDialog(
                                                    context, '모든 항목을 입력해주세요.');
                                              } else {
                                                showDialog(
                                                  barrierColor: Colors.black26,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        '${_rateEditor.text}% 딜제공,\n${_priceEditor.text}원에 판매 + 보너스: ${price * rate ~/ 100}원,\n수량: ${_qtyEditor.text}개',
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
                                                        '제공하시겠습니까?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      scrollable: true,
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                showDialog(
                                                                  barrierColor:
                                                                      Colors
                                                                          .black12,
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) =>
                                                                          const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                                );
                                                                await updateDeals();
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
                                                                    }
                                                                  }
                                                                }
                                                                _priceEditor
                                                                    .clear();
                                                                _rateEditor
                                                                    .clear();
                                                                _qtyEditor
                                                                    .clear();
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                elevation: 3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .purple,
                                                              ),
                                                              child: const Text(
                                                                '확인',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            TextButton(
                                                              onPressed: () {
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
                                                                '취소',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              elevation: 3,
                                              backgroundColor: Colors.purple,
                                            ),
                                            child: const Text(
                                              '확인',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _priceEditor.clear();
                                              _rateEditor.clear();
                                              _qtyEditor.clear();
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle_outlined,
                    color: Colors.pink,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              '딜제공 추가하기',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<void>(
            future: dealOfferProvider.fetchDealOffers(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: CircularProgressIndicator());
              } else if (dealOfferProvider.dealsList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      '아직 제공하시는 딜이 없습니다.\n딜을 추가해주세요.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dealOfferProvider.dealsList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            dealOfferProvider.dealsList[index]),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
