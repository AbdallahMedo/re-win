import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onpressed;
  final Color backColor;

  CustomElevatedButton({
    required this.title,
    required this.color,
    required this.onpressed,
    required this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        backgroundColor: backColor,

      ),
      onPressed: onpressed,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,

        ),
      ),
    );
  }
}
