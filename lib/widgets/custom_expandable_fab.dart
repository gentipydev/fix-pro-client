import 'package:fit_pro_client/services/communication_service.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableFab extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onAcceptTask;

  const ExpandableFab({
    super.key,
    required this.phoneNumber,
    this.onAcceptTask, 
  });

  @override
  ExpandableFabState createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation rotationAnimation;
  bool isAccepted = false; 
  bool isExpanded = false;

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
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  void _onAcceptPressed() {
    setState(() {
      isAccepted = true;
    });
    animationController.forward();

    widget.onAcceptTask!();
  }

  void _onContactPressed() {
    setState(() {
      isExpanded = !isExpanded; 
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
                // Expanded contact options appear only if FAB is expanded
                if (isExpanded)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270), 100),
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
                if (isExpanded)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225), 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _communicationService.sendSmsMessage("Hello", [widget.phoneNumber]);
                      },
                    ),
                  ),
                if (isExpanded)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180), 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _communicationService.sendWhatsAppMessage("Hello", widget.phoneNumber);
                      },
                    ),
                  ),

                // Main button with rotation and label change
                Transform(
                  transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                  alignment: Alignment.center,
                  child: CircularButton(
                    color: AppColors.grey300,
                    width: 80.w,
                    height: 80.h,
                    content: Text(
                      isAccepted ? "Kontakto" : "Prano", // Change text based on isAccepted state
                      style: TextStyle(
                        color: AppColors.tomatoRed,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onClick: isAccepted ? _onContactPressed : _onAcceptPressed, // Different actions for "Prano" and "Kontakto"
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
