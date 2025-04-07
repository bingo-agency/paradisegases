import 'package:flutter/material.dart';

class SaleSummaryScreen extends StatelessWidget {
  final int saleId;

  const SaleSummaryScreen({Key? key, required this.saleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sale Summary")),
      body: Center(
        child: Text("Sale ID: $saleId"),
      ),
    );
  }
}
