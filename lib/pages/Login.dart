import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app01/pages/forgotPass.dart';
import 'package:app01/pages/Utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app01/backend/config.dart';

class LoginWidget extends StatefulWidget {
  final Function onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  Color blue_navy = Color(0xFF00337C);
  bool passwordVisible = true;
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
    Future signIn() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid || !Config.isLogin) return;

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (error) {
        print("Error is ${error.toString()}");

        Utils.showSnackBar(error.message);
      }
    }

    Future signInWithGoogle() async {
      if (!Config.isLoginWithGoogle) return;
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
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
                  "Hello!",
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
                  "Welcome to our project \"Park KKU\"  ",
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email '
                                : null,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        obscureText: passwordVisible,
                        controller: passwordController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null &&
                                value.length < Config.lengthOfPassword
                            ? 'Enter min. ${Config.lengthOfPassword} characters'
                            : null,
                        decoration: InputDecoration(
                          // ignore: prefer_const_constructors
                          errorStyle: TextStyle(
                            fontSize: 12,
                          ),
                          icon: Icon(Icons.lock),
                          border: InputBorder.none,
                          iconColor: blue_navy,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: blue_navy),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: blue_navy,
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Sign In button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue_navy,
                      fixedSize: Size.fromWidth(double.maxFinite),
                    ),
                    child: const Text("Sign In"),
                  ),
                ),

                // const SizedBox(
                //   height: 10,
                // ),

                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: const Center(
                    child: Text(
                      "Or",
                      style: TextStyle(
                          color: Color(0xFF00337C),
                          // fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset(
                        "assets/images/google_logo.webp",
                        scale: 100,
                      ),
                      label: Text("Sign In with Google",
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size.fromWidth(double.maxFinite),
                      ),
                    )

                    // child: const Text("Sign In with Google"),
                    ),

                const SizedBox(
                  height: 10,
                ),
                //Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Need an account ?',
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
                            color: Colors.red, fontWeight: FontWeight.bold),
                        text: ' Register now',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //For reset password
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                GestureDetector(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.background),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
