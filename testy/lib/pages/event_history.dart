import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/visitor_select.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});

  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  String currentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    return user.uid;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getClientStream();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapshot in _allResults) {
        var name = clientSnapshot['Time Booked'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    String userUUID = currentUser();
    var data = await FirebaseFirestore.instance
        .collection('Event Visitors')
        .where('Resident UUID', isEqualTo: userUUID)
        .get();

    setState(() {
      _allResults = data.docs;
      _resultList = List.from(_allResults);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
            MaterialPageRoute(builder: (context) => VisitorSelect()),
          ),
        ),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      backgroundColor: bgColor,
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          var visitorData = _resultList[index].data() as Map<String, dynamic>;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
              color: accentColor,
            ),
            child: ListTile(
              title: Text(
                "Event Time Booked: " +
                    visitorData['Time Booked'].toString() +
                    "\n", // Convert to string
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount of visitors: " +
                        visitorData['Amount of Visitors'].toString(),
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "Start Time: " + visitorData['Start Time'],
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "End Time: " + visitorData['End Time'],
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
