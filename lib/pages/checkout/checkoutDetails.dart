import 'package:flutter/material.dart';
import 'package:paradise_gases/AppState/database.dart';
import 'package:provider/provider.dart';

import '../widgets/loadingWidgets/simpleListLoading.dart';

class Checkoutdetails extends StatefulWidget {
  final int challanId;
  const Checkoutdetails({super.key, required this.challanId});

  @override
  _CheckoutdetailsState createState() => _CheckoutdetailsState();
}

class _CheckoutdetailsState extends State<Checkoutdetails> {
  @override
  void initState() {
    super.initState();
    // Delay API call to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataBase>().getcheckOutDetails(widget.challanId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, provider, child) {
        if (provider.isLoadingcheckOutDetails) {
          return const Center(child: SimpleListLoading());
        }

        if (provider.checkOutDetails.isEmpty) {
          return const Center(
            child: ListTile(title: Text("No Checkout Details added yet.")),
          );
        }

        final checkoutData = provider.checkOutDetails;

        return Container(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            children: [
              // Display checkout details
              ...checkoutData.map((item) {
                // Debugging prints - Only print once per item
                print("Checkout Data: $checkoutData");
                print("Item: $item");
                print(
                    "Details: ${item["details"]} - Type: ${item["details"].runtimeType}");

                // Ensure `detailsList` is a list
                List<dynamic> detailsList =
                    (item["details"] is List) ? item["details"] : [];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Challan ID: ${item["challan_id"]}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ...detailsList.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${detail["item_name"]} (${detail["cylinder_size"]}, ${detail["purity"]})",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${detailsList.length} Cylinders",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
