import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:paradise_gases/AppState/database.dart';
import 'package:paradise_gases/pages/checkout/checkout.dart';
import 'package:provider/provider.dart';

import '../../../widgets/FullWidthButton.dart';

class Checkoutbutton extends StatefulWidget {
  final int challanId;
  const Checkoutbutton(this.challanId, {super.key});

  @override
  _CheckoutbuttonState createState() => _CheckoutbuttonState();
}

class _CheckoutbuttonState extends State<Checkoutbutton> {
  @override
  void initState() {
    super.initState();
    // Fetch data when widget initializes
    Future.delayed(Duration.zero, () {
      final dbclass = Provider.of<DataBase>(context, listen: false);
      dbclass.challan_Out(widget.challanId.toString());
      dbclass.fetchChallanDetails(widget.challanId.toString());
      dbclass.fetchEmpties(widget.challanId.toString());
      dbclass.getcheckOutDetails(widget.challanId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, dbclass, child) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Challan Checkout'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Are you sure you want to checkout challan # ${widget.challanId}?',
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cylinders',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: Consumer<DataBase>(
                            builder: (context, dbclass, child) {
                              print(dbclass.challanOut.length);
                              // if (dbclass.challanOut.isEmpty) {
                              //   return Center(
                              //       child: Text("No Filled Cylinders found."));
                              // }

                              return (dbclass.challanOut.isEmpty)
                                  ? Center(
                                      child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("No Filled Cylinders found."),
                                        IconButton(
                                            onPressed: () {
                                              dbclass.challan_Out(
                                                  widget.challanId.toString());
                                            },
                                            icon:
                                                Icon(FeatherIcons.refreshCcw)),
                                      ],
                                    ))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dbclass.challanOut.length,
                                      itemBuilder: (context, index) {
                                        final item = dbclass.challanOut[index];

                                        return ListTile(
                                          leading: Text(item['cylinder_size']),
                                          title: Text(
                                              item['item_name'].toString()),
                                          trailing: Text(
                                            item['status'],
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parts',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: dbclass.addedParts.isEmpty
                              ? Center(child: Text("No Parts added."))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dbclass.addedParts.length,
                                  itemBuilder: (context, index) {
                                    final addedParts =
                                        dbclass.addedParts[index];
                                    return ListTile(
                                      leading: Text('${index + 1}'),
                                      title: Text(
                                          addedParts['item_name'].toString()),
                                      trailing: Text('new'),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    FullWidthButton(
                      text: 'Out',
                      onPressed: () {
                        dbclass.checkOutAddedItems(
                            context, widget.challanId, dbclass.id.toString());
                        dbclass.getcheckOutDetails(widget.challanId.toString());

                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckOut(challanId: widget.challanId),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 9.0),
                    FullWidthButton(
                      color: Theme.of(context).dividerColor,
                      text: 'Close',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(FeatherIcons.printer),
          color: Colors.white,
        );
      },
    );
  }
}
