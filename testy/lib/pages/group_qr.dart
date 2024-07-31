import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testy/components/button.dart';
import 'package:testy/pages/home_page.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

class GroupQr extends StatefulWidget {
  const GroupQr({super.key});

  @override
  State<GroupQr> createState() => _GroupQrState();
}

class _GroupQrState extends State<GroupQr> {
  int selectedVisitorCount = 1;
  TimeOfDay selectedStartTime = TimeOfDay(hour: 19, minute: 30);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 21, minute: 30);
  String uniqueId = '';
  bool showQrCode = false;

  void generateUniqueId() {
    final uuid = Uuid();
    uniqueId = uuid.v4();
  }

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
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  void bookNow() async {
    generateUniqueId();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final String userUid =
        auth.currentUser!.uid; // shouldnt give error if user is logged in

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentReference userDoc = usersCollection.doc(userUid);

    userDoc.get().then((DocumentSnapshot value) async {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance
            .collection("Event Visitors")
            .doc(uniqueId)
            .set({
          'Start Time': formatTimeOfDay(selectedStartTime),
          'End Time': formatTimeOfDay(selectedEndTime),
          'Amount of Visitors': selectedVisitorCount,
          "Resident Address": data['address'],
          'Time Booked': timeBooked(),
          'Resident UUID': currentUser(),
          'Type': "Event Visitor",
          'QR Id': uniqueId,
        }).then((_) {
          setState(() {
            showQrCode = true;
          });
        }).catchError((error) {
          print("Failed to book event: $error");
        });
      }
    }).catchError((e) {
      print("Failed to get user data: $e");
    });
  }

  Color accentColor = Color.fromARGB(255, 5, 25, 86);
  Color bgColor = Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                'Please insert your \nevent details:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Amount of visitors',
                                style: TextStyle(color: textColor),
                              ),
                              SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  backgroundColor: bgColor,
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedVisitorCount = index + 1;
                                    });
                                  },
                                  children:
                                      List<Widget>.generate(30, (int index) {
                                    return Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Start Time',
                                style: TextStyle(color: textColor),
                              ),
                              SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  backgroundColor: bgColor,
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedStartTime = TimeOfDay(
                                          hour: index ~/ 2,
                                          minute: (index % 2) * 30);
                                    });
                                  },
                                  children:
                                      List<Widget>.generate(48, (int index) {
                                    return Center(
                                      child: Text(
                                        '${TimeOfDay(hour: index ~/ 2, minute: (index % 2) * 30).format(context)}',
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'End Time',
                                style: TextStyle(color: textColor),
                              ),
                              SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  backgroundColor: bgColor,
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedEndTime = TimeOfDay(
                                          hour: index ~/ 2,
                                          minute: (index % 2) * 30);
                                    });
                                  },
                                  children:
                                      List<Widget>.generate(48, (int index) {
                                    return Center(
                                      child: Text(
                                        '${TimeOfDay(hour: index ~/ 2, minute: (index % 2) * 30).format(context)}',
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyButton(
                    onTap: bookNow,
                    text: 'Book Now',
                  ),
                  const SizedBox(height: 100),
                  if (showQrCode && uniqueId.isNotEmpty) ...[
                    Text('Event QR',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 15),
                    Center(
                      child: QrImageView(
                        data: uniqueId,
                        size: 280,
                        backgroundColor: Colors.white,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(100, 100),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
