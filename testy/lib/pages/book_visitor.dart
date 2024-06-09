import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void bookNow() async {
    await FirebaseFirestore.instance.collection("Visitors").add({
      'visitor name': nameTextController.text,
      'IC Number': icNumTextController.text,
      'Phone Number': phoneNumTextController.text,
      'Car Plate Number': carPlateTextController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Book A Visitor'),
        backgroundColor: Colors.grey[300],
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
