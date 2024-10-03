import 'package:fit_pro_client/screens/add_task_details_screen/payments_bottom_sheet.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/promo_dialog.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_pro_client/models/task.dart';
import 'package:logger/logger.dart';

class PaymentSection extends StatefulWidget {
  final Task task;

  const PaymentSection({
    super.key,
    required this.task,
  });

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  Logger logger = Logger();
  String? selectedPaymentMethod;
  String? selectedPromoCode;

  @override
  void initState() {
    super.initState();

    selectedPaymentMethod = widget.task.paymentMethod ?? 'Shto mënyrën e pagesës';
    selectedPromoCode = widget.task.promoCode ?? 'Shto kodin promocional';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       ListTile(
          title: Text(
            'Pagesa',
            style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700,
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                builder: (context) => PaymentBottomSheet(
                  selectedMethod: widget.task.paymentMethod,
                  onPaymentMethodSelected: (method) {
                    setState(() {
                      selectedPaymentMethod = method;
                      widget.task.paymentMethod = method;
                    });
                  },
                ),
              );
            },
            child: Text(
              selectedPaymentMethod!,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.tomatoRed,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Promo',
            style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.task.promoCode != null) ...[
                Text(
                  'Promo aplikuar: 20%', 
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.mintGreen,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_downward,
                  color: AppColors.mintGreen,
                  size: 24.w,
                ),
              ],
              if (widget.task.promoCode == null) ...[
                Text(
                  'Shto kodin promocional',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.tomatoRed,
                  ),
                ),
              ],
            ],
          ),
           onTap: widget.task.promoCode == null ? () {
            showDialog(
              context: context,
              builder: (BuildContext context) => PromoDialog(
                selectedPromoCode: widget.task.promoCode,
                onPromoCodeEntered: (promoCode) {
                  setState(() {
                    selectedPromoCode = promoCode;
                    widget.task.promoCode = promoCode;
                  });
                },
              ),
            );
          } : null,
        ),
        ListTile(
          title: Text(
            'Tarifa për orë',
            style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700
            ),
          ),
          trailing: Text(
            '${widget.task.tasker.skills.first.taskGroup.feePerHour.round()} lek/orë pune',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.grey700
              ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Ju mund të shihni një detyrim të përkohshëm në shumën prej 2.000 lekë. Por mos u shqetësoni -- pagesa do të bëhet vetëm kur puna juaj të përfundojë!',
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.grey700,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.tomatoRed,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Nëse anulloni punë tuaj brenda 4 orëve para kohës së caktuar, ne mund t\'ju tarifojmë një penalitet anullimi prej një ore sipas tarifes përkatëse te profesionistit',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
