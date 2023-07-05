import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:frontend/src/helper/user_full_name.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/controllers/login_controller.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/features/home_screen.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/features/sign_up/sign_up_flow.dart';
import 'package:frontend/src/features/password_reset/forgot_password_page.dart';
import 'package:frontend/src/helper/dio.dart';

/*
  Page for the Log in
  User inputs email and password
*/
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    final LoginController loginController = Get.put(LoginController());
    const storage = FlutterSecureStorage();

    void onSubmit() async {
      // disable the button to prevent multiple requests being sent
      loginController.setLoginButtonEnabled = false;

      // note: csrf is for web, web implementation not thoroughly tested
      await NetworkConfig().getCsrftoken();
      final client = NetworkConfig().client;
      // delete the current stored login key, otherwise
      // frontend\lib\src\helper\dio.dart adds this to the request headers
      await storage.delete(key: StorageKeys.loginToken.name);
      await storage.delete(key: StorageKeys.userId.name);
      await storage.delete(key: StorageKeys.isAdmin.name);

      final email = formKey.currentState!.fields['email']!.value;
      final password = formKey.currentState!.fields['password']!.value;

      final loginResponse = await client.post(
        loginUrl,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (loginResponse.statusCode == HttpStatus.ok) {
        final User user = User.fromJson(loginResponse.data['data']);

        await storage.write(
          key: StorageKeys.loginToken.name,
          value: user.token,
        );
        await storage.write(key: StorageKeys.userId.name, value: user.id);
        await storage.write(
          key: StorageKeys.fullName.name,
          value: userFullName(user),
        );
        await storage.write(
          key: StorageKeys.isAdmin.name,
          value: user.isAdmin.toString(),
        );
        Get.to(() => const HomeScreen());
      } else if (loginResponse.statusCode == HttpStatus.badRequest) {
        // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
        final error = jsonDecode(loginResponse.data.toString());
        // just use the first validation error (if many)
        final message = error['error']['message']['email'][0];
        formKey.currentState?.fields['email']?.invalidate(message);
      }
    }

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 150),
            child: GetX<LoginController>(
              builder: (_) => FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: () {
                  formKey.currentState!.save();

                  // when email is invalidated on the onSubmit,
                  // revalidate the email field when typing again
                  formKey.currentState?.fields['email']
                      ?.validate(focusOnInvalid: false);

                  // set button enabled state
                  loginController.setLoginButtonEnabled =
                      formKey.currentState!.fields['email']!.isValid &&
                          formKey.currentState!.fields['password']!.isValid;
                },
                child: (loginController.checkingLoginToken)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Text(
                              'Log In',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          InputField(
                            name: 'email',
                            label: 'Email',
                            inputType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          InputField(
                            name: 'password',
                            label: 'Password',
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: FormBuilderValidators.required(),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => const ForgotPasswordPage());
                              },
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: const Color.fromARGB(
                                        255,
                                        0,
                                        163,
                                        255,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Button(
                            onPressed: loginController.loginButtonEnabled
                                ? onSubmit
                                : null,
                            buttonColor: loginController.loginButtonEnabled
                                ? const Color(0xFF00CCFF)
                                : Colors.grey,
                            text: 'Log In',
                            padding: const EdgeInsets.symmetric(
                              horizontal: 99,
                              vertical: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don’t have an account? ',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const SignUpFlow());
                                },
                                child: Text(
                                  'Sign Up',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          163,
                                          255,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
