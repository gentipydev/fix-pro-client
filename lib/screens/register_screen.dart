import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/screens/login_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/utils/validators.dart';
import 'package:fit_pro_client/widgets/custom_datefield.dart';
import 'package:fit_pro_client/widgets/custom_international_phone_textfield.dart';
import 'package:fit_pro_client/widgets/custom_password_textfield.dart';
import 'package:fit_pro_client/widgets/custom_square_tile.dart';
import 'package:fit_pro_client/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool terms = false;
  bool isSubmitting = false;

  final cityController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final confirmPinController = TextEditingController();
  final yearOfBirthController = TextEditingController();
  final monthOfBirthController = TextEditingController();
  final dayOfBirthController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final firstNameError = ValueNotifier<String?>(null);
  final lastNameError = ValueNotifier<String?>(null);
  final emailError = ValueNotifier<String?>(null);
  final passwordError = ValueNotifier<String?>(null);
  final cityError = ValueNotifier<String?>(null);
  final phoneNumberError = ValueNotifier<String?>(null);
  final birthDateError = ValueNotifier<String?>(null);
  final isFormSubmitted = ValueNotifier<bool>(false);
  
final GlobalKey<InternationalPhoneInputState> internationalPhoneInputKey = GlobalKey();

  @override
  void dispose() {
    cityController.dispose();
    confirmPasswordController.dispose();
    confirmPinController.dispose();
    yearOfBirthController.dispose();
    monthOfBirthController.dispose();
    dayOfBirthController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Validators validators = Provider.of<Validators>(context);
    return Stack(
      children: [
      Scaffold(
        backgroundColor: AppColors.grey100,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/supermario_background.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        AppColors.black.withOpacity(0.3),
                        BlendMode.hardLight,
                      ),
                    ),
                  ),
                ),
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Align(
                            alignment: const Alignment(0.26, 0.0),
                            child: SizedBox(
                              width: 240.w,
                              height: 42.h,
                              child: Text(
                                "Krijoni Llogarine Tuaj",
                                style: GoogleFonts.oswald(
                                  fontSize: 20.sp,
                                  color: AppColors.white,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w500,
                                  height: 0.7727272727272727,
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                softWrap: false,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Column(
                            children: <Widget>[
                              Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(45.w),
                                  border: Border.all(
                                      width: 2.w,
                                      color: AppColors.white),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/fix.png',
                                        width: 80.w,
                                        height: 80.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            color: AppColors.tomatoRed,
                            child: Column(
                              children: [
                                InternationalPhoneInput(
                                  isSubmitted: isFormSubmitted,
                                  key: internationalPhoneInputKey,
                                  initialCountry: 'US',
                                  onInputChanged: (PhoneNumber number) {
                                  },
                                  onInputValidated: (bool isValid) {
                                    phoneNumberError.value = isValid ? null : "Numri nuk eshte i sakte";
                                  },
                                  onSaved: (PhoneNumber number) {
                                  },
                                  phoneNumberController: phoneNumberController,
                                  phoneError: phoneNumberError,
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  controller: firstNameController,
                                  label: "Emri",
                                  obscureText: false,
                                  whiteBackground: true,
                                  errorMessage: firstNameError,
                                  validator: (value) => validators.firstNameValidator(value, context),
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  controller: lastNameController,
                                  label: "Mbiemri",
                                  obscureText: false,
                                  whiteBackground: true,
                                  errorMessage: lastNameError,
                                  validator: (value) => validators.lastNameValidator(value, context),
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  controller: emailController,
                                  label: "Email",
                                  obscureText: false,
                                  whiteBackground: true,
                                  errorMessage: emailError,
                                  validator: (value) => validators.emailValidator(value, context),
    
                                ),
                                SizedBox(height: 10.h),
                                PasswordTextField(
                                  controller: passwordController,
                                  label: "Password",
                                  whiteBackground: true,
                                  errorMessage: passwordError,
                                  validator: (value) => validators.registerPasswordValidator(value, context),
                                  large: false,
                                ),
                                SizedBox(height: 10.h),
                                CustomTextField(
                                  controller: cityController,
                                  label: "Qyteti",
                                  obscureText: false,
                                  whiteBackground: true,
                                  errorMessage: cityError,
                                  validator: (value) => validators.cityValidator(value, context),
                                ),
                                SizedBox(height: 10.h),
                                CustomDatefield(
                                  yearController: yearOfBirthController,
                                  monthController: monthOfBirthController,
                                  dayController: dayOfBirthController,
                                  label: "Datelindja",
                                  errorMessage: birthDateError,
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 36.w),
                                  child: Row(
                                      children: [
                                        SizedBox(
                                          width: 25.w,
                                          height: 25.h,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                              border: Border.all(
                                              color:  AppColors.white,
                                              width: 3.w
                                              ),
                                            ),
                                            child: Transform.scale(
                                              scale: 1.5,
                                              child: Checkbox(
                                                value: terms,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    terms = value!;
                                                  });
                                                },
                                                activeColor: AppColors.white,
                                                checkColor: AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "Pranoni kushtet e perdorimit",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.w,
                                            color: AppColors.white,
                                            letterSpacing: 0.28,
                                            height: 1.2142857142857142,
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                                SizedBox(height: 20.h),
                                GestureDetector(
                                  onTap: () async {
                                    // Prevent multiple submissions
                                    if (isSubmitting) return;

                                    // Run form validation
                                    isFormSubmitted.value = true;
                                    String? firstNameError = validators.firstNameValidator(firstNameController.text, context);
                                    String? lastNameError = validators.lastNameValidator(lastNameController.text, context);
                                    String? emailError = validators.emailValidator(emailController.text, context);
                                    String? passwordError = validators.registerPasswordValidator(passwordController.text, context);
                                    String? cityError = validators.cityValidator(cityController.text, context);
                                    String? birthDateError = validators.dateValidator(
                                      yearOfBirthController.text,
                                      monthOfBirthController.text,
                                      dayOfBirthController.text,
                                      context,
                                      true,
                                    );

                                    if (phoneNumberController.text.isEmpty) {
                                      phoneNumberError.value = "Numri nuk eshte i sakte";
                                    }

                                    // Update the validation error state
                                    this.firstNameError.value = firstNameError;
                                    this.lastNameError.value = lastNameError;
                                    this.emailError.value = emailError;
                                    this.passwordError.value = passwordError;
                                    this.cityError.value = cityError;
                                    this.birthDateError.value = birthDateError;

                                    // Check if all validation errors are null
                                    if (firstNameError == null &&
                                        lastNameError == null &&
                                        emailError == null &&
                                        passwordError == null &&
                                        cityError == null &&
                                        birthDateError == null &&
                                        phoneNumberController.text.isNotEmpty) {
                                      
                                      // Start loading spinner and simulate network request
                                      setState(() {
                                        isSubmitting = true; // Show loading indicator
                                      });

                                      // Simulate network request with a 1-second delay
                                      await Future.delayed(const Duration(seconds: 1));

                                      // Stop loading spinner and navigate to HomeScreen
                                      setState(() {
                                        isSubmitting = false; // Hide loading indicator
                                      });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    );
                                    } else {
                                      if (mounted) {
                                        setState(() {
                                          // You can handle displaying specific error logic here
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(38.w, 0, 38.w, 0),
                                    height: 60.h,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x4df89500),
                                                offset: Offset(0, 10.w),
                                                blurRadius: 30.r,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: isSubmitting
                                              ? const CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                                )
                                              : Text(
                                                  "Rregjistrohuni",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 18.sp,
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40.w),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: Text(
                                          "Ose rregjistrohuni me",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            color: AppColors.white,
                                            height: 1.4166666666666667,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                SizedBox(height: 35.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Jeni tashme i rregjistruar ?",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        color: AppColors.white,
                                        letterSpacing: 0.28,
                                        height: 1.2142857142857142,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                                        );
                                      },
                                      child: Text(
                                        "Logohuni",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
