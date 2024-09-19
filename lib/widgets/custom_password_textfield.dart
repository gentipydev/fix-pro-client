import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool whiteBackground;
  final bool greyBackground;
  final ValueNotifier<String?> errorMessage;
  final FormFieldValidator<String>? validator;
  final bool large;

  const PasswordTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.errorMessage,
    this.whiteBackground = false,
    this.greyBackground = false,
    this.validator,
    this.large = true,
  });

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  late bool _isObscured;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _isObscured = true;
  }

@override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }



  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

   @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<String?>(
      valueListenable: widget.errorMessage,
      builder: (context, error, child) {
        return GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Container(
            margin: widget.large 
              ? EdgeInsets.fromLTRB(8.w, 0, 8.w, 0)
              : EdgeInsets.fromLTRB(38.w, 0, 38.w, 0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: 70.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.whiteBackground ? AppColors.white : widget.greyBackground ? AppColors.grey300.withOpacity(0.4) : AppColors.black,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(width: 1.w, color: AppColors.white),
                  ),
                  child: Row(
                    children: [
                     Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: widget.label.split(' ').map((word) {
                          return Text(
                            word,
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: widget.whiteBackground || widget.greyBackground ? AppColors.black : AppColors.white,
                              fontWeight: FontWeight.w300,
                              height: 1.2142857142857142,
                            ),
                            softWrap: false,
                          );
                        }).toList(),
                      ),
                    ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: widget.controller,
                          obscureText: _isObscured,
                          validator: widget.validator,
                          style: TextStyle(
                            color: widget.whiteBackground || widget.greyBackground ? AppColors.black : AppColors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 10.w,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(
                                _isObscured ? Icons.visibility_off : Icons.visibility,
                                color: widget.whiteBackground || widget.greyBackground
                                    ? AppColors.black.withOpacity(0.5)
                                    : AppColors.white,

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (error != null)
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
                        height: 1.2142857142857142,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}