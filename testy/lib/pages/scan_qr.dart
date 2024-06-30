import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testy/pages/guard_page.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  Color accentColor = const Color.fromARGB(255, 5, 25, 86);
  Color bgColor = const Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);
  Color purpleColor = const Color.fromARGB(255, 179, 27, 219);

  String _scanResult = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Optionally, you can start scanning immediately here
  }

  void _onDetect(BarcodeCapture barcode) async {
    final String qrId = barcode.barcodes.first.rawValue ?? "Failed to scan";
    setState(() {
      _scanResult = qrId;
    });

    try {
      // Fetch the document from Firestore using the scanned QR Id
      DocumentSnapshot doc =
          await _firestore.collection('Visitors').doc(qrId).get();

      if (doc.exists) {
        // Get the resident address and status
        String residentAddress = doc.get('Resident Address');
        String status = doc.get('Status');

        // Check if the status is anything but "Booked"
        if (status != 'Booked') {
          // Show dialog with the error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Visitor has already entered!"),
                content: const Text("Please get a new QR."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AdminPage()));
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Update the "Time Entered" field
          await _firestore.collection('Visitors').doc(qrId).update({
            'Time Entered': FieldValue.serverTimestamp(),
            'Status': 'Entered'
          });

          // Show dialog with the resident address
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("QR Code Scanned"),
                content: Text("Resident Address: $residentAddress"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AdminPage()));
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle the case where the document does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("No such visitor found."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AdminPage()));
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error fetching document: $e");
      // Handle the error, e.g., show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("An error occurred while fetching the document."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AdminPage()));
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
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
              MaterialPageRoute(builder: (context) => AdminPage())),
        ),
      ),
      body: MobileScanner(
        onDetect: _onDetect,
        // Optionally, you can specify which camera to use here
        // cameraFacing: CameraFacing.front, // or CameraFacing.back
      ),
    );
  }
}
