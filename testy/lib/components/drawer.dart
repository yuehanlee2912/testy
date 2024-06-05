import 'package:flutter/material.dart';
import 'package:testy/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onProfileTap;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              DrawerHeader(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),

              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap,
              ),
            ],
          ),
          MyListTile(
            icon: Icons.logout,
            text: "L O G  O U T",
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
