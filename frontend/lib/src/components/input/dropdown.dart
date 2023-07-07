import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend/src/components/label.dart';

/*
  Reusable dropdown component.

  @param labelText, the label which describes the field.

  @param items, list of items to be displayed in dropdown menu.

  @param selectedValue, current selected value.

  @param onChanged, called when the user selects an item.
*/
class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.selectedValue,
    this.onChanged,
  });

  final String labelText;
  final List<dynamic> items;
  final String selectedValue;
  final void Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(text: labelText),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 2,
                spreadRadius: 0.1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField2(
            value: selectedValue,
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFf6D7881)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(right: 15),
              height: 50,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                FontAwesomeIcons.caretDown,
                color: Colors.black,
              ),
              iconSize: 25,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFf6D7881)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
