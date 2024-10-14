import 'package:flutter/material.dart';
import 'package:quicktalk/auth/auth_service.dart';

class Homepage extends StatelessWidget {
  void logout() {
    final _authservice = AuthService();

    _authservice.signout();
  }

  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
        title: Center(
          child: Text(
            "Homepage",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(),
    );
  }
}
