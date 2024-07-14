import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:testy/components/button.dart';
import 'package:testy/components/text_field.dart';

class BookVisitor extends StatefulWidget {
  const BookVisitor({super.key});

  @override
  State<BookVisitor> createState() => _BookVisitorState();
}

class _BookVisitorState extends State<BookVisitor> {
  final nameTextController = TextEditingController();
  final icNumTextController = TextEditingController();
  final phoneNumTextController = TextEditingController();
  final carPlateTextController = TextEditingController();
  final ValueNotifier<bool> isFormValid = ValueNotifier(false);

  String uniqueId = '';
  bool showQrCode = false;

  @override
  void initState() {
    super.initState();
    nameTextController.addListener(validateForm);
    icNumTextController.addListener(validateForm);
    phoneNumTextController.addListener(validateForm);
    carPlateTextController.addListener(validateForm);
  }

  @override
  void dispose() {
    nameTextController.removeListener(validateForm);
    icNumTextController.removeListener(validateForm);
    phoneNumTextController.removeListener(validateForm);
    carPlateTextController.removeListener(validateForm);
    nameTextController.dispose();
    icNumTextController.dispose();
    phoneNumTextController.dispose();
    carPlateTextController.dispose();
    isFormValid.dispose();
    super.dispose();
  }

  void validateForm() {
    isFormValid.value = nameTextController.text.isNotEmpty &&
        icNumTextController.text.isNotEmpty &&
        phoneNumTextController.text.isNotEmpty &&
        carPlateTextController.text.isNotEmpty;
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
          'IC Number': icNumTextController.text,
          'Phone Number': phoneNumTextController.text,
          'Car Plate Number': carPlateTextController.text,
          "Resident Address": data['address'],
          'Time Booked': timeBooked(),
          'Resident UUID': currentUser(),
          'Type': "Visitor",
          'QR Id': uniqueId,
          'Status': 'Booked',
          'Time Entered': 'N/A',
          'Time Exited': 'N/A',
        });

        nameTextController.clear();
        icNumTextController.clear();
        phoneNumTextController.clear();
        carPlateTextController.clear();

        setState(() {
          showQrCode = true;
        });
      }
    }).catchError((e) {});
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
                    hintText: 'Visitor Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: icNumTextController,
                    hintText: 'Visitor IC No.',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: phoneNumTextController,
                    hintText: 'Visitor Phone No.',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: carPlateTextController,
                    hintText: 'Visitor Car Plate No.',
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
