import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/dialogs.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class RepImageEditor extends StatefulWidget {
  const RepImageEditor({super.key});

  @override
  State<RepImageEditor> createState() => _RepImageEditorState();
}

class _RepImageEditorState extends State<RepImageEditor> {
  @override
  Widget build(BuildContext context) {
    final restaurantInfoProvider =
        Provider.of<RestaurantInfoProvider>(context, listen: false);
    bool isSelected = false;
    final currentUser = FirebaseAuth.instance.currentUser;

    uploadRepImage(String unique) async {
      if (!kIsWeb) {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        File? imgFile = File(image.path);
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': imgFile.path},
        );
        UploadTask uploadTask;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('repImages')
            .child('/image-$unique.jpg');
        final docRef = FirebaseFirestore.instance
            .collection("restaurantData")
            .doc(currentUser!.uid);
        try {
          if (context.mounted) {
            dialogIndicator(context);
            uploadTask = ref.putData(await imgFile.readAsBytes(), metadata);
            final imgUrl = await (await uploadTask).ref.getDownloadURL();
            await docRef.update({"image": imgUrl});
            setState(() {
              isSelected = true;
            });
          }
        } catch (e) {
          return;
        }
      } else if (kIsWeb) {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final Uint8List imageData = await XFile(image.path).readAsBytes();
        UploadTask uploadTask;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('repImages')
            .child('/image-$unique.jpg');
        final docRef = FirebaseFirestore.instance
            .collection("restaurantData")
            .doc(currentUser!.uid);
        try {
          if (context.mounted) {
            dialogIndicator(context);
            uploadTask = ref.putData(imageData);
            final imgUrl = await (await uploadTask).ref.getDownloadURL();
            await docRef.update({"image": imgUrl});
            setState(() {
              isSelected = true;
            });
          }
        } catch (e) {
          return;
        }
      }
    }

    return Column(
      children: [
        Center(
          child: Wrap(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 5,
                child: FutureBuilder<void>(
                  future: restaurantInfoProvider
                      .fetchRestaurantInfo(currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        height: 180,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '가게 대표 사진을\n등록 해주세요',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (restaurantInfoProvider.image == null ||
                        restaurantInfoProvider.image == '' ||
                        restaurantInfoProvider.image!.isEmpty) {
                      return Container(
                        height: 180,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '가게 대표 사진을\n등록 해주세요',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: SizedBox(
                          height: 180,
                          width: 280,
                          child: (!kIsWeb &&
                                  (Platform.isAndroid || Platform.isIOS))
                              ? Image.network(
                                  restaurantInfoProvider.image!,
                                  fit: BoxFit.cover,
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
                                  image: restaurantInfoProvider.image!,
                                  height: 180,
                                  width: 280,
                                  fitAndroidIos: BoxFit.cover,
                                  fitWeb: BoxFitWeb.cover,
                                ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        '가게사진 등록하기',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      actions: [
                        ListTile(
                          leading: const Icon(
                            Icons.photo_library,
                            color: Colors.purple,
                            size: 25,
                          ),
                          title: const Text(
                            '사진갤러리',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          onTap: () async {
                            await uploadRepImage(
                              restaurantInfoProvider.unique ?? '',
                            );
                            if (isSelected == true) {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.pink,
                            size: 25,
                          ),
                          title: const Text(
                            '취소',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.upload,
                  size: 30,
                  color: Colors.pink,
                ),
              ),
              const Text(
                '사진 등록 및 수정하기',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          ),
        ),
      ],
    );
  }
}
