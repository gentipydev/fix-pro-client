import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSquareTile extends StatelessWidget {
  final String imagePath;
  const CustomSquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: SvgPicture.asset(
        imagePath,
        height: 60,
      ),
    );
  }
}
