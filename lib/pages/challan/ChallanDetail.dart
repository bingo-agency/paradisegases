import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:paradise_gases/AppState/database.dart';
import 'package:paradise_gases/pages/challan/chalan_widgets/challan_details.dart';
import 'package:paradise_gases/pages/challan/chalan_widgets/cylinder_details.dart';
import 'package:paradise_gases/pages/challan/chalan_widgets/parts_details.dart';
import 'package:paradise_gases/pages/challan/widgets/checkOutButton.dart';
import 'package:paradise_gases/pages/checkout/checkoutDetails.dart';
import 'package:paradise_gases/widgets/FullWidthButton.dart';
import 'package:provider/provider.dart';

class ChallanDetail extends StatefulWidget {
  final int challanId;

  const ChallanDetail(this.challanId, {super.key});

  @override
  _ChallanDetailState createState() => _ChallanDetailState();
}

class _ChallanDetailState extends State<ChallanDetail> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DataBase>(context, listen: false)
    //       .fetchChallanDetails(widget.challanId.toString());
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DataBase>(context, listen: false)
    //       .fetchEmpties(widget.challanId.toString());
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var db = Provider.of<DataBase>(context, listen: false);
      db.fetchChallanDetails(widget.challanId.toString());
      db.fetchEmpties(widget.challanId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DataBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Challan Details"),
        actions: [
          Checkoutbutton(widget.challanId),
          SizedBox(width: 10.0),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challan # ' + widget.challanId.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ChallanDetails(widget.challanId),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Cylinders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Fill Cylinders'),
                          content: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Prevent infinite height issues
                            children: [
                              SizedBox(
                                height: 300, // Fixed height for the ListView
                                width: double.maxFinite, // Full width
                                child: ListView.builder(
                                  itemCount: db.challanItems.length,
                                  itemBuilder: (context, index) {
                                    // Get max quantity allowed for this item
                                    int maxQty =
                                        int.parse(db.challanItems[index].qty);
                                    int filledQty = int.parse(
                                        db.challanItems[index].filledQty);
                                    int remainingQty = maxQty - filledQty;

                                    // Default selected value
                                    int selectedQty =
                                        remainingQty > 0 ? remainingQty : 0;

                                    return StatefulBuilder(
                                      // Needed to update dropdown selection
                                      builder: (context, setState) {
                                        return ListTile(
                                          title: Text(
                                            '${db.challanItems[index].itemName} (${db.challanItems[index].purity})',
                                          ),
                                          subtitle: Text(
                                              'Max Qty: $maxQty, Remaining: $remainingQty'),
                                          trailing: DropdownButton<int>(
                                            value:
                                                selectedQty, // Set initial value correctly
                                            items: List.generate(
                                                    remainingQty + 1,
                                                    (i) =>
                                                        i) // 0 to remainingQty
                                                .map((qty) =>
                                                    DropdownMenuItem<int>(
                                                      value:
                                                          qty, // Ensure correct values
                                                      child:
                                                          Text(qty.toString()),
                                                    ))
                                                .toList(),
                                            onChanged: (newValue) {
                                              if (newValue != null) {
                                                setState(() =>
                                                    selectedQty = newValue);
                                                db.getDcs();
                                                db.fillCylinders(
                                                  widget.challanId.toString(),
                                                  db.challanItems[index]
                                                      .itemName
                                                      .toString(),
                                                  newValue.toString(),
                                                );
                                                print(
                                                    'Selected Qty for ${db.challanItems[index].itemName}: $newValue');
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            FullWidthButton(
                              text: 'Update',
                              onPressed: () {
                                print('Updated Fill details i guess.');
                                db.fetchChallanDetails(
                                    widget.challanId.toString());
                                db.fetchEmpties(widget.challanId.toString());
                                print('Gotten . Updated Fill details i guess.');
                                Navigator.pop(context); // Close the dialog
                              },
                            )
                          ],
                        );
                      },
                    );
                    db.fetchEmpties(widget.challanId.toString());
                    // db.fetchChallanDetails(widget.challanId.toString());
                  },
                  child: Text(
                    'Fill Cylinders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: CylinderDetails(),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Parts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: PartsDetails(challanId: widget.challanId), // Correct
            ),
            const SizedBox(height: 10.0),
            const Text(
              'CheckOut Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Checkoutdetails(challanId: widget.challanId), // Correct
            ),
          ],
        ),
      ),
    );
  }
}
