import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/checkout/checkoutDetails.dart';

class CheckOut extends StatelessWidget {
  final int challanId;
  const CheckOut({super.key, required this.challanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background
      appBar: AppBar(
        title: Text(
          "Checkout Details",
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Checkoutdetails(challanId: challanId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
