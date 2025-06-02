import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:r2reowner/components/dialogs.dart';

signInWithEmail(BuildContext context, String email, String password) async {
  dialogIndicator(context);
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (context.mounted) {
      context.go('/auth/email_verification');
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }
    String message = '';
    if (e.code == 'user-not-found') {
      message = '사용자가 존재하지 않습니다.';
    } else if (e.code == 'wrong-password') {
      message = '비밀번호를 확인해주세요';
    } else if (e.code == 'invalid-email') {
      message = '이메일을 확인해주세요.';
    } else {
      message = '올바른 이메일주소\n또는 비밀번호를\n입력해주세요.';
    }
    if (context.mounted) {
      generalDialog(context, message);
    }
  }
}

signUpWithEmail(BuildContext context, String email, String password) async {
  dialogIndicator(context);
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (context.mounted) {
      await storeData();
      if (context.mounted) {
        context.go('/auth/email_verification');
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }
    String message = '';
    if (e.code == 'weak-password') {
      message = '안전한 비밀번호를 사용해주세요.';
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else if (e.code == 'email-already-in-use') {
      message = '이미 사용중인 계정입니다. \n  \n 혹은 이메일 인증중인 계정입니다.';
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else if (e.code == 'invalid-email') {
      message = '이메일을 확인해주세요.';
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      message = '이메일주소를 입력해주세요.';
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    if (context.mounted) {
      generalDialog(context, message);
    }
  }
}

inputData(
    BuildContext context,
    String unique,
    String name,
    String ownerName,
    String registration,
    String telephone,
    String region,
    String address,
    GeoPoint geoPoint,
    String category,
    String bank,
    String bankAccount,
    String snsUrl) async {
  dialogIndicator(context);
  try {
    final docRef =
        FirebaseFirestore.instance.collection("restaurantData").doc(unique);
    await docRef.update({
      "name": name,
      "ownerName": ownerName,
      "registration": registration,
      "telephone": telephone,
      "region": region,
      "address": address,
      "geo": geoPoint,
      "category": category,
      "bankDetails": {
        "bank": bank,
        "bankAccount": bankAccount,
      },
      "snsUrl": snsUrl,
    });
    if (context.mounted) {
      context.go('/auth/approval');
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

Future storeData() async {
  final CollectionReference restaurantDataCollection =
      FirebaseFirestore.instance.collection('restaurantData');
  final restaurantData = {
    "unique": FirebaseAuth.instance.currentUser?.uid,
    "email": FirebaseAuth.instance.currentUser?.email,
    "isApproved": false,
    "isOpen": false,
    "name": '',
    "ownerName": '',
    "registration": '',
    "telephone": '',
    "address": '',
    "region": '',
    "category": '',
    "likes": [],
    "bankDetails": {
      "bank": '',
      "bankAccount": '',
    },
    "snsUrl": '',
  };
  await restaurantDataCollection
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set(restaurantData);
}

resetPassword(BuildContext context, String email) async {
  dialogIndicator(context);
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    if (context.mounted) {
      generalDialog(context,
          "입력하신 이메일주소로 \n 초기화 링크가 전송되었습니다. \n  \n 새로운 비밀번호로 \n 다시 로그인해주세요.");
    }
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }
    String message = '';
    if (e.code == 'user-not-found') {
      message = '사용자가 존재하지 않습니다.';
    } else if (e.code == 'invalid-email') {
      message = '이메일을 확인해주세요.';
    } else {
      message = '이메일주소를 입력해주세요.';
    }
    if (context.mounted) {
      generalDialog(context, message);
    }
  }
}
