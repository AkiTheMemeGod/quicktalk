import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktalk/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_txtfeild.dart';

class Registerpage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  final TextEditingController _confirmpwcontroller = TextEditingController();

  final void Function()? onTap;

  void register(BuildContext context) async {
    final authService = AuthService();
    if (_confirmpwcontroller.text == _pwcontroller.text) {
      try {
        await authService.signupwithemailandpassword(
            "${_emailcontroller.text}@gmail.com", _pwcontroller.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Passwords don't match!"),
              ));
    }
  }

  Registerpage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "lib/logo/logo.png",
                  scale: 7,
                ),
                Text(
                  "QuickTalk",
                  style: GoogleFonts.breeSerif(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 33),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Get Started",
                  style: GoogleFonts.breeSerif(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 45,
                ),
                MyTxtfeild(
                  hint: "Username",
                  obscuretxt: false,
                  controller: _emailcontroller,
                ),
                const SizedBox(
                  height: 18,
                ),
                MyTxtfeild(
                  hint: "Password",
                  obscuretxt: true,
                  controller: _pwcontroller,
                ),
                const SizedBox(
                  height: 18,
                ),
                MyTxtfeild(
                  hint: "Confirm Password",
                  obscuretxt: true,
                  controller: _confirmpwcontroller,
                ),
                const SizedBox(
                  height: 35,
                ),
                MyButton(
                  name: "Register",
                  onTap: () => register(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?   ",
                      style: GoogleFonts.breeSerif(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Login Now!",
                        style: GoogleFonts.breeSerif(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50, // Added space to avoid overflow
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
