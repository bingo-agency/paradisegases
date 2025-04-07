import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/widgets/loadingWidgets/verticalListLoading.dart';
import 'package:provider/provider.dart';

import '../../../AppState/database.dart';
import '../../../models/item_model.dart';

class ChallanDetails extends StatefulWidget {
  final int challanId;

  const ChallanDetails(this.challanId, {super.key});

  @override
  _ChallanDetailsState createState() => _ChallanDetailsState();
}

class _ChallanDetailsState extends State<ChallanDetails> {
  List<String> partsList = ["None"];
  String selectedPart = "None";

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: VerticalListLoading());
        }

        if (provider.challanItems.isEmpty) {
          return const Center(child: Text("No items found"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.challanItems.length,
          itemBuilder: (context, index) {
            final item = provider.challanItems[index];

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://paradisegases.com/images/nitrogenCylinder.png',
                        width: 70,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.itemName} (${item.purity})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.customerName,
                            style: TextStyle(color: Colors.grey.shade700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Size: ${item.cylinderSize}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Qty: ${item.qty}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                "Filled: ${item.filledQty}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => showAddPartsDialog(context,
                          int.parse(item.id), item.customerId, item.saleId),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // More height
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        backgroundColor: item.status == "Filled"
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        foregroundColor: item.status == "Filled"
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                      child:
                          const Text('+Part', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchPartsForCustomer(String customerId) async {
    var db = Provider.of<DataBase>(context, listen: false);
    List<ItemModel> fetchedItems = await db.fetchInventoryItems(customerId);

    if (mounted) {
      setState(() {
        partsList = fetchedItems.isNotEmpty
            ? ["None", ...fetchedItems.map((item) => item.itemName).toList()]
            : ["None"];
        selectedPart = partsList.first;
      });
    }
  }

  void showAddPartsDialog(BuildContext context, int cylinderId,
      String customerId, String challanId) async {
    await fetchPartsForCustomer(customerId);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var db = Provider.of<DataBase>(context, listen: false);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Part"),
              content: DropdownButtonFormField<String>(
                value: selectedPart,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: "Choose a part", border: OutlineInputBorder()),
                items: partsList
                    .map((part) =>
                        DropdownMenuItem(value: part, child: Text(part)))
                    .toList(),
                onChanged: (value) => setState(() => selectedPart = value!),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedPart.isNotEmpty) {
                      context.read<DataBase>().addPartToSale(
                          context, challanId, selectedPart, db.id);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Add Part"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
