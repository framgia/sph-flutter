import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/*
  Input Component for a search field.
  Similar to InputField, but this component adds the icon and the hint text.


  @param name: similar to html name attribute, provides the form widget the key to assign its value
  ex InputField(name: "last_name") , then printing the formKey values provides { last_name: "abc" }

  @param validator: adds validation to the Text Field, it also provides the widget an error message
  as we are using another package for validators, please read https://pub.dev/packages/form_builder_validators
  ex FormBuilderValidators.email()

  @param yPadding: adds padding to the TextField using EdgeInsets.symmetric(vertical: yPadding)

  @param onChnaged: called when the field value is changed.
*/

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.name,
    this.validator,
    this.yPadding = 0,
    this.onChanged,
  });

  final String name;
  final String? Function(String?)? validator;
  final double yPadding;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: FormBuilderTextField(
        name: name,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: yPadding),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,
          hintText: "Search ...",
        ),
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
