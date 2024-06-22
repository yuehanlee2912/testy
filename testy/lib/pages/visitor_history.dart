import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/home_page.dart';

class VisitorHistory extends StatefulWidget {
  const VisitorHistory({super.key});

  @override
  State<VisitorHistory> createState() => _VisitorHistoryState();
}

class _VisitorHistoryState extends State<VisitorHistory> {
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
        var name = clientSnapshot['visitor name'].toString().toLowerCase();
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
        .collection('Visitors')
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

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ),
        ),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          var visitorData = _resultList[index].data();

          return Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
              color: accentColor,
            ),
            child: ListTile(
              title: Text(
                visitorData['visitor name'],
                style: TextStyle(color: textColor),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time Booked: " + visitorData['Time Booked'],
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "\nIC Number: " + visitorData['IC Number'],
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              trailing: Text(
                visitorData['Phone Number'],
                style: TextStyle(color: textColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
