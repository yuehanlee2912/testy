import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/text_field.dart';
import 'package:testy/components/posts.dart';
import 'package:testy/helper/helper_methods.dart';
import 'package:testy/pages/guard_page.dart';

class GuardMessageBoard extends StatefulWidget {
  const GuardMessageBoard({super.key});

  @override
  State<GuardMessageBoard> createState() => _GuardMessageBoardState();
}

class _GuardMessageBoardState extends State<GuardMessageBoard> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //post message
  void postMessage() {
    //only post if something in textfield
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("Message Board").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'commentsCount': 0,
      });
    }

    //clear textfield
    setState(() {
      textController.clear();
    });
  }

  Color accentColor = const Color.fromARGB(255, 5, 25, 86);
  Color bgColor = const Color.fromARGB(255, 52, 81, 161);
  Color textColor = Colors.white;
  Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);

  Future<String> getUserRole(String userEmail) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userDoc.docs.isNotEmpty) {
      return userDoc.docs.first['role'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Community Board", style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminPage())),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              //message board
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Message Board")
                      .orderBy(
                        "TimeStamp",
                        descending: true,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //get message
                          final post = snapshot.data!.docs[index];
                          return FutureBuilder<String>(
                            future: getUserRole(post['UserEmail']),
                            builder: (context, roleSnapshot) {
                              if (roleSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Posts(
                                message: post['Message'],
                                user: post['UserEmail'],
                                role: roleSnapshot.data ?? 'Unknown',
                                postId: post.id,
                                likes: List<String>.from(post['Likes'] ?? []),
                                time: formatDate(post['TimeStamp']),
                                commentsCount: post['commentsCount'] ?? 0,
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),

              //post message
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: 'Write something...',
                        obscureText: false,
                      ),
                    ),

                    //post button
                    IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up),
                      color: textColor,
                    )
                  ],
                ),
              ),

              //logged in as
              Text(
                "Logged in as: ${currentUser.email!}",
                style: TextStyle(color: textColor),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
