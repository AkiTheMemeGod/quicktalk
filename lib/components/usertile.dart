import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  Usertile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(25),
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
                child: Text(
              text.length > 10 ? text.substring(0, text.length - 10) : text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w400),
            )),
          ],
        ),
      ),
    );
  }
}
