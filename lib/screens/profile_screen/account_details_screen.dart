import 'dart:async';
import 'dart:io';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fit_pro_client/providers/account_details_provider.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  AccountDetailsScreenState createState() => AccountDetailsScreenState();
}

class AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  Logger logger = Logger();
  File? _image;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch user data on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountDetailsProvider.notifier).fetchUserProfile().then((_) {
        _populateTextFields(ref.read(accountDetailsProvider).user);
      });
    });
  }

  // Populate text fields with user data
  void _populateTextFields(user) {
    if (user != null) {
      _fullNameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      _locationController.text = user.location ?? '';
      _dateOfBirthController.text = user.dateOfBirth != null
          ? "${user.dateOfBirth!.toLocal()}".split(' ')[0]
          : '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      ref.read(accountDetailsProvider.notifier).uploadProfilePicture(_image);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> userData = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'location': _locationController.text,
        'dateOfBirth': _dateOfBirthController.text,
      };
      ref.read(accountDetailsProvider.notifier).updateUserProfile(userData);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.tomatoRed,
              onPrimary: Colors.white,
              surface: AppColors.white,
              onSurface: AppColors.grey700,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shimmer for Profile Picture
            Shimmer.fromColors(
              baseColor: AppColors.grey300,
              highlightColor: AppColors.grey100,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey300,
                  border: Border.all(
                    color: AppColors.grey300,
                    width: 4.0.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Shimmer.fromColors(
              baseColor: AppColors.grey300,
              highlightColor: AppColors.grey100,
              child: Container(
                width: 160.w,
                height: 20.h,
                color: AppColors.grey300,
              ),
            ),
            SizedBox(height: 30.h),

            _buildShimmerTextField(320.w, 50.h),
            SizedBox(height: 20.h),
            _buildShimmerTextField(320.w, 50.h),
            SizedBox(height: 20.h),
            _buildShimmerTextField(320.w, 50.h),
            SizedBox(height: 20.h),
            _buildShimmerTextField(320.w, 50.h),
            SizedBox(height: 20.h),
            _buildShimmerTextField(320.w, 50.h),
            SizedBox(height: 40.h),

            Shimmer.fromColors(
              baseColor: AppColors.grey300,
              highlightColor: AppColors.grey100,
              child: Container(
                width: 200.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTextField(double w, double h) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey300,
      highlightColor: AppColors.grey100,
      child: Container(
        width: 320.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 15.w,
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: AppColors.grey300,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final state = ref.watch(accountDetailsProvider);
  final isLoading = state.isLoading;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.tomatoRed,
      title: const Text(
        'Detajet e Llogarise',
        style: TextStyle(color: AppColors.white, fontSize: 18),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
    body: isLoading
      ? _buildShimmerLoading()
      : SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.grey300,
                              width: 4.0.w,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage('assets/images/client4.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey700,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: AppColors.tomatoRed,
                              size: 22.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Modifiko foton e profilit',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
                  ),
                  SizedBox(height: 30.h),
            
                  // Full Name Text Field
                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Emri i plotë',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20.h),
            
                  // Email Text Field
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
            
                  // Phone Number Text Field
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Numri telefonit',
                    icon: Icons.phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[+0-9]{7,15}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
            
                  // Location Text Field
                  CustomTextField(
                    controller: _locationController,
                    labelText: 'Vendodhja',
                    icon: Icons.location_city,
                  ),
                  SizedBox(height: 20.h),
            
                  // Date of Birth Text Field
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _dateOfBirthController,
                        labelText: 'Datëlindja',
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Save Changes Button
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomatoRed,
                      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Ruaj ndryshimet',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}