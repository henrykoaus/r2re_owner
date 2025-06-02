import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/state_management/rep_menu_provider.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class RepMenuExpandableBox extends StatefulWidget {
  const RepMenuExpandableBox({super.key});

  @override
  State<RepMenuExpandableBox> createState() => _RepMenuExpandableBoxState();
}

class _RepMenuExpandableBoxState extends State<RepMenuExpandableBox> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    XFile? imageXfile;
    final currentUser = FirebaseAuth.instance.currentUser;
    final restaurantInfoProvider =
        Provider.of<RestaurantInfoProvider>(context, listen: false);
    final repMenuProvider = Provider.of<RepMenuProvider>(context);

    selectMenuImage() async {
      if (!kIsWeb) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile == null) return;
        setState(
          () {
            imageFile = File(pickedFile.path);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(''),
                content: const Text(
                  '사진이 선택되었습니다.\n메뉴이름을 정하신후\n확인버튼을 눌러주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else if (kIsWeb) {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile == null) return;
        setState(
          () {
            imageXfile = XFile(pickedFile.path);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(''),
                content: const Text(
                  '사진이 선택되었습니다.\n메뉴이름을 정하신후\n확인버튼을 눌러주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }

    uploadMenuImage(String unique, String text) async {
      if (!kIsWeb) {
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          // contentType: 'image/png',
          customMetadata: {'picked-file-path': imageFile!.path},
        );
        UploadTask uploadTask;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('repMenuImages')
            .child('/images-$unique')
            .child('/$unique-$text.jpg');
        final docRef = FirebaseFirestore.instance
            .collection("restaurantData")
            .doc(currentUser!.uid);
        try {
          uploadTask = ref.putData(await imageFile!.readAsBytes(), metadata);
          final imgUrl = await (await uploadTask).ref.getDownloadURL();
          await docRef.update({"repMenu.$text.menuImage": imgUrl});
          await docRef.update({"repMenu.$text.menuName": text});
        } catch (e) {
          return;
        }
      } else if (kIsWeb) {
        final Uint8List imageData = await XFile(imageXfile!.path).readAsBytes();
        UploadTask uploadTask;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('repMenuImages')
            .child('/images-$unique')
            .child('/$unique-$text.jpg');
        final docRef = FirebaseFirestore.instance
            .collection("restaurantData")
            .doc(currentUser!.uid);
        try {
          uploadTask = ref.putData(imageData);
          final imgUrl = await (await uploadTask).ref.getDownloadURL();
          await docRef.update({"repMenu.$text.menuImage": imgUrl});
          await docRef.update({"repMenu.$text.menuName": text});
        } catch (e) {
          return;
        }
      }
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8,
          ),
          child: ListTile(
            title: const Text(
              '대표메뉴',
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
            child: SizedBox(
              height: 130,
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
                                '대표메뉴 등록하기',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            children: [
                                              TextButton.icon(
                                                onPressed: selectMenuImage,
                                                icon: const Icon(
                                                    Icons.photo_library),
                                                label: const Text('사진 선택하기'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        imageFile != null
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.pink,
                                              )
                                            : const Text(''),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '메뉴이름:',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
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
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.purple),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.purple),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 0.5,
                                                      color: Colors.purple),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
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
                                            if (imageFile != null ||
                                                _textEditingController
                                                    .text.isNotEmpty) {
                                              dialogIndicator(context);
                                              await uploadMenuImage(
                                                  restaurantInfoProvider
                                                          .unique ??
                                                      '',
                                                  _textEditingController.text);
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(''),
                                                  content: const Text(
                                                    '사진등록 또는 메뉴이름을\n입력해주세요',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        '닫기',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepPurple,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
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
                      Icons.add_circle_outlined,
                      color: Colors.pink,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<void>(
                      future: repMenuProvider.fetchRepMenu(currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return ListView();
                        } else if (repMenuProvider.repMenuList.isEmpty) {
                          return ListView();
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: repMenuProvider.repMenuList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                repMenuProvider.repMenuList[index],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
