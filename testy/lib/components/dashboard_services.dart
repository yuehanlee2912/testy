import 'package:flutter/material.dart';

class DashboardServices extends StatelessWidget {
  final String iconImagePath;
  final String tileSubTitle;
  final String tileTitle;

  const DashboardServices({
    super.key,
    required this.iconImagePath,
    required this.tileSubTitle,
    required this.tileTitle,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //icon and text
            Row(
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(iconImagePath),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      tileTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: lightBlueColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      tileSubTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
