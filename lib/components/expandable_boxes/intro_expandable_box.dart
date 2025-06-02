import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class IntroExpandableBox extends StatefulWidget {
  const IntroExpandableBox({super.key});

  @override
  State<IntroExpandableBox> createState() => _IntroExpandableBoxState();
}

class _IntroExpandableBoxState extends State<IntroExpandableBox> {
  bool _isExpanded = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantInfoProvider = Provider.of<RestaurantInfoProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8,
          ),
          child: ListTile(
            title: const Text(
              '가게소개',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            trailing: ExpandIcon(
              isExpanded: _isExpanded,
              color: Colors.grey,
              expandedColor: Colors.purple,
              onPressed: (isExpanded) {
                setState(
                  () {
                    _isExpanded = !isExpanded;
                  },
                );
              },
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 10,
            ),
            child: Row(
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
                              '가게소개 작성하기',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            scrollable: true,
                            actions: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white60),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: TextFormField(
                                            controller: _textEditingController,
                                            minLines: 40,
                                            maxLines: null,
                                            decoration: const InputDecoration(
                                              hintText: '가게소개글을 작성해주세요',
                                            ),
                                          ),
                                        ),
                                      ),
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
                                          if (_textEditingController
                                              .text.isNotEmpty) {
                                            dialogIndicator(context);
                                            final docRef = FirebaseFirestore
                                                .instance
                                                .collection("restaurantData")
                                                .doc(currentUser!.uid);
                                            await docRef.update({
                                              "intro":
                                                  _textEditingController.text
                                            });
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          } else {
                                            generalDialog(
                                                context, '가게소개글을 작성해주세요.');
                                          }
                                          _textEditingController.clear();
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
                    future: restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('가게소개를 작성해주세요');
                      } else {
                        return Text(restaurantInfoProvider.intro ?? '');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
