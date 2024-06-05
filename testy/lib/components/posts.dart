import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testy/components/comment.dart';
import 'package:testy/components/comment_button.dart';
import 'package:testy/components/like_button.dart';
import 'package:testy/helper/helper_methods.dart';

class Posts extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const Posts({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;

  //text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email!);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //update to firebase
    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Message Board")
        .doc(widget.postId);
    if (isLiked) {
      //if post is liked, add users email to the likes
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is unliked, remove the users emails from the likes
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Message Board")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  //show dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),

          //post
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message
              Text(widget.message),

              const SizedBox(height: 5),
              //user
              Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    " • ",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),

                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              //COMMENT
              Column(
                children: [
                  //comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(height: 5),

                  //like count
                  Text(
                    '0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          //comments
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Message Board")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle if no data
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;

                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
