import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/*
  Input Component for a search field.
  Similar to InputField, but this component adds the icon and the hint text.
*/
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.name,
    this.validator,
    this.yPadding = 0,
  });
  final String name;
  final double yPadding;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            spreadRadius: 0.1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FormBuilderTextField(
        name: name,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: yPadding),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,
          hintText: "Search ...",
        ),
      ),
    );
  }
}
