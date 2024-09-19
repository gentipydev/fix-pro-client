import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InternationalPhoneInput extends StatefulWidget {
  final String initialCountry;
  final Function(PhoneNumber) onInputChanged;
  final Function(bool) onInputValidated;
  final Function(PhoneNumber) onSaved;
  final TextEditingController phoneNumberController;
  final ValueNotifier<String?> phoneError;
  final ValueNotifier<bool> isSubmitted;
  final bool applyMargin;

  const  InternationalPhoneInput({
    super.key,
    required this.initialCountry,
    required this.onInputChanged,
    required this.onInputValidated,
    required this.onSaved,
    required this.phoneNumberController,
    required this.phoneError,
    required this.isSubmitted,
    this.applyMargin = true,
  });

  @override
  InternationalPhoneInputState createState() =>
      InternationalPhoneInputState();
}

class InternationalPhoneInputState extends State<InternationalPhoneInput> {
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  bool isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    number = PhoneNumber(isoCode: widget.initialCountry);
  }


@override
Widget build(BuildContext context) {


    EdgeInsets margin = widget.applyMargin 
                      ? EdgeInsets.only(left: 38.w, right: 38.w) 
                      : EdgeInsets.zero;

    return ValueListenableBuilder(
      valueListenable: widget.isSubmitted, 
      builder: (context, isSubmitted, child) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.phoneError, 
      builder: (context, error, child) {
            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              margin: margin,
              height: 70.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber num) {
                            widget.onInputChanged(num);
                            widget.phoneNumberController.text = num.phoneNumber!;
                          },
                          onInputValidated: (bool isValid) {
                            widget.onInputValidated(isValid);
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(color: AppColors.black),
                        initialValue: number,
                        formatInput: false,
                        spaceBetweenSelectorAndTextField: 10.w,
                        inputDecoration: InputDecoration(
                          hintText: '222 - 2222 - 222',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color:  AppColors.grey700,
                            fontWeight: FontWeight.w300,
                            height: 1.2142857142857142,
                          ),
                          border: InputBorder.none,
                          contentPadding: 
                          EdgeInsets.only(bottom: 16.h, top: 16.h),
                        ),
                        onSaved: (PhoneNumber num) {
                          widget.onSaved(num);
                          widget.phoneNumberController.text = num.phoneNumber!;
                        },
                      ),
                  ),
                  Positioned(
                    left: 100.w, 
                    top: 10.h, 
                    bottom: 10.h,
                    child: Container(
                      width: 1.w,
                      color: AppColors.grey100, 
                    ),
                  ),
                ],
              ),
            ),
            if (isSubmitted && error != null)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    error,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: AppColors.tomatoRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],  
          );
        },
      );
    },
  );
}
}