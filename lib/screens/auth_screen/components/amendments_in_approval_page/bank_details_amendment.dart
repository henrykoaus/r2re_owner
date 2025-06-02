import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankDetailsAmendment extends StatelessWidget {
  final String bankTitle;
  final String bankAccount;
  final String dropdownValue;
  final List<String> items;
  final Function(String?) onChanged;
  final VoidCallback onPressed;
  final TextEditingController textEditingController;
  final Future<void> Function() fetchFunction;

  const BankDetailsAmendment({
    super.key,
    required this.bankTitle,
    required this.bankAccount,
    required this.dropdownValue,
    required this.items,
    required this.onChanged,
    required this.onPressed,
    required this.textEditingController,
    required this.fetchFunction,
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
                    title: const Text(
                      '정산계좌 수정하기',
                      style: TextStyle(
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
                              child: DropdownButtonFormField(
                                value: dropdownValue,
                                menuMaxHeight: 300,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    filled: true,
                                    fillColor: Colors.grey[100]),
                                dropdownColor: Colors.grey[100],
                                items: items.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: (dropdownValue == '은행 선택')
                                        ? Text(
                                            '   $item',
                                            style: const TextStyle(
                                                color: Colors.black54),
                                          )
                                        : Text(
                                            '   $item',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  );
                                }).toList(),
                                onChanged: onChanged,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: textEditingController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              autocorrect: false,
                              textInputAction: TextInputAction.go,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9. -]'),
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
                                  onPressed: onPressed,
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
                    text: '정산계좌: ',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: bankTitle,
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const TextSpan(
                        text: '  ',
                      ),
                      TextSpan(
                        text: bankAccount,
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
