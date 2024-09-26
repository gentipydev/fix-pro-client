import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: Text(
          'Fto një mik',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20.sp
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset(
              'assets/animations/gift_box.json',
              height: 140,
            ),
            SizedBox(height: 40.h),
            Text(
              'Ndihmo miqtë dhe fitoni 10 €',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Ndihmo miqtë! Dërgoju atyre një bonus prej 10 €! Ti do të marrësh 10 € pas punës së tyre të parë',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Kopjo linkun ose shpërndaje më poshtë:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                // Action for sharing link
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.sp),
                  side: const BorderSide(color: AppColors.tomatoRed),
                ),
                backgroundColor: AppColors.white,
              ),
              child: const Text(
                'Shpërndaje tani',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.tomatoRed,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
