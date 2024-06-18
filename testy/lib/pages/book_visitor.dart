import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testy/components/button.dart';
import 'package:testy/components/text_field.dart';
import 'package:testy/pages/qr_page.dart';

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

  String currentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    return user.uid;
  }

  void goToQrPage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QrPage(),
      ),
    );
  }

  String timeBooked() {
    final Timestamp timeStamp = Timestamp.now();
    final DateTime dateTime = timeStamp.toDate().toLocal();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  void bookNow() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String userUid =
        auth.currentUser!.uid; // shouldnt give error if user is logged in

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentReference userDoc = usersCollection.doc(userUid);

    print(userDoc.get().then((value) => print(value.data())));

    userDoc.get().then((DocumentSnapshot value) async {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance.collection("Visitors").add({
          'visitor name': nameTextController.text,
          'IC Number': icNumTextController.text,
          'Phone Number': phoneNumTextController.text,
          'Car Plate Number': carPlateTextController.text,
          "Resident Address": data['address'],
          'Time Booked': timeBooked(),
          'Resident UUID': currentUser()
        });

        goToQrPage();

        nameTextController.clear();
        icNumTextController.clear();
        phoneNumTextController.clear();
        carPlateTextController.clear();
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
                  MyButton(
                    onTap: bookNow,
                    text: 'Book Now',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
