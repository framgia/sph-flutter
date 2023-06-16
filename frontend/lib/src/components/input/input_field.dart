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

  PARAMETER label: add label to the Text Field, 
  ex InputField(label: "Enter Email")

  PARAMETER inputType: to add a inputType in the field like email field, text field, password field and ect., 
  ex InputField(inputType: TextInputType.emailAddress)

  PARAMETER controller: By using a controller, you can perform various tasks such as: 
  Retrieving input data, Setting initial values, Modifying input content, Clearing input
   ex final TextEditingController emailController = TextEditingController();
   InputField(inputType: controller: emailController,)

   PARAMETER obscureText: boolean type to hide the text, usualy used in password field
  ex InputField(obscureText: true)
*/
class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.name,
    required this.label,
    required this.inputType,
    required this.controller,
    this.validator,
    this.obscureText,
  });

  final String name;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final bool? obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 109, 120, 129),
                  blurRadius: 2,
                  spreadRadius: 0.1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: FormBuilderTextField(
              name: name,
              validator: validator,
              controller: controller,
              keyboardType: inputType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              obscureText: obscureText ?? false,
            ),
          ),
        ],
      ),
    );
  }
}
