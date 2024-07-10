import 'package:flutter/material.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/guard_view_visitors.dart';
import 'package:testy/pages/scan_group_qr.dart';
import 'package:testy/pages/scan_qr.dart';

class QrSelect extends StatefulWidget {
  const QrSelect({super.key});

  @override
  State<QrSelect> createState() => _QrSelectState();
}

class _QrSelectState extends State<QrSelect> {
  void goToVisitorScan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanQr(),
      ),
    );
  }

  void goToEventScan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanGroupQr(),
      ),
    );
  }

  Color accentColor = Color.fromARGB(255, 5, 25, 86);
  Color bgColor = Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ViewVisitors()),
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 70.0),
              child: Text(
                'Please select visitor\nQR code type:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor),
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: goToVisitorScan,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Visitor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: goToEventScan,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Event QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QrSelect(),
  ));
}
