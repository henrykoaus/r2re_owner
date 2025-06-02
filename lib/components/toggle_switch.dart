import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool? isSwitched;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  Future<void> _loadSwitchState() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('restaurantData')
          .doc(currentUser.uid)
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          isSwitched = data?['isOpen'] ?? false;
        });
      } else {
        setState(() {
          isSwitched = false;
        });
      }
    }
  }

  Future<void> _saveSwitchState(bool value) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('restaurantData')
          .doc(currentUser.uid)
          .set({'isOpen': value}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          '알투레 플랫폼에 오픈하시겠습니까?',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(
          width: 10,
        ),
        Switch(
          value: isSwitched ?? false,
          inactiveTrackColor: Colors.grey[300],
          activeTrackColor: Colors.purple,
          onChanged: (value) async {
            setState(() {
              isSwitched = value;
            });
            await _saveSwitchState(value);
          },
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
