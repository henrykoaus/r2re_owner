import 'package:flutter/material.dart';

class DropDownModel extends StatelessWidget {
  final String title;
  final String dropdownValue;
  final List<String> items;
  final Function(String?) onChanged;

  const DropDownModel(
      {super.key,
      required this.title,
      required this.dropdownValue,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField(
              value: dropdownValue,
              menuMaxHeight: 300,
              decoration: InputDecoration(
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
                  fillColor: Colors.grey[100]),
              dropdownColor: Colors.grey[100],
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: (dropdownValue == '지역 선택' ||
                          dropdownValue == '카테고리 선택' ||
                          dropdownValue == '은행 선택')
                      ? Text(
                          '   $item',
                          style: const TextStyle(color: Colors.black54),
                        )
                      : Text(
                          '   $item',
                          style: const TextStyle(color: Colors.black),
                        ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
