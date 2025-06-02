import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantInfoProvider =
        Provider.of<RestaurantInfoProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 8,
      ),
      child: FutureBuilder<void>(
        future: restaurantInfoProvider.fetchRestaurantInfo(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(
              title: RichText(
                text: const TextSpan(
                  text: '주소: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: '',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListTile(
              title: RichText(
                text: TextSpan(
                  text: '주소: ',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: restaurantInfoProvider.address ?? '',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
