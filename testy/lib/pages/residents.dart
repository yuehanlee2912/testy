import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/guard_page.dart';
import 'package:testy/pages/resident_detail_page.dart';

class Residents extends StatefulWidget {
  const Residents({super.key});

  @override
  State<Residents> createState() => _ResidentsState();
}

class _ResidentsState extends State<Residents> {
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

    print("Data Retrieved: ${data.docs.length}");
    for (var doc in data.docs) {
      print(doc.data());
    }

    var filteredData =
        data.docs.where((doc) => doc['role'] == 'Resident').toList();

    setState(() {
      _allResults = filteredData;
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
      body: _resultList.isEmpty
          ? Center(
              child: Text(
                'No results found',
                style: TextStyle(color: textColor),
              ),
            )
          : ListView.builder(
              itemCount: _resultList.length,
              itemBuilder: (context, index) {
                var userData = _resultList[index].data();

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ResidentDetailPage(userData: userData),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: accentColor, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                      color: accentColor,
                    ),
                    child: ListTile(
                      title: Text(
                        userData['name'],
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Residence: " + userData['address'],
                            style: TextStyle(color: textColor),
                          ),
                          Text(
                            "\nEmail: " + userData['email'],
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      trailing: Text(
                        userData['phone'],
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
