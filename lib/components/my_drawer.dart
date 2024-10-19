import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/pages/settingspage.dart';
import 'package:quicktalk/pages/updates.dart';

class MyDrawer extends StatelessWidget {
  void logout() {
    final _authservice = AuthService();

    _authservice.signout();
  }

  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Image.asset(
                "lib/logo/logo.png",
              )),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "HOME",
                    style: GoogleFonts.ptSansCaption(),
                  ),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("SETTINGS", style: GoogleFonts.ptSansCaption()),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settingspage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("UPDATES", style: GoogleFonts.ptSansCaption()),
                  leading: const Icon(Icons.update),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatesPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text("LOGOUT", style: GoogleFonts.ptSansCaption()),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
