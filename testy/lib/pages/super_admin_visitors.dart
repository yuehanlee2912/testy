import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/super_admin_page.dart';
import 'package:testy/pages/super_admin_visitor_details_page.dart';

class SuperAdminVisitors extends StatefulWidget {
  const SuperAdminVisitors({super.key});

  @override
  State<SuperAdminVisitors> createState() => _SuperAdminVisitorsState();
}

class _SuperAdminVisitorsState extends State<SuperAdminVisitors> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

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
    var data = await FirebaseFirestore.instance
        .collection('Visitors')
        .orderBy('visitor name')
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
              builder: (context) => SuperAdminPage(),
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
          var visitor = _resultList[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SuperAdminVisitorDetailsPage(visitorData: visitor.data()),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: accentColor,
                border: Border.all(color: accentColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitor['visitor name'],
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Time Booked: " + visitor['Time Booked'],
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    "Visiting: " + visitor['Resident Address'],
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
