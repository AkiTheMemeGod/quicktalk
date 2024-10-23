// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/my_button.dart';
import 'package:quicktalk/components/my_txtfeild.dart';

class Loginpage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  final void Function()? onTap;

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signinwithemailpassword(
          "${_emailcontroller.text}@gmail.com", _pwcontroller.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(e.toString()),
              ));
    }
  }

  Loginpage({super.key, required this.onTap});

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
                  height: 30,
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
                  "Welcome back",
                  style: GoogleFonts.breeSerif(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 80,
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
                  height: 30,
                ),
                MyButton(
                  name: "Login",
                  onTap: () => login(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?   ",
                      style: GoogleFonts.breeSerif(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Register Now!",
                        style: GoogleFonts.breeSerif(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Or SignIn with Google",
                  style: GoogleFonts.breeSerif(),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: AuthService().sigupwithGoogle,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    padding: EdgeInsets.all(8),
                    height: 80,
                    width: 80,
                    child: Image.asset('lib/logo/google.png'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
