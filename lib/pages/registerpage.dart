import 'package:flutter/material.dart';
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
            _emailcontroller.text, _pwcontroller.text);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/logo/logo.png",
              scale: 7,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "We will Set you up right away!",
              style: TextStyle(
                  fontFamily: "Monospace",
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 50,
            ),
            MyTxtfeild(
              hint: "Email",
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
