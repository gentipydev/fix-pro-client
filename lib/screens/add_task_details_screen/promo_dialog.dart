import 'dart:ui';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoDialog extends StatefulWidget {
  final Function(String) onPromoCodeEntered;
  final String? selectedPromoCode;

  const PromoDialog({
    super.key,
    required this.onPromoCodeEntered,
    this.selectedPromoCode,
  });

  @override
  PromoDialogState createState() => PromoDialogState();
}

class PromoDialogState extends State<PromoDialog> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final TextEditingController _fourthController = TextEditingController();

  late FocusNode _firstNode;
  late FocusNode _secondNode;
  late FocusNode _thirdNode;
  late FocusNode _fourthNode;

  bool _isCodeValid = true;

  @override
  void initState() {
    super.initState();

    _firstNode = FocusNode();
    _secondNode = FocusNode();
    _thirdNode = FocusNode();
    _fourthNode = FocusNode();

    if (widget.selectedPromoCode != null && widget.selectedPromoCode!.length == 4) {
      _firstController.text = widget.selectedPromoCode![0];
      _secondController.text = widget.selectedPromoCode![1];
      _thirdController.text = widget.selectedPromoCode![2];
      _fourthController.text = widget.selectedPromoCode![3];
    }
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _firstNode.dispose();
    _secondNode.dispose();
    _thirdNode.dispose();
    _fourthNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fut kodin promocional',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.grey700,
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPromoSquare(_firstController, _firstNode, _secondNode),
                  _buildPromoSquare(_secondController, _secondNode, _thirdNode),
                  _buildPromoSquare(_thirdController, _thirdNode, _fourthNode),
                  _buildPromoSquare(_fourthController, _fourthNode, null),
                ],
              ),
              SizedBox(height: 10.h),

              if (!_isCodeValid)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Kodi nuk është i vlefshëm',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              SizedBox(height: 32.h),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomatoRed,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _applyPromoCode,
                child: Center(
                  child: Text(
                    'Apliko Kodin',
                    style: TextStyle(
                      fontSize: 18.sp, 
                      color: AppColors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoSquare(
    TextEditingController controller,
    FocusNode currentNode,
    FocusNode? nextNode,
  ) {
    return SizedBox(
      width: 50.w,
      child: StatefulBuilder(
        builder: (context, setState) {
          return TextField(
            controller: controller,
            focusNode: currentNode,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              color: AppColors.grey700,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: '', // Hide character counter
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.grey500, width: 2.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.tomatoRed, width: 2.w),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _isCodeValid = true;
              });
              if (value.isNotEmpty && nextNode != null) {
                nextNode.requestFocus();
              } else if (value.isNotEmpty && nextNode == null) {
                FocusScope.of(context).unfocus();
              }
            },
          );
        },
      ),
    );
  }

  void _applyPromoCode() {
    String promoCode = _firstController.text +
        _secondController.text +
        _thirdController.text +
        _fourthController.text;

    if (promoCode.length == 4) {
      if (promoCode == '5555') {
        widget.onPromoCodeEntered(promoCode);
        Navigator.pop(context);
      } else {
        setState(() {
          _isCodeValid = false;
        });
      }
    }
  }
}
