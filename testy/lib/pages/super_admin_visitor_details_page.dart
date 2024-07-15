import 'package:flutter/material.dart';

class SuperAdminVisitorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> visitorData;

  const SuperAdminVisitorDetailsPage({Key? key, required this.visitorData})
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
          'Visitor Details',
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
                      'Name: ${visitorData['visitor name']}',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Resident Address: ${visitorData['Resident Address']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Car Plate Number: ${visitorData['Car Plate Number']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Phone: ${visitorData['Phone Number']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'IC Number: ${visitorData['IC Number']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Status: ${visitorData['Status']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Time Booked: ${visitorData['Time Booked']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Time Entered: ${visitorData['Time Entered']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Time Exited: ${visitorData['Time Exited']}',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Type: ${visitorData['Type']}',
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
