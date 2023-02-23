import 'package:flutter/material.dart';
class Searching2 extends StatefulWidget {
  const Searching2({super.key});

  @override
  State<Searching2> createState() => _Searching2State();
}

class _Searching2State extends State<Searching2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                // child: Row(children: [TextFormField(h)]),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
