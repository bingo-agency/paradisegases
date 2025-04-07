import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/widgets/loadingWidgets/simpleListLoading.dart';
import 'package:paradise_gases/pages/widgets/loadingWidgets/verticalListLoading.dart';
import 'package:provider/provider.dart';

import '../../../AppState/database.dart';
import '../../../models/item_model.dart';

class PartsDetails extends StatefulWidget {
  final int challanId;

  const PartsDetails({super.key, required this.challanId});

  @override
  _PartsDetailsState createState() => _PartsDetailsState();
}

class _PartsDetailsState extends State<PartsDetails> {
  @override
  void initState() {
    super.initState();
    // Delay API call to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataBase>().getAddedPartsToSale(widget.challanId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(
      builder: (context, provider, child) {
        if (provider.isLoadingAddedParts) {
          return const Center(child: SimpleListLoading());
        }

        if (provider.addedParts.isEmpty) {
          return Center(
            child: ListTile(title: Text("No Parts Added.")),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.addedParts.length,
          itemBuilder: (context, index) {
            final item = provider.addedParts[index];
            return ListTile(
              leading:Text(item["qty"]),
              title: Text(item["item_name"]),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                color: Colors.red,
                onPressed: () {
                  print(item.toString());
                  provider.deleteAddedPart(context, int.parse(item["id"]),
                      item["sale_id"].toString());
                },
              ),
            );
          },
        );
      },
    );
  }
}
