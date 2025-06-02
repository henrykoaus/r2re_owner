import 'package:flutter/material.dart';
import 'package:r2reowner/components/expandable_boxes/opening_hours_expandable_box.dart';
import 'package:r2reowner/components/expandable_boxes/rep_menu_expandable_box.dart';
import 'package:r2reowner/components/expandable_boxes/intro_expandable_box.dart';
import 'package:r2reowner/components/rep_image_editor.dart';
import 'package:r2reowner/components/toggle_switch.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/address_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/bank_account_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/category_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/owners_name_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/region_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/registration_number_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/restaurants_name_tile.dart';
import 'package:r2reowner/screens/feed_screen/components/list_tiles/telephone_tile.dart';

class RestaurantInfoPage extends StatelessWidget {
  const RestaurantInfoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: const [
          SizedBox(
            height: 20,
          ),
          ToggleSwitch(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '초기오픈 후 항시 ON상태를 권장합니다.',
                style: TextStyle(fontSize: 12, color: Colors.pink),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          RepImageEditor(),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RestaurantsNameTile(),
              CategoryTile(),
              RegionTile(),
              AddressTile(),
              TelephoneTile(),
              OwnersNameTile(),
              RegistrationNumberTile(),
              BankAccountTile(),
              IntroExpandableBox(),
              RepMenuExpandableBox(),
              OpeningHoursExpandableBox(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
