import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: () {
            formKey.currentState!.save();
          },
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Forgot Password',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: InputField(
                        name: 'email',
                        label: 'Enter Email',
                        validator: FormBuilderValidators.email(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Back to Login',
                        style: Theme.of(context)
                            .textTheme
                            .apply(bodyColor: Colors.blue)
                            .labelSmall,
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 44,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.blue,
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue,
                          ),
                          foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState?.isValid ?? false) {
                            debugPrint(formKey.currentState?.value.toString());
                            Get.back();
                          }
                        },
                        child: Text(
                          'SEND',
                          style: Theme.of(context)
                              .textTheme
                              .apply(bodyColor: Colors.white)
                              .labelMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
