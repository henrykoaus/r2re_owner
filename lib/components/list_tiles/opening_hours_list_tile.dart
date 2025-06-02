import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r2reowner/components/dialogs.dart';

class OpeningHoursListTile extends StatelessWidget {
  final Future<void> Function() fetchFunction;
  final String title;
  final String subTitle;
  final String day;
  final TextEditingController textEditingController;

  const OpeningHoursListTile(
      {super.key,
      required this.fetchFunction,
      required this.title,
      required this.subTitle,
      required this.day,
      required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: AlertDialog(
                    title: const Text(
                      '영업시간 수정하기',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    scrollable: true,
                    actions: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '$title:',
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: textEditingController,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.purple),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.purple),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.purple),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (textEditingController.text.isNotEmpty) {
                                    dialogIndicator(context);
                                    final docRef = FirebaseFirestore.instance
                                        .collection("restaurantData")
                                        .doc(currentUser!.uid);
                                    await docRef.update({
                                      "openingHours.$day":
                                          textEditingController.text
                                    });
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  } else {
                                    generalDialog(context, '영업시간을 입력해주세요.');
                                  }
                                  textEditingController.clear();
                                },
                                style: TextButton.styleFrom(
                                  elevation: 3,
                                  backgroundColor: Colors.purple,
                                ),
                                child: const Text(
                                  '확인',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  textEditingController.clear();
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
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.pink,
          ),
        ),
        Expanded(
          child: FutureBuilder<void>(
            future: fetchFunction(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RichText(
                  text: TextSpan(
                    text: '$title: ',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                    children: const <TextSpan>[
                      TextSpan(
                        text: '',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return RichText(
                  text: TextSpan(
                    text: '$title: ',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: subTitle,
                        style: const TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
