import 'package:flutter/material.dart';
import 'package:testy/pages/admin_page.dart';

class ViewResidentInformation extends StatefulWidget {
  const ViewResidentInformation({super.key});

  @override
  State<ViewResidentInformation> createState() =>
      _ViewResidentInformationState();
}

class _ViewResidentInformationState extends State<ViewResidentInformation> {
  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminPage())),
        ),
      ),
    );
  }
}
