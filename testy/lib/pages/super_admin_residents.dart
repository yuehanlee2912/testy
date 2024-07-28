import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/super_admin_page.dart';
import 'package:testy/pages/super_admin_resident_details_page.dart';

class SuperAdminResidents extends StatefulWidget {
  const SuperAdminResidents({super.key});

  @override
  State<SuperAdminResidents> createState() => _SuperAdminResidentsState();
}

class _SuperAdminResidentsState extends State<SuperAdminResidents> {
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

  //search bar
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

  //retrieve data
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

  void deleteUser(String docId) async {
    await FirebaseFirestore.instance.collection('Users').doc(docId).delete();
    getClientStream();
  }

  //dialog confirmation
  void showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteUser(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          var residentData = _resultList[index].data();
          var docId = _resultList[index].id;

          return InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: accentColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
                color: accentColor,
              ),
              child: ListTile(
                title: Text(
                  residentData['name'],
                  style: TextStyle(color: textColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\nResidence: " + residentData['address'],
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      "Email: " + residentData['email'],
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      "Phone: " + residentData['phone'] + "\n",
                      style: TextStyle(color: textColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SuperAdminResidentDetailsPage(
                                residentData: residentData, documentId: docId),
                          ),
                        );
                      },
                      child: Text(
                        "More Info",
                        style: TextStyle(
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => showDeleteConfirmationDialog(context, docId),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
