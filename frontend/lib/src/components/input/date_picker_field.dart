import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend/src/components/label.dart';

/*
  Component for date picker.

  @param name, specifies the name of the field.

  @param labelText, the label which describes the field.

  @param validator, optional function to add validation for the field.

  @param onChanged, called when the user selects a date.

  @param initialValue, initial value for the date time picker. 

  @param lastDate, the latest choosable date.
*/
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.name,
    required this.labelText,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.lastDate,
  });

  final String name;
  final String labelText;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;
  final DateTime? initialValue;
  final DateTime? lastDate;

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
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF2296F3)),
              datePickerTheme: const DatePickerThemeData(
                headerBackgroundColor: Color(0xFF2296F3),
                headerForegroundColor: Colors.white,
                backgroundColor: Color(0xFFE6F3FD),
              ),
              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(0xFF6D7881)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
              ),
            ),
            child: FormBuilderDateTimePicker(
              name: name,
              validator: validator,
              initialEntryMode: DatePickerEntryMode.calendar,
              initialValue: initialValue,
              lastDate: lastDate,
              inputType: InputType.date,
              onChanged: onChanged,
              decoration: const InputDecoration(
                suffixIcon: Icon(FontAwesomeIcons.calendarDays, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
