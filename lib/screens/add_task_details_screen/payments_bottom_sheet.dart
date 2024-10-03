import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentBottomSheet extends StatefulWidget {
  final Function(String) onPaymentMethodSelected;
  final String? selectedMethod;

  const PaymentBottomSheet({
    super.key,
    required this.onPaymentMethodSelected,
    this.selectedMethod,
  });

  @override
  PaymentBottomSheetState createState() => PaymentBottomSheetState();
}

class PaymentBottomSheetState extends State<PaymentBottomSheet> {
  String? selectedMethod;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.selectedMethod ?? 'Cash';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          _buildPaymentMethod(
            icon: FontAwesomeIcons.paypal,
            methodName: 'PayPal',
            method: 'PayPal',
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: FontAwesomeIcons.creditCard,
            methodName: 'Karta e Kreditit',
            method: 'Karta e Kreditit',
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: FontAwesomeIcons.moneyCheckDollar,
            methodName: 'Transfertë Bankare',
            method: 'Transfertë Bankare',
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: FontAwesomeIcons.moneyBillWave,
            methodName: 'Cash',
            method: 'Cash',
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String methodName,
    required String method,
  }) {
    return GestureDetector(
      onTap: () => _selectPaymentMethod(method),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(icon, size: 24.w, color: AppColors.tomatoRed),
              SizedBox(width: 16.w),
              Text(
                methodName,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey700,
                ),
              ),
              const Spacer(),
              if (selectedMethod == method)
                Icon(Icons.check_circle, color: AppColors.tomatoRed, size: 24.w),
            ],
          ),
        ),
      ),
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
    widget.onPaymentMethodSelected(method);
    Navigator.pop(context);
  }
}
