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
  final String role;
  final String time;
  final String postId;
  final List<String> likes;
  final int commentsCount;

  const Posts({
    super.key,
    required this.message,
    required this.user,
    required this.role,
    required this.postId,
    required this.likes,
    required this.time,
    required this.commentsCount,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();
  final _isCommentTextNotEmpty = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email!);

    _commentTextController.addListener(() {
      _isCommentTextNotEmpty.value = _commentTextController.text.isNotEmpty;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Message Board")
        .doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Message Board")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    }).then((_) {
      FirebaseFirestore.instance
          .collection('Message Board')
          .doc(widget.postId)
          .update({
        'commentsCount': FieldValue.increment(1),
      });
    });
  }

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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isCommentTextNotEmpty,
            builder: (context, isNotEmpty, child) {
              return TextButton(
                onPressed: isNotEmpty
                    ? () {
                        addComment(_commentTextController.text);
                        Navigator.pop(context);
                        _commentTextController.clear();
                      }
                    : null,
                child: Text("Post"),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = const Color.fromARGB(255, 5, 25, 86);
    Color bgColor = const Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = const Color.fromARGB(255, 133, 162, 242);

    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message, style: TextStyle(color: textColor)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "${widget.user} (${widget.role})",
                    style: TextStyle(color: lightBlueColor, fontSize: 11),
                  ),
                  Text(
                    " • ",
                    style: TextStyle(color: lightBlueColor, fontSize: 11),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: lightBlueColor, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.commentsCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Message Board")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }
}
