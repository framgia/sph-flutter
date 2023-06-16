import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/features/home_screen.dart';
import 'package:frontend/src/features/password_reset/password_reset_page.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/button/button.dart';
import 'package:frontend/src/components/input/input_field.dart';

/*
  Page for the Log in
  User inputs email and password
*/
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onSubmit() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        !emailController.text.isEmail) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Please make sure to enter valid Email and Password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    Get.to(() => const HomeScreen());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
          child: AuthHeader(
            title: 'Log In',
            child: Column(
              children: [
                InputField(
                  name: 'email',
                  label: 'Email',
                  inputType: TextInputType.emailAddress,
                  obscureText: false,
                  controller: emailController,
                  validator: FormBuilderValidators.email(),
                ),
                const SizedBox(
                  height: 36,
                ),
                InputField(
                  name: 'password',
                  label: 'Password',
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: passwordController,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const PasswordResetPage());
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: const Color.fromARGB(255, 0, 163, 255),
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Button(
                  onClick: onSubmit,
                  text: 'Login',
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
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: const Color.fromARGB(255, 0, 163, 255),
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
