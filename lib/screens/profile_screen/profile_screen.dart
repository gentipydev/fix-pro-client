import 'package:fit_pro_client/screens/invite_friend_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/account_details_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/help_support_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/login_security_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/notification_settings_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/payment_methods_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/promotions_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/statistics_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: const AssetImage('assets/images/client4.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Alexa Burgaj',
                    style: TextStyle(
                      color: AppColors.grey700,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InviteFriendScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.sp),
                        side: const BorderSide(color: AppColors.tomatoRed),
                      ),
                      backgroundColor: AppColors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fto një mik dhe fito 10 euro bonus',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.tomatoRed,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Lottie.asset(
                          repeat: true,
                          'assets/animations/celebrating.json',
                          width: 30.w,
                          height: 30.h,
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            _buildProfileOption(
              context: context,
              title: 'Info personale',
              subtitle: 'Shiko dhe menaxho të dhënat e tua personale',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountDetailsScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Hyrje & Siguria',
              subtitle: 'Menaxho fjalëkalimet dhe sigurinë e llogarisë',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginSecurityScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Metodat e Pagesës',
              subtitle: 'Shto, modifiko, ose hiq opsionet e pagesave',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Statistikat e punëve',
              subtitle: 'Shiko performancën, vlerësimet dhe komentet për punët e porositura',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserStatisticsScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Konfigurimet e Njoftimeve',
              subtitle: 'Menaxho preferencat e njoftimeve',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Promocionet dhe Zbritjet',
              subtitle: 'Shiko zbritjet dhe ofertat e disponueshme',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PromotionsScreen()),
                );
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Kerko ndihme',
              subtitle: 'Merr ndihmë ose kontakto per cdo paqartesi apo informacion',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16, 
              color: AppColors.grey700,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.grey700,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
