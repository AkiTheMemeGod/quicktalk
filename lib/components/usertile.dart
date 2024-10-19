import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quicktalk/themes/theme_provider.dart';

class Usertile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String lastmessage;
  final lasttime;

  Usertile(
      {super.key,
      required this.text,
      required this.onTap,
      required this.lastmessage,
      required this.lasttime});

  @override
  Widget build(BuildContext context) {
    String name = text.length > 10 ? text.substring(0, text.length - 10) : text;
    DateTime dateTime = lasttime.toDate();
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    String time = DateFormat("hh:mm a").format(dateTime);
    String date = DateFormat("EEEE d/M").format(dateTime);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              size: 30,
            ),
            const SizedBox(
              width: 25,
            ),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name[0].toUpperCase() + name.substring(1),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.averageSans(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          lastmessage,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[500]
                                  : Colors.blueGrey),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "  $time",
                            style: GoogleFonts.averageSans(
                                fontWeight: FontWeight.w400, fontSize: 11),
                            //overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "  $date",
                            style: GoogleFonts.averageSans(
                                fontWeight: FontWeight.w400, fontSize: 11),
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ])
              ],
            )),
          ],
        ),
      ),
    );
  }
}
