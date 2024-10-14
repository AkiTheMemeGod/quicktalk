import 'package:flutter/material.dart';
import 'package:quicktalk/pages/loginpage.dart';
import 'package:quicktalk/pages/registerpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginpage = true;

  void togglepages() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return Loginpage(
        onTap: togglepages,
      );
    } else {
      return Registerpage(onTap: togglepages);
    }
  }
}
