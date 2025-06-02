import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r2reowner/components/dialogs.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail(context);
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    } else {
      checkAndStoreData();
      redirectToEntryDataInput();
    }
  }

  Future sendVerificationEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      if (context.mounted) {
        generalDialog(context, '링크가 방금 전송되었습니다 \n \n 이메일을 다시 확인해주세요.');
      }
    }
  }

  Future<void> checkEmailVerified() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await currentUser.reload();
        setState(() {
          isEmailVerified = currentUser.emailVerified;
        });
        if (isEmailVerified) {
          timer?.cancel();
          checkAndStoreData();
          redirectToEntryDataInput();
        }
      } catch (e) {
        rethrow;
      }
    } else {
      return;
    }
  }

  Future<void> checkAndStoreData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final docRef = FirebaseFirestore.instance
          .collection("restaurantData")
          .doc(currentUser.uid);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        await storeData();
      }
    } else {
      return;
    }
  }

  Future storeData() async {
    final restaurantData = {
      'unique': FirebaseAuth.instance.currentUser?.uid,
      'email': FirebaseAuth.instance.currentUser?.email,
      'isApproved': false,
      "isOpen": false,
      "name": '',
      "ownerName": '',
      "registration": '',
      "telephone": '',
      "address": '',
      "region": '',
      "category": '',
      "likes": [],
    };
    await FirebaseFirestore.instance
        .collection("restaurantData")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(restaurantData);
  }

  void redirectToEntryDataInput() {
    GoRouter.of(context).go('/auth/entry_data_input');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '이메일을 확인해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  '입력하신 이메일주소: ${FirebaseAuth.instance.currentUser!.email} 로 \n \n 인증링크가 전송되었습니다.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            resendButton(context),
            const SizedBox(height: 16),
            cancelButton(context),
          ],
        ),
      ),
    );
  }

  Padding resendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: canResendEmail ? () => sendVerificationEmail(context) : null,
        icon: const Icon(
          Icons.email,
          size: 24,
          color: Colors.white,
        ),
        label: const Text(
          '재전송하기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      child: const Text(
        '취소',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
