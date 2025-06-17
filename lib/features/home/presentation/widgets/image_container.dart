import 'package:flutter/cupertino.dart';

class ImageContainer extends StatelessWidget {
  final String path;
  final double screenHeight;
  const ImageContainer({super.key, required this.path, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
