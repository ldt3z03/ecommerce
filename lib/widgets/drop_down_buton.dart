import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

String? selectedValue;

class DropDownBtn extends StatelessWidget {
  final List<String> items;
  final String selectedItemText;
  final Function(String?) onSelected;

  const DropDownBtn({
    super.key,
    required this.items,
    required this.selectedItemText,
    required this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center( // Thêm widget Center để căn giữa
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              selectedItemText,
              style: const TextStyle(
                fontSize: 14, // Giảm kích thước font để đồng nhất
                color: Colors.black54, // Màu text hint giống với TextField
              ),
            ),
            items: items.map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
            value: selectedValue,
            onChanged: (String? value) {
              onSelected(value);
            },
            buttonStyleData: ButtonStyleData(

              padding: const EdgeInsets.symmetric(horizontal: 16),

            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,

            ),
          ),
        ),
      ),
    );
  }
}
