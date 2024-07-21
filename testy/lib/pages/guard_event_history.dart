import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testy/pages/guard_visitor_select.dart';

class GuardEventHistory extends StatefulWidget {
  const GuardEventHistory({super.key});

  @override
  State<GuardEventHistory> createState() => _GuardEventHistoryState();
}

class _GuardEventHistoryState extends State<GuardEventHistory> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getEventVisitors();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var visitorSnapshot in _allResults) {
        var timeBooked =
            visitorSnapshot['Time Booked'].toString().toLowerCase();
        if (timeBooked.contains(_searchController.text.toLowerCase())) {
          showResults.add(visitorSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getEventVisitors() async {
    var data =
        await FirebaseFirestore.instance.collection('Event Visitors').get();

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

  Color accentColor = const Color.fromARGB(255, 5, 25, 86);
  Color bgColor = const Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GuardVisitorSelect()),
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
                "Time Booked: " + visitorData['Time Booked'].toString() + "\n",
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
                    "Location: " + visitorData['Resident Address'],
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "Start Time: " + visitorData['Start Time'],
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    "End Time: " + visitorData['End Time'] + "\n",
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
