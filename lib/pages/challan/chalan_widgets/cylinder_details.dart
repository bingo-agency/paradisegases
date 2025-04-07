import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../AppState/database.dart';
import '../../../models/item_model.dart';
import '../../widgets/loadingWidgets/verticalListLoading.dart';

class CylinderDetails extends StatefulWidget {
  @override
  _CylinderDetailsState createState() => new _CylinderDetailsState();
}

class _CylinderDetailsState extends State<CylinderDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, provider, child) {
        if (provider.isLoadingCylinderUpdate) {
          return const Center(child: VerticalListLoading());
        }

        if (provider.empties.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No Empty Cylinders found"),
          ));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.empties.length,
          itemBuilder: (context, index) {
            final cylinder = provider.empties[index];

            return ListTile(
              title: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    cylinder['gas'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '(' + cylinder['cylinder_size'] + ')',
                  style: TextStyle(fontSize: 14.0),
                )
              ]),
              subtitle: Text(
                cylinder['status'],
                style: TextStyle(
                  color: (cylinder['status'] == 'Empty')
                      ? Colors.blue
                      : (cylinder['status'] == 'Damaged')
                          ? Colors.red
                          : Colors.green,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  showCylinderDetailsSnackbar(context, cylinder, provider.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  void showCylinderDetailsSnackbar(
      BuildContext context, var cylinder, String id) {
    String selectedStatus = cylinder['status']; // Default status

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Close Button (×)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cylinder Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Table Headers
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(4)
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Gas',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Size',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Status',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Cylinder Data Row
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cylinder['gas']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cylinder['cylinder_size']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                            ),
                            items: ['Filled', 'Empty', 'Damaged']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedStatus = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Save & Close Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Save status to provider BEFORE closing the modal
                          await context.read<DataBase>().updateCylinderStatus(
                              cylinder['id'],
                              selectedStatus,
                              id,
                              cylinder['challan_id'],
                              context);
                          Navigator.of(context).pop(); // Now safe to close

                          await context
                              .read<DataBase>()
                              .fetchEmpties(cylinder['challan_id']);

                          if (mounted) {
                            print('mount6ed');
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
