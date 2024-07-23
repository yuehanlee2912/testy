import 'package:flutter/material.dart';
import 'package:testy/pages/admin_event_history.dart';
import 'package:testy/pages/super_admin_page.dart';
import 'package:testy/pages/super_admin_visitors.dart';

class AdminSelectHistory extends StatefulWidget {
  const AdminSelectHistory({super.key});

  @override
  State<AdminSelectHistory> createState() => _AdminSelectHistoryState();
}

class _AdminSelectHistoryState extends State<AdminSelectHistory> {
  void goToVisitorHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuperAdminVisitors(),
      ),
    );
  }

  void goToEventHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminEventHistory(),
      ),
    );
  }

  Color accentColor = Color.fromARGB(255, 5, 25, 86);
  Color bgColor = Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SuperAdminPage()),
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 70.0),
              child: Text(
                'Please select visitor type:',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor),
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: goToVisitorHistory,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Visitor History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: goToEventHistory,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Event History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
