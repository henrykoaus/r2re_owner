import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DirectingScreen extends StatefulWidget {
  const DirectingScreen({super.key});

  @override
  State<DirectingScreen> createState() => _DirectingScreenState();
}

class _DirectingScreenState extends State<DirectingScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      GoRouter.of(context).go('/auth');
      return;
    }

    if (!currentUser.emailVerified) {
      setState(() {
        isLoading = false;
      });
      GoRouter.of(context).go('/auth/email_verification');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection("restaurantData")
        .doc(currentUser.uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      bool isEntryDataPut = _isEntryDataComplete(data);
      bool isApproved = data['isApproved'] ?? false;

      if (isEntryDataPut == true) {
        if (isApproved == true) {
          if (mounted) {
            GoRouter.of(context).go('/feed/restaurant_info');
          }
        } else {
          if (mounted) {
            GoRouter.of(context).go('/auth/approval');
          }
        }
      } else {
        if (mounted) {
          GoRouter.of(context).go('/auth/entry_data_input');
        }
      }
    } else {
      if (mounted) {
        GoRouter.of(context).go('/auth/entry_data_input');
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isEntryDataComplete(Map<String, dynamic> data) {
    String name = data["name"];
    String ownerName = data["ownerName"];
    String registration = data["registration"];
    String telephone = data["telephone"];
    String address = data["address"];
    String region = data["region"];
    String category = data["category"];
    Map<String, dynamic> bankDetails = data["bankDetails"];
    if (name != '' &&
        ownerName != '' &&
        registration != '' &&
        telephone != '' &&
        address != '' &&
        region != '' &&
        category != '' &&
        bankDetails["bank"] != '' &&
        bankDetails["bankAccount"] != '') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: CircularProgressIndicator())
        : const Scaffold(body: CircularProgressIndicator());
  }
}
