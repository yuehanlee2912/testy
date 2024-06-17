import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final iconImagePath;
  final String buttonText;
  final void Function()? onTap;

  const DashboardButton(
      {super.key,
      required this.iconImagePath,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          //icon
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: accentColor,
            ),
            child: Center(
              child: Image.asset(
                iconImagePath,
                color: textColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
