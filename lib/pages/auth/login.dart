import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paradise_gases/pages/home/home.dart';
import 'package:provider/provider.dart';
import '../../AppState/database.dart';
import '../../AppState/loginProvider.dart';
import 'package:whatsapp_otp/whatsapp_otp.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    void sendOTP() {
      String recipientNumber = '+923335714484'; // Phone number to receive OTP
      String otp = '1234'; // OTP to send
    }

    sendOTP();

    var loginProvider = context.read<LoginProvider>();
    Map<String, dynamic> map;
    String message;
    var dbclass = context.read<DataBase>();
    if (dbclass.isLoggedIn == true) {
      MaterialPageRoute(builder: (BuildContext context) => Home());
    }
    MaterialPageRoute(
      builder: (BuildContext context) =>
          (context.read<DataBase>().isLoggedIn == true)
              ? Home()
              : const Login(),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_login.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) =>
                                loginProvider.updateNumber(value),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only allows numbers
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone number 03335714484",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) =>
                                loginProvider.updatePassword(value),
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      var email = loginProvider.number.toString();
                      var password = loginProvider.password.toString();
                      if (email == '' || password == '') {
                        print('empty Number or password');
                        dbclass.loginError = 'Empty Number or Password';
                        dbclass.showErrorSnackbar(
                            context, 'Empty Number or Password');
                      } else {
                        dbclass.loginError = '';
                        await dbclass.login(email, password);
                        await dbclass.checkAuth();
                        if (dbclass.isLoggedIn == true) {
                          dbclass.showSuccessSnackbar(
                              context, 'You have logged in.');
                          dbclass.isLoggedIn = true;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Home(),
                            ),
                          );
                        } else {
                          dbclass.showErrorSnackbar(
                              context, dbclass.loginError);
                        }
                      }

                      print('button was hit.');
                      print('Number: ${loginProvider.number}');
                      print('Password: ${loginProvider.password}');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  const Text("Forgot Password?"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
