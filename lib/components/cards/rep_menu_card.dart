import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:r2reowner/components/dialogs.dart';

class RepMenuCard extends StatelessWidget {
  final String menuImage;
  final String menuName;

  const RepMenuCard({
    super.key,
    required this.menuImage,
    required this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Stack(
      children: [
        SizedBox(
          height: 130,
          width: 130,
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                  child: SizedBox(
                    height: 80,
                    child: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                        ? Image.network(
                            menuImage,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : ImageNetwork(
                            image: menuImage,
                            height: 80,
                            width: 200,
                            fitAndroidIos: BoxFit.cover,
                            fitWeb: BoxFitWeb.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      menuName,
                      style: const TextStyle(fontSize: 16),
                      minFontSize: 10,
                      maxFontSize: 22,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -8,
          bottom: -8,
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
                    ' \n 해당 대표메뉴를 삭제하시겠습니? \n',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  scrollable: true,
                  actions: [
                    Wrap(
                      children: [
                        TextButton(
                          onPressed: () async {
                            dialogIndicator(context);
                            Reference ref = FirebaseStorage.instance
                                .ref()
                                .child('repMenuImages')
                                .child('/images-${currentUser!.uid}')
                                .child('/${currentUser.uid}-$menuName.jpg');
                            await ref.delete();
                            if (context.mounted) {
                              await FirebaseFirestore.instance
                                  .collection('restaurantData')
                                  .doc(currentUser.uid)
                                  .update(
                                {
                                  'repMenu.$menuName': FieldValue.delete(),
                                },
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.purple,
                          ),
                          child: const Text(
                            '삭제',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
