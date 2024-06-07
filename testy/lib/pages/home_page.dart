import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/dashboard_button.dart';
import 'package:testy/components/dashboard_services.dart';
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
    //padding constants
    final double horizontalPadding = 40;
    final double verticalPadding = 25;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[900]),
        title: Text(
          "Bridge",
          style: TextStyle(
            color: Colors.grey[900],
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onBoardTap: goToBoardPage,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Text('Logged in as:'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              currentUser.email!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 200),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardButton(
                  iconImagePath: 'lib/assets/visitor.png',
                  buttonText: 'Book',
                ),
                DashboardButton(
                  iconImagePath: 'lib/assets/history.png',
                  buttonText: 'History',
                ),
                DashboardButton(
                  iconImagePath: 'lib/assets/guard.png',
                  buttonText: 'Guard',
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          //book services

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: Text(
              'Services',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                //food services
                DashboardServices(
                    iconImagePath: 'lib/assets/food.png',
                    tileSubTitle: 'For food deliveries',
                    tileTitle: 'Food Services'),

                //maintainence services
                DashboardServices(
                    iconImagePath: 'lib/assets/maintainence.png',
                    tileSubTitle: 'For maintainence services',
                    tileTitle: 'Maintainence'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
