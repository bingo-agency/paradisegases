import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AppState/database.dart';
import '../auth/login.dart';
import '../home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn =
        await Provider.of<DataBase>(context, listen: false).checkAuth();
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => Home()), // Home screen if logged in
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const Login()), // Login screen if not logged in
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: Image(
          image: AssetImage("assets/images/preloader.gif"),
        ),
      ),
    );
  }
}
