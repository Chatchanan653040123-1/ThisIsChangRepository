import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app01/pages/Utils.dart';
import 'package:app01/backend/config.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password reset email sent');
    } on FirebaseAuthException catch (error) {
      print(error);

      Utils.showSnackBar(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF00337C),
        title: const Text(
          'Reset Password',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              
            
      
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                Image.asset("assets/images/question_mark.png",scale: 2,),
      
                Text(
                  'Forgot Password ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Send a link to your email to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
      
                //Email to reset password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: emailController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          labelStyle: TextStyle(color: Color(0xFF00337C)),
                          border: InputBorder.none,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(
                  height: 20,
                ),
      
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(double.maxFinite),
                        backgroundColor: Color(0xFF00337C)),
                    onPressed: () {
                      if (Config.isResetPassword) {
                        resetPassword();
                        print("Function enable [TRUE]");
                      } else {
                        print("Function enable [FALSE]");
                      }
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'Send Reset Link',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
