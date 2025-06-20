import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0

  const CustomProgressBar(BuildContext context, {super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 20,
        width: 343,
        color: Colors.grey.shade300, // background bar color
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
