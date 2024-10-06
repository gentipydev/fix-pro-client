import 'package:flutter/material.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metodat e Pagesës'),
        backgroundColor: AppColors.tomatoRed,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Shto ose menaxho metodat e tua të pagesës',
                style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  // Add a method to add new payment methods
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomatoRed,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                ),
                child: Text('Shto Metodë të Pagesës', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
