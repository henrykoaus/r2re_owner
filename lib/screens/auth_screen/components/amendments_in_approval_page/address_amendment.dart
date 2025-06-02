import 'package:flutter/material.dart';
import 'package:r2reowner/screens/auth_screen/components/amendments_in_approval_page/address_amendment_page.dart';

class AddressAmendment extends StatelessWidget {
  final String title;
  final String subTitle;

  const AddressAmendment({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddressAmendmentPage(),
              ),
            );
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.pink,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$title: ',
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                  text: subTitle,
                  style: const TextStyle(
                    color: Colors.purple,
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
