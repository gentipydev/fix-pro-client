import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_rectangular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableFabRectangular extends StatefulWidget {
  final Function onReschedule;
  final Function onCancel;
  final Function onComplete;

  const ExpandableFabRectangular({
    super.key,
    required this.onReschedule,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  ExpandableFabRectangularState createState() => ExpandableFabRectangularState();
}

class ExpandableFabRectangularState extends State<ExpandableFabRectangular> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> translationAnimation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    translationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 200.w,
      height: 250.h,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          if (animationController.value > 0)
            Transform.translate(
              offset: Offset(0, -translationAnimation.value * 70.h),
              child: RectangularButton(
                color: AppColors.grey300,
                width: 150.w,
                height: 50.h,
                content: Text(
                  "Riplanifiko",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tomatoRed,
                  ),
                ),
                onClick: () {
                  widget.onReschedule();
                },
              ),
            ),
          if (animationController.value > 0)
            Transform.translate(
              offset: Offset(0, -translationAnimation.value * 210.h),
              child: RectangularButton(
                color: AppColors.tomatoRed,
                width: 150.w,
                height: 50.h,
                content: Text(
                  "Puna u Krye",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onClick: () {
                  widget.onComplete();
                },
              ),
            ),
          if (animationController.value > 0)
            Transform.translate(
              offset: Offset(0, -translationAnimation.value * 140.h),
              child: RectangularButton(
                color: AppColors.grey300,
                width: 150.w,
                height: 50.h,
                content: Text(
                  "Anullo",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tomatoRed,
                  ),
                ),
                onClick: () {
                  widget.onCancel();
                },
              ),
            ),
          RectangularButton(
            color: AppColors.grey300,
            width: 100.w,
            height: 40.h,
            content: Icon(
              Icons.menu,
              color: AppColors.tomatoRed,
              size: 30.sp,
            ),
            onClick: () {
              if (animationController.isCompleted) {
                animationController.reverse();
              } else {
                animationController.forward();
              }
            },
          ),
        ],
      ),
    );
  }
}