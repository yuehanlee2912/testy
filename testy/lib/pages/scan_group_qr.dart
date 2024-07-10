import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/qr_select.dart';

class ScanGroupQr extends StatefulWidget {
  const ScanGroupQr({super.key});

  @override
  State<ScanGroupQr> createState() => _ScanGroupQrState();
}

class _ScanGroupQrState extends State<ScanGroupQr> {
  Color accentColor = const Color.fromARGB(255, 5, 25, 86);
  Color bgColor = const Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);
  Color purpleColor = const Color.fromARGB(255, 179, 27, 219);

  String _scanResult = '';
  bool _isScanning = false; // Flag to track if scanning is in progress
  bool _hasScanned = false; // Flag to prevent multiple scans

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _timeFormat = DateFormat('h:mm a'); // Correct time format

  @override
  void initState() {
    super.initState();
  }

  void _onDetect(BarcodeCapture barcode) async {
    if (_isScanning || _hasScanned)
      return; // If scanning is in progress or has scanned, do nothing

    setState(() {
      _isScanning = true; // Set the scanning flag to true
    });

    final String qrId =
        barcode.barcodes.first.rawValue?.trim() ?? "Failed to scan";
    setState(() {
      _scanResult = qrId;
    });

    try {
      // Fetch the document from Firestore using the scanned QR Id
      DocumentSnapshot doc =
          await _firestore.collection('Visitors').doc(qrId).get();

      if (doc.exists) {
        String type = doc.get('Type');
        String residentAddress = doc.get('Resident Address');
        String startTimeStr = doc.get('Start Time').trim();
        String endTimeStr = doc.get('End Time').trim();
        DateTime startTime = _timeFormat.parse(startTimeStr);
        DateTime endTime = _timeFormat.parse(endTimeStr);

        // Extract time portion from DateTime.now()
        DateTime now = DateTime.now();
        DateTime nowTime = DateTime(0, 1, 1, now.hour, now.minute);

        print("Scanned QR ID: $qrId");
        print(
            "Document found: Start Time: $startTimeStr, End Time: $endTimeStr");

        // Create DateTime objects for start and end time using a common date
        DateTime start = DateTime(0, 1, 1, startTime.hour, startTime.minute);
        DateTime end = DateTime(0, 1, 1, endTime.hour, endTime.minute);

        if (nowTime.isAfter(start) && nowTime.isBefore(end)) {
          _showDialog(
            title: "QR Code Scanned",
            content:
                "Visitor Type: $type\n\nResident Address: $residentAddress",
            route: AdminPage(),
          );
        } else {
          _showDialog(
            title: "Current time not within event time",
            content: "Please check the event time.",
            route: AdminPage(),
          );
        }
      } else {
        _showDialog(
          title: "Error",
          content: "No such visitor found.",
          route: AdminPage(),
        );
      }
    } catch (e) {
      print("Error fetching document: $e");
      _showDialog(
        title: "Error",
        content: "An error occurred while fetching the document.",
        route: AdminPage(),
      );
    } finally {
      setState(() {
        _isScanning = false;
        _hasScanned = true;
      });
    }
  }

  void _showDialog(
      {required String title, required String content, required Widget route}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => route));
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _hasScanned = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => QrSelect())),
        ),
      ),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
