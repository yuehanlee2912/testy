import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminResidentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> residentData;
  final String documentId;

  const SuperAdminResidentDetailsPage(
      {Key? key, required this.residentData, required this.documentId})
      : super(key: key);

  @override
  _SuperAdminResidentDetailsPageState createState() =>
      _SuperAdminResidentDetailsPageState();
}

class _SuperAdminResidentDetailsPageState
    extends State<SuperAdminResidentDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.residentData['name']);
    _addressController =
        TextEditingController(text: widget.residentData['address']);
    _emailController =
        TextEditingController(text: widget.residentData['email']);
    _phoneController =
        TextEditingController(text: widget.residentData['phone']);
    _usernameController =
        TextEditingController(text: widget.residentData['username']);
    _roleController = TextEditingController(text: widget.residentData['role']);
  }

  void _updateResidentDetails() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.documentId)
        .update({
      'name': _nameController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Details updated successfully')),
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
        title: Text(
          'Resident Details',
          style: TextStyle(color: textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 500,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      readOnly: true,
                      style: TextStyle(color: bgColor),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _usernameController,
                      readOnly: true,
                      style: TextStyle(color: bgColor),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _roleController,
                      readOnly: true,
                      style: TextStyle(color: bgColor),
                      decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: TextStyle(color: textColor),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateResidentDetails,
                      child: Text('Update Details',
                          style: TextStyle(color: textColor)),
                      style: ElevatedButton.styleFrom(backgroundColor: bgColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
