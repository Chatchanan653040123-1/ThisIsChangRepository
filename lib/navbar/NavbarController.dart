import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app01/navbar/Searching.dart';
// import 'package:app01/navbar/Searching2.dart';

class NavbarController extends StatefulWidget {
  const NavbarController({super.key});

  @override
  State<NavbarController> createState() => _NavbarControllerState();
}

class _NavbarControllerState extends State<NavbarController> {
  @override
  Widget build(BuildContext context) {
    return Searching();
  }
}
