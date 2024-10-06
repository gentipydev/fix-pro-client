import 'package:fit_pro_client/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginSecurityScreen extends StatefulWidget {
  const LoginSecurityScreen({super.key});

  @override
  State<LoginSecurityScreen> createState() => _LoginSecurityScreenState();
}

class _LoginSecurityScreenState extends State<LoginSecurityScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _updatePassword() {
    // final newPassword = _newPasswordController.text;
    // final confirmPassword = _confirmPasswordController.text;

    // if (newPassword == confirmPassword) {
    //   // Handle password update logic here
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Password updated successfully!")),
    //   );
    // } else {
    //   // Show error
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Passwords do not match!")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Hyrje & Siguria',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Hyrje'),
            ListTile(
              title: const Text(
                'Fjalëkalimi',
                style: TextStyle(
                  color: AppColors.grey700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Modifikuar një muaj më parë',
                style: TextStyle(
                  color: AppColors.grey500,
                ),
              ),
              trailing: Icon(
                FontAwesomeIcons.checkDouble,
                color: AppColors.tomatoRed,
                size: 20.w,
              ),
            ),
            const SizedBox(height: 20),

            // Password update section
            _buildPasswordSection(),
            const SizedBox(height: 40),

            // Security info section
            _buildSecurityInfoSection(),
            const SizedBox(height: 30),

            // Deactivate Account
            _buildDeactivateAccountSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_currentPasswordController, 'Fjalëkalimi Aktual', 'Fjalëkalimi Aktual'),
        const SizedBox(height: 20),
        _buildTextField(_newPasswordController, 'Fjalëkalim i Ri', 'Fjalëkalim i Ri'),
        const SizedBox(height: 20),
        _buildTextField(_confirmPasswordController, 'Konfirmo Fjalëkalimin', 'Konfirmo Fjalëkalimin'),
        const SizedBox(height: 20),

        // Update password button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _updatePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomatoRed,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'Modifiko Fjalëkalimin',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Using CustomTextField for password inputs
  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      obscureText: true, 
    );
  }

  // Widget for Security Information Section
  Widget _buildSecurityInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.userShield, 
                color: AppColors.tomatoRed,
                size: 22.sp,
              ),
              const SizedBox(width: 20),
              Text(
                'Duke mbajtur llogarinë tuaj të sigurt',
                style: TextStyle(
                  color: AppColors.grey700,
                  fontWeight: FontWeight.bold, 
                  fontSize: 16.sp
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ne rregullisht kontrollojmë llogaritë për t\'u siguruar që janë sa më të sigurta të jetë e mundur. '
            'Ne gjithashtu do t\'ju njoftojmë nëse ka më shumë që mund të bëjmë për të rritur sigurinë e llogarisë suaj.',
            style: TextStyle(
              fontSize: 14.sp, 
              color: AppColors.grey700
            ),
          ),
        ],
      ),
    );
  }
}

  // Widget for Deactivate Account section
  Widget _buildDeactivateAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Llogaria'),
        const SizedBox(height: 10),
        ListTile(
          title: const Text(
            'Çaktivizoni llogarinë tuaj',
            style: TextStyle(
              color: AppColors.grey700,
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              // Optionally handle account deactivation
            },
            child: Text(
              'Çaktivizo',
              style: TextStyle(
              color: AppColors.tomatoRed,
              fontSize: 18.sp
            ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.grey700,
        ),
      ),
    );
  }
