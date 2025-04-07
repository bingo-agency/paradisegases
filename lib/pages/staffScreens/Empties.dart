import 'package:flutter/material.dart';

import 'package:paradise_gases/pages/widgets/loadingWidgets/verticalListLoading.dart';
import 'package:provider/provider.dart';

import '../../AppState/database.dart';
import '../challan/ChallanDetail.dart';

class Empties extends StatefulWidget {
  @override
  _EmptiesState createState() => new _EmptiesState();
}

class _EmptiesState extends State<Empties> {
  @override
  void initState() {
    super.initState();
    // Fetch data once when the screen is initialized
    Future.microtask(() => context.read<DataBase>().getAllEmpties());
  }

  @override
  Widget build(BuildContext context) {
    context.read<DataBase>().getAllEmpties();
    return Scaffold(
      appBar: AppBar(title: Text('All Empties')),
      body: Consumer<DataBase>(
        builder: (context, dbclass, child) {
          if (dbclass.isLoadingallEmpties) {
            return Center(child: VerticalListLoading());
          }
          if (dbclass.allEmpties.isEmpty) {
            return Center(child: Text('No empties found'));
          }
          return ListView.builder(
            itemCount: dbclass.allEmpties.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChallanDetail(int.parse(
                            dbclass.allEmpties[index]["challan_id"]))),
                  );
                },
                leading: Text(dbclass.allEmpties[index]["challan_id"]),
                title: Row(
                  children: [
                    Text(dbclass.allEmpties[index]["gas"] + ' - '),
                    Text(dbclass.allEmpties[index]["cylinder_size"]),
                  ],
                ),
                subtitle: Text(dbclass.allEmpties[index]["customer_name"]),
                trailing: Text(dbclass.allEmpties[index]["status"]),
              );
            },
          );
        },
      ),
    );
  }
}
