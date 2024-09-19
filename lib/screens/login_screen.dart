import 'dart:ui' as ui;
import 'package:fit_pro_client/providers/login_validation_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/utils/validators.dart';
import 'package:fit_pro_client/widgets/custom_simple_textfield.dart';
import 'package:fit_pro_client/widgets/custom_square_tile.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({superKey}) : super(key: superKey);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Logger logger = Logger();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void precachBackgroundImage(BuildContext context) {
    precacheImage(const AssetImage('assets/images/supermario_background.jpg'), context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precachBackgroundImage(context);
  }

  @override
  Widget build(BuildContext context) {
    final validators = Provider.of<Validators>(context, listen: false);
    final loginValidationProvider = Provider.of<LoginValidationProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: 580.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/supermario_background.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              AppColors.black.withOpacity(0.3), BlendMode.hardLight),
                        ),
                      ),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          height: 580.h,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 80.h),
                          Center(
                            child: Container(
                              width: 120.w,
                              height: 120.h,
                             decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  width: 5.w,
                                  color: AppColors.grey300.withOpacity(0.6),
                                ),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/fix.png',
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 80.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomSimpleTextField(
                                    label: 'Email',
                                    controller: emailController,
                                    iconPath: 'assets/icons/email-icon.svg',
                                    validator: (value) => validators.simpleEmailValidator(value, context),
                                  ),
                                  SizedBox(height: 30.h),
                                  CustomSimpleTextField(
                                    label: 'Password',
                                    controller: passwordController,
                                    iconPath: 'assets/icons/password-icon.svg',
                                    obscureText: true,
                                    validator: (value) => validators.simplePasswordValidator(value, context),
                                    showPassword: true,
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // navigate to forgot password screen
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 42.w),
                              child: Text(
                                'Keni harruar fjalëkalimin ?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                  height: 1.4166666666666667,
                                  fontWeight: FontWeight.w400,
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                ),
                                textAlign: TextAlign.right,
                                softWrap: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  color: AppColors.tomatoRed,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate() &&
                              loginValidationProvider.isEmailValid &&
                              loginValidationProvider.isPasswordValid) {
                            setState(() {
                              isLoading = true;
                            });

                            // Simulate network request with a 1-second delay
                            await Future.delayed(const Duration(seconds: 1));

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pushNamed(context, '/home');
                          } else {
                            if (mounted) {
                              setState(() {
                                // Display errors (can add specific logic if needed)
                              });
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(38.w, 0, 37.w, 0),
                          height: 60.h,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                              ),
                              Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.tomatoRed),
                                      )
                                    : SizedBox(
                                        width: 80.w,
                                        height: 21.h,
                                        child: Text(
                                          'Hyni',
                                          style: TextStyle(
                                            fontSize: 18.w,
                                            color: AppColors.tomatoRed,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textHeightBehavior: const TextHeightBehavior(
                                            applyHeightToFirstAscent: false,
                                          ),
                                          textAlign: TextAlign.center,
                                          softWrap: false,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 100.w,
                            child: Divider(
                              thickness: 1.w,
                              color: AppColors.white,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'Ose vazhdoni me ',
                                style: TextStyle(
                                  fontSize: 14.w,
                                  color: AppColors.white,
                                  height: 1.4166666666666667,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: Divider(
                              thickness: 1.w,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomSquareTile(imagePath: 'assets/icons/google-icon.svg'),
                          SizedBox(width: 25.w),
                          const CustomSquareTile(imagePath: 'assets/icons/apple-icon.svg')
                        ],
                      ),
                      SizedBox(height: 60.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Nuk keni akoma një llogari ?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'Rregjistrohuni',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
