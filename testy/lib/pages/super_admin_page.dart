import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/super_admin_drawer.dart';
import 'package:testy/pages/admin_profile_page.dart';
import 'package:testy/pages/create_admin.dart';
import 'package:testy/pages/login_page.dart';
import 'package:testy/pages/residents.dart';
import 'package:testy/pages/super_admin_profile_page.dart';
import 'package:testy/pages/admin_view_visitors.dart';
import 'package:testy/pages/super_admin_residents.dart';
import 'package:testy/pages/super_admin_visitors.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
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

    void goToProfile() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminProfilePage()));
    }

    void createAdmin() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CreateAdmin()));
    }

    void manageUsers() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SuperAdminResidents()));
    }

    void viewVisitors() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SuperAdminVisitors()));
    }

    void goToProfilePage() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SuperAdminProfilePage()));
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
      drawer: MySuperAdminDrawer(
        onUsersTap: manageUsers,
        onSignOut: signOut,
        onAdminTap: createAdmin,
        onProfileTap: goToProfile,
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
                                Text("Admin Dashboard",
                                    style: TextStyle(
                                        color: lightBlueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: manageUsers,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading: Icon(Icons.supervised_user_circle,
                                      color: textColor),
                                  title: Text("Search Users",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: createAdmin,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading: Icon(Icons.admin_panel_settings,
                                      color: textColor),
                                  title: Text("Create Admin",
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: viewVisitors,
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
