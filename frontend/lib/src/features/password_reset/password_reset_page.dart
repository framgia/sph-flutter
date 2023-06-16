import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/button/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:get/get.dart';

/*
  Page for the Password Reset
  User inputs email
*/
class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: () {
            formKey.currentState!.save();
          },
          child: AuthHeader(
            title: 'Forgot Password',
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InputField(
                    name: 'email',
                    label: 'Enter Email',
                    validator: FormBuilderValidators.email(),
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 60, right: 25),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Back to Login',
                    style: Theme.of(context)
                        .textTheme
                        .apply(bodyColor: Colors.blue)
                        .labelSmall,
                  ),
                ),
                Button(
                  onClick: () {
                    if (formKey.currentState?.isValid ?? false) {
                      debugPrint(formKey.currentState?.value.toString());
                      Get.back();
                    }
                  },
                  text: 'SEND',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
