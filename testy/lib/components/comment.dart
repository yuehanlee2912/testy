import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);
    Color purpleColor = Color.fromARGB(255, 179, 27, 219);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text, style: TextStyle(color: textColor)),

          const SizedBox(height: 5),
          //user + time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: lightBlueColor),
              ),
              Text(
                "•",
                style: TextStyle(color: lightBlueColor),
              ),
              Text(
                time,
                style: TextStyle(color: lightBlueColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
