import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testy/components/button.dart';
import 'package:testy/components/text_field.dart';
import 'package:testy/pages/qr_page.dart';

class BookFoodServices extends StatefulWidget {
  const BookFoodServices({super.key});

  @override
  State<BookFoodServices> createState() => _BookFoodServicesState();
}

class _BookFoodServicesState extends State<BookFoodServices> {
  final numberPlateTextController = TextEditingController();
  final nameTextController = TextEditingController();

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

        await FirebaseFirestore.instance.collection("Food Services").add({
          'driver name': nameTextController.text,
          'number plate': numberPlateTextController.text,
          "Resident Address": data['address'],
          'Time Booked': timeBooked(),
          'Resident UUID': currentUser()
        });

        goToQrPage();

        nameTextController.clear();
        numberPlateTextController.clear();
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
                'Please insert your \ndriver\'s details:',
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
                    hintText: 'Driver Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: numberPlateTextController,
                    hintText: 'Driver Number Plate',
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
