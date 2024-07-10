import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/dashboard_button.dart';
import 'package:testy/components/dashboard_services.dart';
import 'package:testy/components/drawer.dart';
import 'package:testy/pages/book_food_services.dart';
import 'package:testy/pages/book_maintainence.dart';
import 'package:testy/pages/group_qr.dart';
import 'package:testy/pages/login_page.dart';
import 'package:testy/pages/profile_page.dart';
import 'package:testy/pages/message_board.dart';
import 'package:testy/pages/book_visitor.dart';
import 'package:testy/pages/visitor_history.dart';

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
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  //go to profile
  void goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void goToBoardPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageBoard(),
      ),
    );
  }

  void foodServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookFoodServices(),
      ),
    );
  }

  void maintainenceServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookMaintainence(),
      ),
    );
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 58, 76, 178),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                onPressed: goToProfilePage,
                icon: const Icon(
                  Icons.person,
                  size: 30,
                )),
          )
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onBoardTap: goToBoardPage,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/009/362/398/original/blue-dynamic-shape-abstract-background-suitable-for-web-and-mobile-app-backgrounds-eps-10-vector.jpg'),
                fit: BoxFit.cover)),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 25.0, right: 24.0),
                    child: Row(
                      children: [
                        Text(
                          'What\'s up, ' + userData['name'] + "!",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Residence",
                              style: TextStyle(
                                  fontSize: 15, color: lightBlueColor),
                            ),
                            const SizedBox(height: 10),
                            Text(userData['address'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 15),
                    child: Text("Dashboard",
                        style: TextStyle(
                            color: accentColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: accentColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DashboardButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookVisitor(),
                                  ),
                                );
                              },
                              iconImagePath: 'lib/assets/visitor.png',
                              buttonText: 'Book',
                            ),
                            DashboardButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VisitorHistory()));
                              },
                              iconImagePath: 'lib/assets/history.png',
                              buttonText: 'History',
                            ),
                            DashboardButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const GroupQr()));
                              },
                              iconImagePath: 'lib/assets/group.png',
                              buttonText: 'Group',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, bottom: 15, top: 30),
                    child: Text(
                      'Services',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: accentColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        //food services
                        GestureDetector(
                          onTap: foodServices,
                          child: DashboardServices(
                              iconImagePath: 'lib/assets/food.png',
                              tileSubTitle: 'For food deliveries',
                              tileTitle: 'Food Services'),
                        ),

                        //maintainence services
                        GestureDetector(
                          onTap: maintainenceServices,
                          child: DashboardServices(
                              iconImagePath: 'lib/assets/maintainence.png',
                              tileSubTitle: 'For maintainence services',
                              tileTitle: 'Maintainence'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
