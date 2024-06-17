import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);
    return Container(
      decoration: BoxDecoration(
          color: accentColor, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 20,
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: lightBlueColor,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: lightBlueColor,
                ),
              )
            ],
          ),

          //text
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
