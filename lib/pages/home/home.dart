import 'package:flutter/material.dart';
import 'package:paradise_gases/pages/challan/Challan.dart';
import 'package:paradise_gases/pages/home/homeWidgets/horizontalHomeSlide.dart';
import 'package:paradise_gases/pages/home/homeWidgets/verticalhomeslide.dart';
import 'package:paradise_gases/pages/widgets/sideDrawer.dart';
import 'package:provider/provider.dart';
import '../../AppState/database.dart';
import '../widgets/bottomAppBar.dart';
import '../widgets/customFabButton.dart';
import '../widgets/customizedAppBar.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  Home({super.key});
  // double indicator = 10.0;
  // bool onTop = true;

  @override
  Widget build(BuildContext context) {
    var dbclass = context.read<DataBase>();
    dbclass.getName();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child:
            CustomizedAppBar(scaffoldKey: _scaffoldKey), // Pass the scaffoldKey
      ),
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome Back,',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<DataBase>(
                builder: (context, dbclass, child) {
                  return Text(dbclass.name);
                },
              ),
            ),
            Horizontalhomeslide(),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DC',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Challan()),
                      );
                    },
                    child: Text(
                      'View All Challans',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Verticalhomeslide(),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text('Older Challans'),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text('Pending Challans'),
            // ),
          ],
        ),
      ),
      floatingActionButton: CustomFabButton(
          scrollController: scrollController), // Pass the controller
      bottomNavigationBar: CustomBottomAppBar(
        scrollController,
        currentIndex: 0,
      ),
    );
  }
}
