import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentBottomSheet extends StatefulWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentBottomSheet({super.key, required this.onPaymentMethodSelected});

  @override
  PaymentBottomSheetState createState() => PaymentBottomSheetState();
}

class PaymentBottomSheetState extends State<PaymentBottomSheet> {
  String? selectedMethod = 'PayPal';

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
            isSelected: selectedMethod == 'PayPal',
            onTap: () {
              setState(() {
                selectedMethod = 'PayPal';
              });
              widget.onPaymentMethodSelected('PayPal');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: Icons.credit_card,
            methodName: 'Karta e Kreditit',
            isSelected: selectedMethod == 'Karta e Kreditit',
            onTap: () {
              setState(() {
                selectedMethod = 'Karta e Kreditit';
              });
              widget.onPaymentMethodSelected('Karta e Kreditit');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: FontAwesomeIcons.moneyCheckDollar,
            methodName: 'IBAN (Transfertë Bankare)',
            isSelected: selectedMethod == 'IBAN (Transfertë Bankare)',
            onTap: () {
              setState(() {
                selectedMethod = 'IBAN (Transfertë Bankare)';
              });
              widget.onPaymentMethodSelected('Transfertë Bankare');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20.h),
          _buildPaymentMethod(
            icon: FontAwesomeIcons.moneyBillWave,
            methodName: 'Cash',
            isSelected: selectedMethod == 'Cash',
            onTap: () {
              setState(() {
                selectedMethod = 'Cash';
              });
              widget.onPaymentMethodSelected('Cash');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String methodName,
    required bool isSelected,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.tomatoRed, size: 24.w),
            ],
          ),
        ),
      ),
    );
  }
}
