import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/home/homeWidgets/verticalhomeslide.dart';

class Challan extends StatelessWidget {
  const Challan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          SingleChildScrollView(child: Column(children: [Verticalhomeslide()])),
    );
  }
}
