import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:testy/components/button.dart';
import 'package:testy/components/text_field.dart';
import 'package:testy/pages/super_admin_page.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  Color accentColor = Color.fromARGB(255, 5, 25, 86);
  Color bgColor = Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);

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
        var name = clientSnapshot['email'].toString().toLowerCase();
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

  int _getRoleIndex(String role) {
    switch (role) {
      case 'Admin':
        return 1;
      case 'Guard':
        return 2;
      case 'Resident':
      default:
        return 0;
    }
  }

  void _changeRole(String userId, String currentRole) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String selectedRole = currentRole;
        int initialIndex = _getRoleIndex(currentRole);

        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedRole = ['Resident', 'Admin', 'Guard'][index];
                    });
                  },
                  children: const [
                    Text('Resident'),
                    Text('Admin'),
                    Text('Guard'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .update({'role': selectedRole});
                  Navigator.pop(context);
                },
                child: Text('Update Role'),
              ),
            ],
          ),
        );
      },
    );
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
          var visitorData = _resultList[index].data();
          var userId = _resultList[index].id;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
              color: accentColor,
            ),
            child: ListTile(
              title: Text(
                visitorData['name'],
                style: TextStyle(color: textColor),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Residence: " + visitorData['address'],
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "Email: " + visitorData['email'],
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {
                        _changeRole(userId, visitorData['role']);
                      },
                      child: Text('Change Role',
                          style: TextStyle(color: accentColor)),
                      style: TextButton.styleFrom(
                          backgroundColor: lightBlueColor)),
                ],
              ),
              trailing: Text(
                visitorData['phone'],
                style: TextStyle(color: textColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
