import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


/*
  Component for a FormBuilderTextField
  designed with shadow, border

  PARAMETER name: similar to html name attribute, provides the form widget the key to assign its value
  ex InputField(name: "last_name") , then printing the formKey values provides { last_name: "abc" }

  PARAMETER validator: adds validation to the Text Field, it also provides the widget an error message
  as we are using another package for validators, please read https://pub.dev/packages/form_builder_validators
  ex FormBuilderValidators.email() 
*/
class InputField extends StatelessWidget {
  const InputField(
      {super.key, required this.name, this.validator,});

  final String name;
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
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
