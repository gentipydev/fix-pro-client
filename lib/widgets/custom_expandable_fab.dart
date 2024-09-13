import 'package:fit_pro_client/services/communication_service.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableFab extends StatefulWidget {
  final String phoneNumber;
  const ExpandableFab({super.key, required this.phoneNumber});

  @override
  ExpandableFabState createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  late Animation rotationAnimation;

  final CommunicationService _communicationService = CommunicationService();

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
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
      height: 200.h,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 30.w,
            bottom: 30.h,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    height: 200.h,
                    width: 180.w,
                  ),
                ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _communicationService.makePhoneCall(widget.phoneNumber);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225), degTwoTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendSmsMessage("Hello", [widget.phoneNumber]);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180), degThreeTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendWhatsAppMessage("Hello", widget.phoneNumber);
                      },
                    ),
                  ),
                Transform(
                  transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                  alignment: Alignment.center,
                  child: CircularButton(
                    color: AppColors.grey300,
                    width: 70.w,
                    height: 70.h,
                    content: Text(
                      "Kontakto",
                      style: TextStyle(
                        color: AppColors.tomatoRed,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onClick: () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget content;
  final Function onClick;

  const CircularButton({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.content,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onClick();
        },
        child: Center(child: content),
      ),
    );
  }
}
