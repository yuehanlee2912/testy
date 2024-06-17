import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Color.fromARGB(255, 5, 25, 86);
    Color bgColor = Color.fromARGB(255, 52, 81, 161);
    Color textColor = Colors.white;
    Color lightBlueColor = Color.fromARGB(255, 133, 162, 242);
    return GestureDetector(
        onTap: onTap,
        child: Icon(
          isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt_outlined,
          color: isLiked ? Colors.blue : lightBlueColor,
        ));
  }
}
