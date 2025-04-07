import 'package:flutter/material.dart';
import 'package:paradise_gases/AppState/loginProvider.dart';
import 'package:provider/provider.dart';
import 'AppState/database.dart';
import 'AppState/themeNotifier.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataBase>(create: (_) => DataBase()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          print('this will now launch splash !');
          return MaterialApp(
            title: 'Paradise Gases',
            initialRoute: RouteManager.splashPage,
            onGenerateRoute: RouteManager.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.currentTheme,
          );
        },
      ),
    );
  }
}
