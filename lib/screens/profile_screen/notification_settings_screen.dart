import 'package:flutter/material.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  NotificationSettingsScreenState createState() => NotificationSettingsScreenState();
}

class NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushTaskIdeas = true;
  bool smsTaskUpdates = false;
  bool smsTaskIdeas = true;
  bool emailTaskIdeas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Konfigurimet e njoftimeve',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.grey100, AppColors.grey300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('NJOFTIME PUSH'),
                _buildNotificationOption(
                  'Idetë dhe ofertat e punëve',
                  'Rekomandimet dhe ofertat promovuese për punët',
                  pushTaskIdeas,
                  (value) {
                    setState(() {
                      pushTaskIdeas = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                Text(
                  "Gjithmonë do të merrni njoftime për punët dhe aktivitetin e llogarisë suaj",
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                ),
                SizedBox(height: 30.h),
                const Divider(color: AppColors.grey300),
            
                _buildSectionHeader('MESAZHE ME TEKST'),
                _buildNotificationOption(
                  'Përditësimet e punëve',
                  'Përditësime nga profesionistët tuaj',
                  smsTaskUpdates,
                  (value) {
                    setState(() {
                      smsTaskUpdates = value;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                _buildNotificationOption(
                  'Idetë dhe ofertat e punëve',
                  'Rekomandimet dhe ofertat promovuese për punët',
                  smsTaskIdeas,
                  (value) {
                    setState(() {
                      smsTaskIdeas = value;
                    });
                  },
                ),
                SizedBox(height: 30.h),
                const Divider(color: AppColors.grey300),
            
                _buildSectionHeader('NJOFTIME ME EMAIL'),
                _buildNotificationOption(
                  'Idetë dhe ofertat e punëve',
                  'Rekomandimet dhe ofertat promovuese për punët',
                  emailTaskIdeas,
                  (value) {
                    setState(() {
                      emailTaskIdeas = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                Text(
                  "Gjithmonë do të merrni njoftime me email për punët dhe llogarinë tuaj",
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationOption(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.sp, color: AppColors.black),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
      ),
      value: value,
      activeColor: AppColors.tomatoRed,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.black,
        ),
      ),
    );
  }
}
