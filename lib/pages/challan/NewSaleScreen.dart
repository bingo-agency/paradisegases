import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../AppState/database.dart';
import '../../widgets/FullWidthButton.dart';
import 'ChallanDetail.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  _NewSaleScreenState createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  TextEditingController customerController = TextEditingController();
  TextEditingController remarksController =
      TextEditingController(text: 'Payment has been collected with a new DC.');
  List<Map<String, dynamic>> items = [];
  bool isCustomerSelected = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataBase>().fetchCustomers();
    });
  }

  int? selectedCustomerId;

  void selectCustomer(int id, String name) {
    // Updated to accept ID
    setState(() {
      selectedCustomerId = id;
      customerController.text = name;
      isCustomerSelected = true;
    });
  }

  void addItem(Map<String, dynamic> item) {
    setState(() {
      items.add(item);
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void submitSale() async {
    print('adding ');
    print('customerController.text ' +
        customerController.text.toString() +
        'items ' +
        items.toString());
    if (customerController.text.isEmpty ||
        items.isEmpty ||
        selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a customer and add items.")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final dbclass = context.read<DataBase>();
    final user_id = int.parse(dbclass.id);
    // Call the saveSale method and expect a response
    final response = await dbclass.saveSale(
      userId: user_id,
      customerId: selectedCustomerId!,
      total: 500.0, // Example total price
      items: items,
      remarks: remarksController.text,
    );

    setState(() {
      isLoading = false;
    });

    // Extract sale_id from the response
    if (response != null && response['success'] == true) {
      int saleId = response['sale_id']; // Get sale ID from API response
      var challanId = saleId;

      if (mounted) {
        // dbclass.fetchChallanDetails(saleId.toString());
        dbclass.getDcs();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChallanDetail(challanId),
          ),
        );
      }
    } else {
      // Handle API failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sale could not be completed. Try again.")),
      );
    }
  }

  void openAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddItemDialog(onItemSelected: addItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Sale')),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: customerController,
              decoration: InputDecoration(labelText: 'Select Customer'),
              readOnly: isCustomerSelected,
              onTap: isCustomerSelected
                  ? null
                  : () => showModalBottomSheet(
                        context: context,
                        builder: (context) => CustomerSelection(
                            onSelect: selectCustomer), // Updated function call
                      ),
            ),
            SizedBox(height: 16),
            FullWidthButton(
              onPressed: openAddItemDialog,
              text: 'Add a new Empty',
            ),
            SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.trash,
                            size: 50, color: Colors.grey), // Icon
                        SizedBox(height: 10), // Spacing
                        Center(
                          child: Text(
                            "No items added.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ), // Text below icon
                      ],
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        int position = index + 1;
                        return Column(
                          children: [
                            ListTile(
                              leading: Text(position.toString()),
                              title: Text(
                                  '${items[index]['gasName'] ?? ''} (${items[index]['purity'] ?? ''})'),
                              subtitle: Text(
                                  'Qty: ${items[index]['qty'] ?? ''} - ${items[index]['size'] ?? ''}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                              ),
                            ),
                            if (index < items.length - 1) Divider(),
                          ],
                        );
                      },
                    ),
            ),

            // TextField(
            //   controller: remarksController,
            //   decoration: InputDecoration(labelText: 'Remarks'),
            // ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8), // Padding inside the box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Border color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: TextField(
                controller: remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: InputBorder.none, // Remove default TextField border
                  contentPadding:
                      EdgeInsets.zero, // Ensure text starts properly inside box
                ),
                maxLines: 3, // Allows multi-line input
              ),
            ),

            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : FullWidthButton(
                    text: 'Save & Continue',
                    onPressed: submitSale,
                    color: (selectedCustomerId == null)
                        ? Theme.of(context).dividerColor
                        : Theme.of(context).primaryColor,
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomerSelection extends StatelessWidget {
  final Function(int, String) onSelect; // Updated to pass ID and name
  CustomerSelection({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    var dbclass = context.watch<DataBase>();

    if (dbclass.customers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: dbclass.customers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(dbclass.customers[index]['id']
              .toString()), // Ensure it's a string
          title: Text(dbclass.customers[index]['name']),
          onTap: () {
            onSelect(int.parse(dbclass.customers[index]['id']),
                dbclass.customers[index]['name']); // Pass ID and name
            Navigator.pop(context);
          },
          trailing: Icon(Icons.arrow_right_sharp),
        );
      },
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onItemSelected;

  const AddItemDialog({Key? key, required this.onItemSelected})
      : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  String selectedCylinder = "CCylinder";
  String selectedPurity = "Common";
  String selectedGas = "CO2";
  String selectedSize = "Liquid/CM3";
  TextEditingController quantityController = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Challan',
          style: TextStyle(color: Theme.of(context).primaryColor)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Cylinder Selection
            Divider(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Cylinder",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                RadioListTile(
                  title: const Text("Customer Cylinder"),
                  value: "CCylinder",
                  groupValue: selectedCylinder,
                  onChanged: (value) {
                    setState(() => selectedCylinder = value.toString());
                  },
                ),
                RadioListTile(
                  title: const Text("Paradise Cylinder"),
                  value: "PCylinder",
                  groupValue: selectedCylinder,
                  onChanged: (value) {
                    setState(() => selectedCylinder = value.toString());
                  },
                ),
              ],
            ),

            // Purity Selection
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Purity",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                RadioListTile(
                  title: const Text("Common"),
                  value: "Common",
                  groupValue: selectedPurity,
                  onChanged: (value) {
                    setState(() => selectedPurity = value.toString());
                  },
                ),
                RadioListTile(
                  title: const Text("Hi Purity"),
                  value: "High Purity",
                  groupValue: selectedPurity,
                  onChanged: (value) {
                    setState(() => selectedPurity = value.toString());
                  },
                ),
                RadioListTile(
                  title: const Text("Hi Pressure"),
                  value: "High Pressure",
                  groupValue: selectedPurity,
                  onChanged: (value) {
                    setState(() => selectedPurity = value.toString());
                  },
                ),
              ],
            ),
            Divider(),

            // Gas Name Selection
            DropdownButtonFormField<String>(
              value: selectedGas,
              decoration: const InputDecoration(labelText: "Gas Name"),
              items: [
                "Oxygen",
                "Nitrogen",
                "CO2",
                "DA Gas",
                "Argon Gas",
                "Nitrous Oxide",
                "Fire Extinguisher",
                "Hydrogen Gas",
                "Helium Gas",
                "Amonia Gas",
                "Mixture Gas",
                "P-10 Gas",
                "Other",
                "Methane"
              ]
                  .map((gas) => DropdownMenuItem(value: gas, child: Text(gas)))
                  .toList(),
              onChanged: (value) => setState(() => selectedGas = value!),
            ),

            // Quantity and Size Selection
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSize,
                    decoration: const InputDecoration(labelText: "Size"),
                    items: [
                      "Liquid/CM3",
                      "L/13.6",
                      "L/10.2",
                      "M/6.8",
                      "J/3.4",
                      "F/1.75",
                      "E/0.85",
                      "Other",
                      "XL 45/130 M3",
                      "XL 55/160 M3",
                      "XL 60/175 M3",
                      "XL 65/190 M3",
                      "XL 70/205 M3"
                    ]
                        .map((size) =>
                            DropdownMenuItem(value: size, child: Text(size)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedSize = value!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FullWidthButton(
          text: 'Add Item',
          onPressed: () {
            widget.onItemSelected({
              "gasName": selectedGas, // Corrected key
              "qty": quantityController.text,
              "price": 0,
              "size": selectedSize,
              "purity": selectedPurity,
              "empty": selectedCylinder
            });

            Navigator.pop(context);
          },
        ),
        SizedBox(height: 4.0),
        FullWidthButton(
          color: Theme.of(context).dividerColor,
          text: "Close",
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sale cancelled.")),
            );
          },
        ),
      ],
    );
  }
}
