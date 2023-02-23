import 'package:flutter/material.dart';
import 'package:app01/pages/Login.dart';
import 'package:app01/pages/Testsignup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(
          onClickedSignUp: toggle,
        )
      : Testsignup(
          onClickedSignUp: toggle,
        );

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
