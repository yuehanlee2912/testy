import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/admin_page.dart';

class ViewVisitors extends StatefulWidget {
  const ViewVisitors({super.key});

  @override
  State<ViewVisitors> createState() => _ViewVisitorsState();
}

class _ViewVisitorsState extends State<ViewVisitors> {
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
        var name = clientSnapshot['name'].toString().toLowerCase();
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
        .collection('Users')
        .orderBy('name')
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
              builder: (context) => AdminPage(),
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
          return ListTile(
            title: Text(
              _resultList[index]['name'],
              style: TextStyle(color: textColor),
            ),
            tileColor: accentColor,
            subtitle: Text(
              _resultList[index]['address'],
              style: TextStyle(color: textColor),
            ),
            trailing: Text(
              _resultList[index]['phone'],
              style: TextStyle(color: textColor),
            ),
          );
        },
      ),
    );
  }
}
