import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testy/pages/guard_page.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
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
        var name = clientSnapshot['Car Plate Number'].toString().toLowerCase();
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

  void checkOutVisitor(String docId) async {
    String formattedTimeExited =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now().toLocal());

    // Start a transaction to ensure atomicity of the checkout process and carpark slot update
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference visitorRef =
          FirebaseFirestore.instance.collection('Visitors').doc(docId);
      DocumentReference carparkRef =
          FirebaseFirestore.instance.collection('Carpark').doc('slots');

      DocumentSnapshot visitorSnapshot = await transaction.get(visitorRef);
      DocumentSnapshot carparkSnapshot = await transaction.get(carparkRef);

      if (!visitorSnapshot.exists) {
        throw Exception("Visitor document does not exist!");
      }

      if (!carparkSnapshot.exists) {
        throw Exception("Carpark slots document does not exist!");
      }

      int takenSlots = carparkSnapshot.get('takenSlots');

      // Update visitor status and time exited
      transaction.update(
          visitorRef, {'Status': 'Exited', 'Time Exited': formattedTimeExited});

      // Decrement the carpark slot count
      if (takenSlots > 0) {
        transaction.update(carparkRef, {'takenSlots': takenSlots - 1});
      } else {
        throw Exception("No carpark slots to release!");
      }
    }).then((_) {
      print("Checkout successful and carpark slot updated.");
      getClientStream(); // Refresh the list after checkout
    }).catchError((error) {
      print("Failed to checkout visitor: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to checkout visitor. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  void _showConfirmDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Check Out"),
          content: Text("Are you sure you want to check out this visitor?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                checkOutVisitor(docId); // Proceed with checkout
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = const Color.fromARGB(255, 5, 25, 86);
    Color bgColor = const Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);
    Color purpleColor = const Color.fromARGB(255, 179, 27, 219);
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
          var visitor = _resultList[index];
          return Container(
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
                SizedBox(height: 5),
                Text(
                  "Visiting: " + visitor['Resident Address'],
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 5),
                Text(
                  "Number Plate: " + visitor['Car Plate Number'],
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 5),
                if (visitor['Status'] == 'Entered')
                  ElevatedButton(
                    onPressed: () => _showConfirmDialog(context, visitor.id),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlueColor),
                    child: Text(
                      'Check Out',
                      style: TextStyle(color: textColor),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
