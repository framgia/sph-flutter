import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:frontend/src/helper/truncate.dart';

/*
  Reusable logout dropdown component.

  @param defaultValue, the default value of the dropdown.

  @param selectedValue, the selected value.

  @param onChanged, called when the user selects an item.
*/

class LogoutDropdown extends StatelessWidget {
  const LogoutDropdown({
    super.key,
    required this.name,
    required this.value,
    this.onChanged,
  });

  final String name;
  final String value;
  final void Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: Text(
          truncate(
            value: name,
            maxWidth: MediaQuery.of(context).size.width * 0.35,
          ),
        ),
        onChanged: onChanged,
        items: [
          DropdownMenuItem(
            value: value,
            alignment: Alignment.center,
            child: const Text(
              'Log out',
            ),
          ),
        ],
        style: Theme.of(context).textTheme.titleSmall,
        iconStyleData: const IconStyleData(iconSize: 0),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.all(0),
        ),
        dropdownStyleData: const DropdownStyleData(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
