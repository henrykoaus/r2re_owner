import 'package:flutter/material.dart';
import 'package:r2reowner/screens/auth_screen/components/text_form_field_model.dart';

class TextFormFieldRow extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final bool inputFormatters;

  const TextFormFieldRow(
      {super.key,
      required this.title,
      required this.controller,
      required this.keyboardType,
      required this.obscureText,
      required this.hintText,
      required this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(
                "$title",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: TextFormFieldModel(
              controller: controller,
              obscureText: obscureText,
              hintText: hintText,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            ),
          )
        ],
      ),
    );
  }
}
