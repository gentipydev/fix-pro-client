import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String warningText;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String clientName;
  final String clientImage;
  final bool showLottieIcon;
  final bool isUrgent;

  const TaskCard({
    required this.title,
    required this.warningText,
    required this.date,
    required this.time,
    required this.location,
    required this.clientName,
    required this.clientImage,
    this.showLottieIcon = false,
    this.isUrgent = false,
    super.key,
  });

  // Helper function to format TimeOfDay as "02: 00"
  String formatTimeOfDay(TimeOfDay time) {
    final String formattedHour = time.hour.toString().padLeft(2, '0');
    final String formattedMinute = time.minute.toString().padLeft(2, '0');
    return "$formattedHour: $formattedMinute";
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'sq').format(date);
    String formattedTime = formatTimeOfDay(time);

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      warningText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.tomatoRed,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16.sp, color: AppColors.grey700),
                        SizedBox(width: 4.w),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16.sp, color: AppColors.grey700),
                        SizedBox(width: 4.w),
                        Text(
                          formattedTime, // Display formatted time here
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16.sp, color: AppColors.grey700),
                        SizedBox(width: 4.w),
                        Text(
                          location,
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26.sp,
                      backgroundImage: AssetImage(clientImage),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      clientName,
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showLottieIcon)
            Positioned(
              top: 0,
              right: 0,
              child: Lottie.asset(
                'assets/animations/touch_app.json',
                width: 40.w,
                height: 40.h,
                fit: BoxFit.cover,
                repeat: true
              ),
            ),
        ],
      ),
    )
    .animate(target: isUrgent ? 1 : 0)
    .shake(
      duration: 600.ms,
      hz: 4,            
      offset: Offset(1.w, 0),
      curve: Curves.easeInOut,
    );
  }
}
