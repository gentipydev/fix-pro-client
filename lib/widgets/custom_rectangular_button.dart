import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RectangularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget content; 
  final VoidCallback onClick;

  const RectangularButton({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.content,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      width: width,
      height: height,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(8.r),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}
