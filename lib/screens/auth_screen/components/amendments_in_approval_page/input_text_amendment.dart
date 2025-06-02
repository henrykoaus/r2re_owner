import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r2reowner/components/dialogs.dart';

class InputTextAmendment extends StatelessWidget {
  final String unique;
  final String title;
  final String actionTitle;
  final String subTitle;
  final TextEditingController textEditingController;
  final bool inputFormatters;
  final TextInputType keyboardType;
  final Future<void> Function() fetchFunction;
  final Color color;

  const InputTextAmendment({
    super.key,
    required this.unique,
    required this.title,
    required this.actionTitle,
    required this.subTitle,
    required this.textEditingController,
    required this.inputFormatters,
    required this.keyboardType,
    required this.fetchFunction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
                    title: Text(
                      '$title 수정하기',
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    scrollable: true,
                    actions: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: textEditingController,
                                keyboardType: keyboardType,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                autocorrect: false,
                                textInputAction: TextInputAction.go,
                                inputFormatters: (inputFormatters == true)
                                    ? <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9. -]'),
                                        ),
                                      ]
                                    : [],
                              ),
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
                                          .doc(unique);
                                      await docRef.update({
                                        actionTitle: textEditingController.text
                                      });
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    } else {
                                      generalDialog(
                                          context, '입력한 내용을 다시 확인해주세요.');
                                    }
                                    textEditingController.clear();
                                  },
                                  style: TextButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: Colors.purple,
                                  ),
                                  child: const Text(
                                    '수정',
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
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: FutureBuilder<void>(
            future: fetchFunction(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RichText(
                  text: const TextSpan(
                    text: '',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                    children: <TextSpan>[
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
                        style: TextStyle(
                          color: color,
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
