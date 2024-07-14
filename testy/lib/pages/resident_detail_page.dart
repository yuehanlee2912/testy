import 'package:flutter/material.dart';

class ResidentDetailPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ResidentDetailPage({Key? key, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Resident Details',
          style: TextStyle(color: textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 500,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${userData['name']}',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Address: ${userData['address']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${userData['email']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Phone: ${userData['phone']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Role: ${userData['role']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Username: ${userData['username']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
