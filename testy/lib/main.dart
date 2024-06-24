import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testy/components/Admin.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/register_page.dart';
import 'package:testy/firebase_options.dart';
import 'package:testy/pages/login_page.dart';
import 'package:testy/pages/home_page.dart';
import 'package:testy/pages/super_admin_page.dart'; // Assuming you have a HomePage for logged-in users

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(); // Show splash screen while checking auth status
        } else if (snapshot.hasData) {
          // User is logged in
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen(); // Show splash screen while fetching user data
              } else if (snapshot.hasData && snapshot.data!.exists) {
                // User data exists
                final userRole = snapshot.data!['role'];
                if (userRole == 'Admin') {
                  return SuperAdminPage(); // Navigate to Admin Page
                } else if (userRole == 'Guard') {
                  return AdminPage(); // Navigate to Guard Page
                } else {
                  return HomePage(); // Navigate to User Page
                }
              } else {
                return LoginPage(); // If no user data, navigate to login
              }
            },
          );
        } else {
          return LoginPage(); // User is not logged in
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Or any loading indicator
      ),
    );
  }
}
