import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/qr_select.dart';

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
  bool _isScanning = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void _onDetect(BarcodeCapture barcode) async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    final String qrId = barcode.barcodes.first.rawValue ?? "Failed to scan";
    setState(() {
      _scanResult = qrId;
    });

    try {
      DocumentSnapshot doc =
          await _firestore.collection('Visitors').doc(qrId).get();

      if (doc.exists) {
        String residentAddress = doc.get('Resident Address');
        String status = doc.get('Status');

        if (status != 'Booked') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Visitor has already entered!"),
                content: const Text("Please get a new QR."),
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
          ).then((_) {
            setState(() {
              _isScanning = false;
            });
          });
        } else {
          String formattedTimeEntered =
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now().toLocal());

          await _firestore.collection('Visitors').doc(qrId).update(
              {'Time Entered': formattedTimeEntered, 'Status': 'Entered'});

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("QR Code Scanned"),
                content: Text("Resident Address: $residentAddress"),
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
          ).then((_) {
            setState(() {
              _isScanning = false;
            });
          });
        }
      } else {
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
        ).then((_) {
          setState(() {
            _isScanning = false;
          });
        });
      }
    } catch (e) {
      print("Error fetching document: $e");
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
      ).then((_) {
        setState(() {
          _isScanning = false;
        });
      });
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
              MaterialPageRoute(builder: (context) => QrSelect())),
        ),
      ),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
