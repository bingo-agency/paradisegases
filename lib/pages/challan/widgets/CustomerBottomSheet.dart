import 'package:flutter/material.dart';
import 'package:paradise_gases/AppState/database.dart';
import 'package:provider/provider.dart';

Future<Map<String, dynamic>?> showCustomerBottomSheet(
    BuildContext context) async {
  final dbclass = Provider.of<DataBase>(context, listen: false);
  await dbclass.fetchCustomers(); // Ensure data is fetched

  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return Consumer<DataBase>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.customers.isEmpty) {
            return const Center(child: Text("No customers found"));
          }

          return ListView.builder(
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              final customer = provider.customers[index];
              return ListTile(
                title: Text(customer['name'] ?? 'Unknown Name'),
                subtitle: Text(customer['phone'] ?? 'No Phone'),
                onTap: () {
                  Navigator.pop(context, customer); // Return selected customer
                },
              );
            },
          );
        },
      );
    },
  );
}
