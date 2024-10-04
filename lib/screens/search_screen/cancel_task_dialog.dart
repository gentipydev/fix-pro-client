import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_pro_client/utils/constants.dart';

void showCancelDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        titlePadding: const EdgeInsets.all(16),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jeni i sigurt që doni të largoheni?',
                style: TextStyle(
                  color: AppColors.grey700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.warning,
                    size: 22,
                    color: AppColors.tomatoRed,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Kërkesa për punë do të anullohet menjëherë',
                      style: TextStyle(
                        color: AppColors.tomatoRed,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.grey300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Jo',
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.tomatoRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  ref.read(taskStateProvider.notifier).resetTask(); 
                  ref.read(mapStateProvider.notifier).clearPolylines();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  'Po, jam i sigurt',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
