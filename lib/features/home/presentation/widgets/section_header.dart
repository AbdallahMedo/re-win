import 'package:flutter/material.dart';

class buildSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
   bool isTablet;

   buildSectionHeader({super.key, required this.title,  this.subtitle,required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xffa7d482),
            ),
          ),
      ],
    );
  }
}
