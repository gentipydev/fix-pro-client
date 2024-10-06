import 'package:flutter/material.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promocionet dhe Zbritjet'),
        backgroundColor: AppColors.tomatoRed,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Zbritjet dhe Ofertat e Disponueshme',
                style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              // Placeholder for promotions
              Text(
                'Aktualisht nuk ka zbritje të reja.',
                style: TextStyle(fontSize: 16.sp, color: AppColors.grey500),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to redeem or view more details on promotions
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomatoRed,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                ),
                child: Text('Shiko Detajet', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
