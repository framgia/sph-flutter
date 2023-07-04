import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/features/sign_up/sign_up_flow.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';
import 'package:frontend/src/controllers/sign_up_controller.dart';

/*
  The page where user can fill the first page of sign up.

  @param, userFormData, the current sign up flow data.
*/
class SignUpStepOne extends StatelessWidget {
  const SignUpStepOne({super.key, required this.userFormData});

  final UserFormData userFormData;

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());
    final formKey = GlobalKey<FormBuilderState>();

    void onSubmit() {
      context.flow<UserFormData>().update(
            (data) => data.copyWith(
              page: 2,
              firstName: formKey.currentState!.fields['first_name']!.value,
              middleName: formKey.currentState!.fields['middle_name']!.value,
              lastName: formKey.currentState!.fields['last_name']!.value,
              address: formKey.currentState!.fields['address']!.value,
              birthday: formKey.currentState!.fields['birthday']!.value,
            ),
          );
    }

    return GetX<SignUpController>(
      builder: (_) => Column(
        children: [
          const Breadcrumb(
            text: 'Sign Up',
            withBackIcon: false,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
            child: FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: () {
                formKey.currentState!.save();

                signUpController.setSignUpFirstButtonEnabled =
                    formKey.currentState!.isValid;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: 'First Name',
                    name: 'first_name',
                    initialValue: userFormData.firstName,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Middle Name',
                    name: 'middle_name',
                    initialValue: userFormData.middleName,
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Last Name',
                    name: 'last_name',
                    validator: FormBuilderValidators.required(),
                    initialValue: userFormData.lastName,
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Address',
                    name: 'address',
                    validator: FormBuilderValidators.required(),
                    initialValue: userFormData.address,
                  ),
                  const SizedBox(height: 26),
                  DatePickerField(
                    labelText: 'Birthday',
                    name: 'birthday',
                    validator: FormBuilderValidators.required(),
                    initialValue: userFormData.birthday,
                    lastDate: DateTime.now(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'Next',
                          enabled: signUpController.signUpFirstButtonEnabled,
                          onPressed: onSubmit,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 99,
                            vertical: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
