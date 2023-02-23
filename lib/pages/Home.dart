import 'package:flutter/material.dart';
import 'package:app01/navbar/NavbarController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavbarController(),
    );
  }
}