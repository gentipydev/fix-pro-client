import 'package:fit_pro_client/providers/login_validation_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomSimpleTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? iconPath;
  final bool obscureText;
  final bool greyBackground;
  final FormFieldValidator<String>? validator;
  final bool darkText;
  final bool showPassword;

  const CustomSimpleTextField({
    super.key,
    required this.label,
    required this.controller,
    this.iconPath,
    this.obscureText = false,
    this.greyBackground = false,
    this.validator,
    this.darkText = false,
    this.showPassword = false,
  });

  @override
  State<CustomSimpleTextField> createState() => _SimpleCustomSimpleTextFieldState();
}

class _SimpleCustomSimpleTextFieldState extends State<CustomSimpleTextField> {
  late FocusNode _focusNode;
  String? errorMessage;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _isPasswordVisible = !widget.obscureText;
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

    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(adaptWidth(16), 0, adaptWidth(16), 0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: adaptHeight(70),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.greyBackground
                    ? AppColors.grey300.withOpacity(0.3)
                    : AppColors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: AppColors.white),
              ),
              child: Row(
                children: [
                  if (widget.iconPath != null) SizedBox(width: adaptWidth(23)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.iconPath != null ? 0.0 : adaptWidth(20)),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: adaptWidth(16),
                        color:
                            widget.darkText ? AppColors.black : AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      showCursor: true,
                      cursorColor: AppColors.white,
                      validator: (value) {
                        LoginValidationProvider loginValidationProvider =
                            Provider.of<LoginValidationProvider>(context,
                                listen: false);

                        String? validationResult =
                            widget.validator?.call(value!);
                        if (validationResult != null) {
                          setState(() {
                            errorMessage = validationResult;
                          });

                          if (widget.label == "Email") {
                            loginValidationProvider.updateEmailValid(false);
                          } else if (widget.label == "Password") {
                            loginValidationProvider.updatePasswordValid(false);
                          }
                          return null;
                        }

                        // Update the provider's state for valid cases
                        if (widget.label == "Email") {
                          loginValidationProvider.updateEmailValid(true);
                        } else if (widget.label == "Password") {
                          loginValidationProvider.updatePasswordValid(true);
                        }
                        return null;
                      },
                      onChanged: (text) {
                        if (errorMessage != null) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
                      focusNode: _focusNode,
                      controller: widget.controller,
                      obscureText: widget.obscureText && !_isPasswordVisible,
                      style: TextStyle(
                        color: widget.darkText ? AppColors.black : AppColors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: errorMessage,
                        hintStyle: errorMessage != null
                            ? const TextStyle(
                                color: AppColors.tomatoRed,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: adaptHeight(16),
                          horizontal: adaptWidth(10),
                        ),
                        suffixIcon: widget.showPassword
                            ? IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              )
                            : (widget.iconPath != null
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(widget.iconPath!),
                                  )
                                : null),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}