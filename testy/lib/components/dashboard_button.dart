import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final iconImagePath;
  final String buttonText;

  const DashboardButton(
      {super.key, required this.iconImagePath, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //icon
        Container(
          height: 90,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            //color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              iconImagePath,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        )
      ],
    );
  }
}
