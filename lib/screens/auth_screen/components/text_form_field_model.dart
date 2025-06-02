import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldModel extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final bool inputFormatters;

  const TextFormFieldModel({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.keyboardType,
    required this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Colors.grey,
      obscureText: obscureText,
      decoration: textInputDecor(hintText),
      autocorrect: false,
      textInputAction: TextInputAction.go,
      inputFormatters: (inputFormatters == true)
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9. -]'),
              ),
            ]
          : [],
    );
  }

  InputDecoration textInputDecor(String hint) {
    return InputDecoration(
        isDense: true,
        prefixText: '   ',
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100]);
  }
}
