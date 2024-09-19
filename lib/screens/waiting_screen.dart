import 'package:fit_pro_client/screens/tasker_map_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:lottie/lottie.dart';
import 'package:another_flushbar/flushbar.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  WaitingScreenState createState() => WaitingScreenState();
}

class WaitingScreenState extends State<WaitingScreen> {
  Logger logger = Logger();
  static const int countdownDuration = 3600;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _showTaskAcceptedNotification(context);
    });
  }

  void _showTaskAcceptedNotification(BuildContext context) {
    Flushbar(
      message: "Puna u pranua nga profesionisti",
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.tomatoRed,
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(
        Icons.check_circle,
        color: AppColors.white,
      ),
    ).show(context).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskerMapScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.tomatoRedLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prisni konfirmimin e punës !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Profesionisti juaj ka deri në 1 orë kohë për të pranuar punën, deri atëhere ju nuk do jeni ne gjendje te bëni një kërkesë tjetër',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Countdown(
              seconds: countdownDuration,
              build: (_, double time) {
                int minutes = ((time ~/ 60).toInt());
                int seconds = (time % 60).toInt();
                
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 300.w,
                        width: 300.w,
                        child: Lottie.asset(
                            'assets/animations/circular_dot_animation.json',
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                );
              },
              onFinished: () {
                // Handle what happens when the countdown finishes
                logger.d("Countdown Finished");
                // Optionally, navigate to another screen or show a message
              },
            ),
          ],
        ),
    );
  }
}
