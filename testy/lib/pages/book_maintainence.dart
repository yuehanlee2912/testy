import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:testy/components/button.dart';
import 'package:testy/components/text_field.dart';

class BookMaintainence extends StatefulWidget {
  const BookMaintainence({super.key});

  @override
  State<BookMaintainence> createState() => _BookMaintainenceState();
}

class _BookMaintainenceState extends State<BookMaintainence> {
  final numberPlateTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final contactTextController = TextEditingController();
  final ValueNotifier<bool> isFormValid = ValueNotifier(false);

  String uniqueId = '';
  bool showQrCode = false;

  @override
  void initState() {
    super.initState();
    numberPlateTextController.addListener(validateForm);
    nameTextController.addListener(validateForm);
    contactTextController.addListener(validateForm);
  }

  @override
  void dispose() {
    numberPlateTextController.removeListener(validateForm);
    nameTextController.removeListener(validateForm);
    contactTextController.removeListener(validateForm);
    numberPlateTextController.dispose();
    nameTextController.dispose();
    contactTextController.dispose();
    isFormValid.dispose();
    super.dispose();
  }

  void validateForm() {
    isFormValid.value = numberPlateTextController.text.isNotEmpty &&
        nameTextController.text.isNotEmpty &&
        contactTextController.text.isNotEmpty;
  }

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

  void showIncompleteFormDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields before booking.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void bookNow() async {
    if (!isFormValid.value) {
      showIncompleteFormDialog();
      return;
    }

    generateUniqueId();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final String userUid = auth.currentUser!.uid;

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentReference userDoc = usersCollection.doc(userUid);

    print(userDoc.get().then((value) => print(value.data())));

    userDoc.get().then((DocumentSnapshot value) async {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance
            .collection("Visitors")
            .doc(uniqueId)
            .set({
          'visitor name': nameTextController.text,
          'Car Plate Number': numberPlateTextController.text,
          'Phone Number': contactTextController.text,
          "Resident Address": data['address'],
          'Time Booked': timeBooked(),
          'Resident UUID': currentUser(),
          'Type': "Maintainence",
          'QR Id': uniqueId,
          'Status': 'Booked',
          'Time Entered': 'N/A',
          'Time Exited': 'N/A',
        });

        nameTextController.clear();
        numberPlateTextController.clear();
        contactTextController.clear();

        setState(() {
          showQrCode = true;
        });
      }
    }).catchError((e) {});
  }

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
                'Please insert your \nvisitor\'s details:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  MyTextField(
                    controller: nameTextController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: numberPlateTextController,
                    hintText: 'Number Plate',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: contactTextController,
                    hintText: 'Contact: ',
                    obscureText: false,
                  ),
                  const SizedBox(height: 40),
                  ValueListenableBuilder<bool>(
                    valueListenable: isFormValid,
                    builder: (context, isValid, child) {
                      return MyButton(
                        onTap: bookNow,
                        text: 'Book Now',
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                  if (showQrCode && uniqueId.isNotEmpty) ...[
                    Text('Visitor QR',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(
                      height: 15,
                    ),
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
                    const SizedBox(height: 100),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
