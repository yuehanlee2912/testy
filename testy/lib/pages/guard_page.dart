import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testy/components/admin_drawer.dart';
import 'package:testy/pages/guard_message_board.dart';
import 'package:testy/pages/guard_profile_page.dart';
import 'package:testy/pages/carpark_page.dart';
import 'package:testy/pages/login_page.dart';
import 'package:testy/pages/residents.dart';
import 'package:testy/pages/guard_view_visitors.dart';
import 'package:testy/pages/scan_qr.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

    void signOut() {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }

    void goToResidents() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Residents()));
    }

    void goToVisitors() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ViewVisitors()));
    }

    void goToCarpark() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CarparkPage()));
    }

    void goToScanQr() {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => ScanQr()));
    }

    void goToCommunityBoard() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GuardMessageBoard()));
    }

    void goToProfilePage() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminProfilePage()));
    }

    //user
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
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
      drawer: MyAdminDrawer(
        onResidentTap: goToResidents,
        onSignOut: signOut,
        onVisitorTap: goToVisitors,
        oncarparkTap: goToCarpark,
        onBoardTap: goToCommunityBoard,
        onQrTap: goToScanQr,
      ),
      body: StreamBuilder<DocumentSnapshot>(
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
                    left: 25.0,
                    top: 25,
                  ),
                  child: Text(
                    "Hello, " + userData["name"],
                    style: TextStyle(
                        fontSize: 35,
                        color: textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  child: Expanded(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      color: accentColor,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Guard Dashboard",
                                    style: TextStyle(
                                        color: lightBlueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: goToScanQr,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading:
                                      Icon(Icons.qr_code, color: textColor),
                                  title: Text("Scan QR",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: goToVisitors,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading: Icon(Icons.group, color: textColor),
                                  title: Text("View Visitors",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: goToResidents,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading: Icon(Icons.house, color: textColor),
                                  title: Text("View Residents",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: goToCarpark,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading:
                                      Icon(Icons.car_crash, color: textColor),
                                  title: Text("View Carpark Availability",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: goToCommunityBoard,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading:
                                      Icon(Icons.message, color: textColor),
                                  title: Text("Community Board",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    );
  }
}
