import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r2reowner/components/list_tiles/opening_hours_list_tile.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';

class OpeningHoursExpandableBox extends StatefulWidget {
  const OpeningHoursExpandableBox({super.key});

  @override
  State<OpeningHoursExpandableBox> createState() =>
      _OpeningHoursExpandableBoxState();
}

class _OpeningHoursExpandableBoxState extends State<OpeningHoursExpandableBox> {
  bool _isExpanded = false;
  final TextEditingController _monEditor = TextEditingController();
  final TextEditingController _tueEditor = TextEditingController();
  final TextEditingController _wedEditor = TextEditingController();
  final TextEditingController _thuEditor = TextEditingController();
  final TextEditingController _friEditor = TextEditingController();
  final TextEditingController _satEditor = TextEditingController();
  final TextEditingController _sunEditor = TextEditingController();
  final TextEditingController _holidaysEditor = TextEditingController();

  @override
  void dispose() {
    _monEditor.dispose();
    _tueEditor.dispose();
    _wedEditor.dispose();
    _thuEditor.dispose();
    _friEditor.dispose();
    _satEditor.dispose();
    _sunEditor.dispose();
    _holidaysEditor.dispose();
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
              '영업시간',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OpeningHoursListTile(
                  title: '월요일',
                  subTitle: restaurantInfoProvider.openingHours?['mon'] ?? '',
                  day: 'mon',
                  textEditingController: _monEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '화요일',
                  subTitle: restaurantInfoProvider.openingHours?['tue'] ?? '',
                  day: 'tue',
                  textEditingController: _tueEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '수요일',
                  subTitle: restaurantInfoProvider.openingHours?['wed'] ?? '',
                  day: 'wed',
                  textEditingController: _wedEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '목요일',
                  subTitle: restaurantInfoProvider.openingHours?['thu'] ?? '',
                  day: 'thu',
                  textEditingController: _thuEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '금요일',
                  subTitle: restaurantInfoProvider.openingHours?['fri'] ?? '',
                  day: 'fri',
                  textEditingController: _friEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '토요일',
                  subTitle: restaurantInfoProvider.openingHours?['sat'] ?? '',
                  day: 'sat',
                  textEditingController: _satEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '일요일',
                  subTitle: restaurantInfoProvider.openingHours?['sun'] ?? '',
                  day: 'sun',
                  textEditingController: _sunEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
                OpeningHoursListTile(
                  title: '휴무일',
                  subTitle:
                      restaurantInfoProvider.openingHours?['holidays'] ?? '',
                  day: 'holidays',
                  textEditingController: _holidaysEditor,
                  fetchFunction: () {
                    return restaurantInfoProvider
                        .fetchRestaurantInfo(currentUser!.uid);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
