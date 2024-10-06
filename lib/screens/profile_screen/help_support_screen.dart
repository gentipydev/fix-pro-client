import 'package:flutter/material.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ndihmë dhe Mbështetje'),
        backgroundColor: AppColors.tomatoRed,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Merr ndihmë për çdo paqartësi',
                style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to open support or help options
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomatoRed,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                ),
                child: Text('Kontakto Mbështetjen', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
