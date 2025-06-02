import 'package:flutter/material.dart';

class DropDownAmendment extends StatelessWidget {
  final String unique;
  final String title;
  final String actionTitle;
  final String subTitle;
  final String dropdownValue;
  final List<String> items;
  final Function(String?) onChanged;
  final VoidCallback onPressed;
  final Future<void> Function() fetchFunction;

  const DropDownAmendment({
    super.key,
    required this.unique,
    required this.title,
    required this.actionTitle,
    required this.subTitle,
    required this.dropdownValue,
    required this.items,
    required this.onChanged,
    required this.onPressed,
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
                                    child: (dropdownValue == '지역 선택' ||
                                            dropdownValue == '카테고리 선택')
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
