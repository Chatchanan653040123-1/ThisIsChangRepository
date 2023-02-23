import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app01/pages/Utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignUp;

  const SignUpWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future signUp() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;

      // showDialog(barrierDismissible: false,
      //   context: context,
      //   builder: (context) => const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (error) {
        print(error);

        Utils.showSnackBar(error.message);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "\n Nakun I Na hee",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter min. 6 characters'
                  : null,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 11, 73, 13)),
              onPressed: signUp,
              icon: const Icon(Icons.arrow_forward),
              label: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    // ignore: unnecessary_cast
                    ..onTap = widget.onClickedSignUp as GestureTapCallback?,
                  style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                        text: 'Login ',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.background))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
