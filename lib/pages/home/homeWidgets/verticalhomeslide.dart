import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/challan/ChallanDetail.dart';
import 'package:paradise_gases/pages/widgets/loadingWidgets/verticalListLoading.dart';
import 'package:provider/provider.dart';

import '../../../AppState/database.dart';

class Verticalhomeslide extends StatefulWidget {
  const Verticalhomeslide({super.key});

  @override
  State<Verticalhomeslide> createState() => _VerticalhomeslideState();
}

class _VerticalhomeslideState extends State<Verticalhomeslide> {
  @override
  void initState() {
    super.initState();
    // Fetch requests when the widget initializes
    Future.microtask(() {
      final dataBaseProvider = Provider.of<DataBase>(context, listen: false);
      if (dataBaseProvider.requests.isEmpty) {
        dataBaseProvider.getDcs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: VerticalListLoading());
        }

        if (provider.requests.isEmpty) {
          return const Center(
            child: Text("No requests found"),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context)
              .size
              .height, // You can adjust this height as needed
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: provider.requests.length,
            itemBuilder: (context, index) {
              final request = provider.requests[index];

              return Card(
                color: Theme.of(context).colorScheme.surface,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Text('# ${request.id}'),
                  title: Text(request.customer_name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.item_description),
                      Text('Total: ${request.total_cylinders} Cylinders'),
                      Text('Date: ${request.timestamp}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Define what happens when an item is tapped
                    // _showRequestDialog(context, request);
                    int challanId = int.parse(request.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChallanDetail(challanId)),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Function to show dialog
