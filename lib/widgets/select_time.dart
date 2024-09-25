import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class SelectTime extends StatefulWidget {
  final DateTime? initialClientDate;
  final TimeOfDay? initialClientTime;
  final bool initialUseClientTime;

  const SelectTime({
    super.key,
    this.initialClientDate,
    this.initialClientTime,
    this.initialUseClientTime = true,
  });

  @override
  SelectTimeState createState() => SelectTimeState();
}

class SelectTimeState extends State<SelectTime> {
  Logger logger = Logger();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool useClientTime = true;
  DateTime? clientDate;
  TimeOfDay? clientTime;

  @override
  void initState() {
    super.initState();

    clientDate = widget.initialClientDate ?? DateTime.parse("2025-08-27");

    clientTime = widget.initialClientTime ?? const TimeOfDay(hour: 11, minute: 0);

    useClientTime = widget.initialUseClientTime;

    if (useClientTime) {
      _selectedDate = clientDate;
      _selectedTime = clientTime;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (useClientTime) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 0.8,
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.tomatoRed,
                onPrimary: Colors.white,
                surface: AppColors.white,
                onSurface: AppColors.grey700,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (useClientTime) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 0.8,
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.grey700,
                onPrimary: AppColors.white,
                surface: AppColors.white,
                onSurface: AppColors.grey700,
              ),
              timePickerTheme: const TimePickerThemeData(
                dialHandColor: AppColors.tomatoRed,
                hourMinuteTextColor: AppColors.tomatoRed,
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Info text visible only if using client time
        if (useClientTime) 
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info, 
                  size: 16,
                  color: AppColors.tomatoRed,
                ),
                SizedBox(width: 8),
                Text(
                  'Kjo është koha e punës më e afërt\nnë baze të disponibilitetit të profesionistit',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey700,
                  ),
                )
              ],
            ),
          ),
        SizedBox(height: 10.h),
        // Date Selector
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today, 
                color: AppColors.grey700,
                size: 20
              ),
              SizedBox(width: 8.w),
              Text(
                useClientTime
                    ? DateFormat.yMMMMEEEEd('sq').format(clientDate!)
                    : (_selectedDate != null
                        ? DateFormat.yMMMMEEEEd('sq').format(_selectedDate!)
                        : 'Zgjidhni datën'),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey700
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        // Time Selector
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time, 
                color: AppColors.grey700,
                size: 20
              ),
              SizedBox(width: 8.w),
              Text(
                useClientTime
                    ? clientTime!.format(context)
                    : (_selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Zgjidhni orën'),
                  style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey700
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        TextButton(
          onPressed: () {
            setState(() {
              useClientTime = !useClientTime; 
              if (useClientTime) {
                _selectedDate = clientDate;
                _selectedTime = clientTime;
              } else {
                _selectedDate = null;
                _selectedTime = null;
              }
            });
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Text(
            useClientTime ? 'Propozoni kohën tuaj të punës' : 'Rikthehu tek disponibiliteti i profesionistit',
            style: useClientTime 
              ? TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.tomatoRed,
                )
              : TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey500,
                ),
          ),
        ),
      ],
    );
  }
}
