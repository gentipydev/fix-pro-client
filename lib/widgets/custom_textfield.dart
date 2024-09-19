import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? iconPath;
  final bool obscureText;
  final bool whiteBackground;
  final bool greyBackground;
  final ValueNotifier<String?>? errorMessage;
  final FormFieldValidator<String>? validator;


    const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.errorMessage,
    this.iconPath,
    this.obscureText = false,
    this.whiteBackground = false,
    this.greyBackground = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

@override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

@override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

      double adaptWidth(double value) {
      return (screenWidth / 411.4) * value;
    }

      double adaptHeight(double value) {
      return (screenHeight / 867.4) * value;
    }

    return ValueListenableBuilder<String?>(
      valueListenable: widget.errorMessage ?? ValueNotifier<String?>(null),
      builder: (context, error, child) {
        return GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: 
          Container(
            margin: EdgeInsets.fromLTRB(adaptWidth(38), 0, adaptWidth(37), 0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: adaptHeight(70),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.whiteBackground ? AppColors.white : widget.greyBackground ? AppColors.grey300.withOpacity(0.4) : AppColors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 1.0, color: AppColors.white),
                  ),
                  child: Row(
                    children: [
                      if (widget.iconPath != null) SizedBox(width: adaptWidth(23)),
                        Padding(
                          padding: EdgeInsets.only(left: widget.iconPath != null ? 0.0 : adaptWidth(20)),
                          child: Text(
                            widget.label,
                           style: GoogleFonts.roboto(
                              fontSize: adaptWidth(16),
                              color: widget.whiteBackground || widget.greyBackground ? AppColors.black : AppColors.white,
                              fontWeight: FontWeight.w300,
                              height: 1.2142857142857142,
                            ),
                            textHeightBehavior:
                                const TextHeightBehavior(applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: widget.controller,
                          obscureText: widget.obscureText,
                          validator: widget.validator,
                          style: TextStyle(
                            color: widget.whiteBackground || widget.greyBackground ? AppColors.black : AppColors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: adaptHeight(16),
                              horizontal: adaptWidth(10),
                            ),
                            suffixIcon: widget.iconPath != null
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                      widget.iconPath!,
                                      color: widget.whiteBackground || widget.greyBackground ? AppColors.black : AppColors.white,
                                    ),
                                  )
                                : null,
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
                    padding:  EdgeInsets.only(top: adaptHeight(8)),
                    child: Text(
                      error,
                      style: GoogleFonts.roboto(
                        fontSize: adaptWidth(14),
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

