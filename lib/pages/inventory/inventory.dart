import 'package:flutter/material.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: Center(
        child: Text('Current Inventory'),
      ),
    );
  }
}
