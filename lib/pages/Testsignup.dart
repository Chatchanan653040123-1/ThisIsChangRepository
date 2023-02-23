import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:app01/pages/forgotPass.dart';
import 'package:app01/pages/Utils.dart';
import 'package:app01/backend/config.dart';

class Testsignup extends StatefulWidget {
  final Function onClickedSignUp;

  const Testsignup({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<Testsignup> createState() => _TestsignupState();
}

class _TestsignupState extends State<Testsignup> {
  bool passwordVisible = true;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirm = TextEditingController();
  List<String> domainKey = Config.domainKey;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool checkPasswordStrength(String password) {
    if (!Config.isPasswordStength) return true;

    bool hasUppercase = Config.hasUppercase;
    bool hasLowercase = Config.hasLowercase;
    bool hasNumber = Config.hasNumber;
    bool hasSpecialCharacter = Config.hasSpecialCharacter;

    if (password.length < 8) {
      return false;
    }

    for (int i = 0; i < password.length; i++) {
      String character = password[i];
      if (character.contains(new RegExp(r'[A-Z]'))) {
        hasUppercase = false;
      } else if (character.contains(new RegExp(r'[a-z]'))) {
        hasLowercase = false;
      } else if (character.contains(new RegExp(r'[0-9]'))) {
        hasNumber = false;
      } else if (character.contains(new RegExp(r'[^A-Za-z0-9]'))) {
        hasSpecialCharacter = false;
      }
    }

    return !(hasUppercase || hasLowercase || hasNumber || hasSpecialCharacter);
  }

  @override
  Widget build(BuildContext context) {
    Future signUp() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid || !checkPasswordStrength(passwordController.text)) return;
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (error) {
        print(error);
        Utils.showSnackBar(error.message);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo_app.png", scale: 15),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Welcome to register page  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Email input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) {
                            if (email != null &&
                                !EmailValidator.validate(email)) {
                              return 'Enter a valid email ';
                            }
                            if (!domainKey
                                .contains(email.toString().split('.').last)) {
                              return 'Email must contain .com, .ac.th, .co.th, or .net';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Color(0xFF00337C)),
                            icon: Icon(Icons.person),
                            iconColor: Color(0xFF00337C),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Password input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          obscureText: passwordVisible,
                          controller: passwordController,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null &&
                                value.length < Config.lengthOfPassword) {
                              return 'Enter min. ${Config.lengthOfPassword} characters';
                            }
                            if (!checkPasswordStrength(
                                passwordController.text)) {
                              return 'Password must have one upper char,on down char,one number and specific char';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: (Icon(Icons.lock)),
                            border: InputBorder.none,
                            iconColor: Color(0xFF00337C),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Color(0xFF00337C)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Confirm Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            obscureText: passwordVisible,
                            controller: passwordConfirm,
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value != null &&
                                  value != passwordController.text) {
                                return 'Not Match';
                              }
                              if (value!.length < Config.lengthOfPassword) {
                                return 'Enter min. ${Config.lengthOfPassword} characters';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              icon: (Icon(Icons.lock)),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Color(0xFF00337C)),
                              iconColor: Color(0xFF00337C),
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Sign up Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        if (passwordConfirm.text == passwordController.text &&
                            Config.isSignup) {
                          signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00337C),
                        fixedSize: Size.fromWidth(double.maxFinite),
                      ),
                      child: const Text(
                        "Sign Up",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Have a account ?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                widget.onClickedSignUp as GestureTapCallback?,
                          style: const TextStyle(
                              // color: Color(0xFF00337C), fontWeight: FontWeight.bold),
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                          text: ' Login',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
