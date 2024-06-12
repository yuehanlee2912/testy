import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String currentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    return user.uid;
  }

  String timeBooked() {
    final Timestamp timeStamp = Timestamp.now();
    final DateTime dateTime = timeStamp.toDate().toLocal();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  String currentUserAndTimeBooked() {
    String uid = currentUser();
    String bookingTime = timeBooked();
    return 'User ID: $uid, Time Booked: $bookingTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Book A Visitor"),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 65.0),
        child: Column(
          children: [
            const SizedBox(height: 175),
            QrImageView(
              data: currentUserAndTimeBooked(),
              size: 280,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(100, 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
