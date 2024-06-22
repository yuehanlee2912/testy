import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/my_list_tile.dart';

class MySuperAdminDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onUsersTap;
  final void Function()? onAdminTap;
  final void Function()? onProfileTap;

  const MySuperAdminDrawer({
    super.key,
    required this.onUsersTap,
    required this.onSignOut,
    required this.onAdminTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

    final currentUser = FirebaseAuth.instance.currentUser!;

    return Drawer(
      backgroundColor: accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 150.0,
                      bottom: 15.0,
                      left: 30), // Adjust padding as needed
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, bottom: 1),
                  child: Text('Currently logged in as:',
                      style: TextStyle(color: lightBlueColor)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentUser.email.toString().split('@')[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                MyListTile(
                  icon: Icons.home,
                  text: "D A S H B O A R D",
                  onTap: () => Navigator.pop(context),
                ),
                MyListTile(
                  icon: Icons.group,
                  text: "U S E R S",
                  onTap: onUsersTap,
                ),
                MyListTile(
                  icon: Icons.admin_panel_settings,
                  text: "C R E A T E  A D M I N",
                  onTap: onAdminTap,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, left: 30),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G  O U T",
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
