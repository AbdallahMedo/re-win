import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scores extends StatelessWidget {
  final String imagePath;
  final String score;
  final String result;

  const Scores({
    Key? key,
    required this.imagePath,
    required this.score,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imagePath,
          height: 25,
        ),
        const SizedBox(height: 10),
        Text(
          score,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
         Text(
          result,
          style:const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
