import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testy/pages/guard_page.dart';

class CarparkPage extends StatefulWidget {
  const CarparkPage({super.key});

  @override
  State<CarparkPage> createState() => _CarparkPageState();
}

class _CarparkPageState extends State<CarparkPage> {
  Color accentColor = const Color.fromARGB(255, 5, 25, 86);
  Color bgColor = const Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);
  Color carTakenColor = Colors.red;

  int _carparkSlots = 0;
  int _takenSlots = 0;
  List<Map<String, dynamic>> _takenSlotsData = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchCarparkData();
    _fetchVisitorData();
  }

  void _fetchCarparkData() async {
    DocumentSnapshot doc =
        await _firestore.collection('Carpark').doc('slots').get();
    if (doc.exists) {
      setState(() {
        _carparkSlots = doc['amount'];
      });
    } else {
      await _firestore
          .collection('Carpark')
          .doc('slots')
          .set({'amount': 1, 'takenSlots': 0});
      setState(() {
        _carparkSlots = 1;
        _takenSlots = 0;
      });
    }
  }

  void _fetchVisitorData() async {
    QuerySnapshot snapshot = await _firestore.collection('Visitors').get();
    List<Map<String, dynamic>> takenSlotsData = [];
    int takenSlots = 0;

    for (var doc in snapshot.docs) {
      if (doc['Type'] == 'Visitor' && doc['Status'] == 'Entered') {
        takenSlots++;
        takenSlotsData.add({
          'carPlateNumber': doc['Car Plate Number'],
          'timeEntered': doc['Time Entered'],
        });
      }
    }

    setState(() {
      _takenSlots = takenSlots;
      _takenSlotsData = takenSlotsData;
    });
  }

  void _addCarparkSlot() async {
    setState(() {
      _carparkSlots++;
    });
    await _firestore
        .collection('Carpark')
        .doc('slots')
        .update({'amount': _carparkSlots});
  }

  void _removeCarparkSlot() async {
    if (_carparkSlots > 0) {
      setState(() {
        _carparkSlots--;
      });
      await _firestore
          .collection('Carpark')
          .doc('slots')
          .update({'amount': _carparkSlots});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminPage()),
          ),
        ),
        title: Text("Carpark Availability", style: TextStyle(color: textColor)),
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Available Carparks: ${_carparkSlots - _takenSlots}/$_carparkSlots',
              style: TextStyle(fontSize: 24, color: textColor),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: _carparkSlots,
                itemBuilder: (context, index) {
                  bool isTaken = index < _takenSlots;
                  Map<String, dynamic>? slotData =
                      isTaken ? _takenSlotsData[index] : null;

                  return Container(
                    decoration: BoxDecoration(
                      color: isTaken ? carTakenColor : Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isTaken
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_car,
                                    size: 40, color: textColor),
                                Text(
                                  slotData?['carPlateNumber'] ?? '',
                                  style:
                                      TextStyle(fontSize: 16, color: textColor),
                                ),
                              ],
                            )
                          : Icon(Icons.local_parking,
                              size: 40, color: textColor),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addCarparkSlot,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                  ),
                  child: Text('Add Carpark Slot',
                      style: TextStyle(color: textColor)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _removeCarparkSlot,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Remove Carpark Slot',
                      style: TextStyle(color: textColor)),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
