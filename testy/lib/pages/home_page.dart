import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/drawer.dart';
import 'package:testy/pages/profile_page.dart';
import 'package:testy/pages/message_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //go to profile
  void goToProfilePage() {
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void goToBoardPage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageBoard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text(
          "Bridge",
          style: TextStyle(
            color: Colors.grey[300],
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onBoardTap: goToBoardPage,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //logged in as
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    "Welcome Back!\n",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentUser.email!,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
