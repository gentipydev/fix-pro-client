import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class SelectTime extends StatefulWidget {
  final Task task;

  const SelectTime({
    super.key,
    required this.task,
  });

  @override
  SelectTimeState createState() => SelectTimeState();
}

class SelectTimeState extends State<SelectTime> {
  Logger logger = Logger();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool usetaskerTime = true;
  DateTime? taskerDate;
  TimeOfDay? taskerTime;

  @override
  void initState() {
    super.initState();

    // Set initial taskerDate and taskerTime, 1 day after the task creation
    widget.task.scheduledDate = widget.task.date.add(const Duration(days: 1));
    widget.task.scheduledTime = widget.task.time;

    // Initialize taskerDate and taskerTime from scheduled values
    taskerDate = widget.task.scheduledDate;
    taskerTime = widget.task.scheduledTime;

    // Set the selected values if usetaskerTime is true
    if (usetaskerTime) {
      _selectedDate = taskerDate;
      _selectedTime = taskerTime;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (usetaskerTime) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
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
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.task.scheduledDate = _selectedDate; // Update the task's scheduled date
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (usetaskerTime) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
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
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        widget.task.scheduledTime = _selectedTime; // Update the task's scheduled time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Info text visible only if using tasker time
        if (usetaskerTime)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  size: 20,
                  color: AppColors.tomatoRed,
                ),
                SizedBox(width: 8),
                Text(
                  'Kjo është koha e punës më e afërt\nnë baze të disponibilitetit të profesionistit',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey700,
                  ),
                )
              ],
            ),
          ),
        SizedBox(height: 20.h),

        // Date Selector
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.grey700,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                usetaskerTime
                    ? DateFormat.yMMMMEEEEd('sq').format(taskerDate!)
                    : (_selectedDate != null
                        ? DateFormat.yMMMMEEEEd('sq').format(_selectedDate!)
                        : 'Zgjidhni datën'),
                style: TextStyle(fontSize: 16.sp, color: AppColors.grey700),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),

        // Time Selector
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.grey700,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                usetaskerTime
                    ? taskerTime!.format(context)
                    : (_selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Zgjidhni orën'),
                style: TextStyle(fontSize: 16.sp, color: AppColors.grey700),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Toggle between tasker's time and custom time
        TextButton(
          onPressed: () {
            setState(() {
              usetaskerTime = !usetaskerTime;
              if (usetaskerTime) {
                // Revert to tasker's time
                _selectedDate = taskerDate;
                _selectedTime = taskerTime;
                widget.task.scheduledDate = taskerDate;
                widget.task.scheduledTime = taskerTime;
              } else {
                // Clear selected date and time
                _selectedDate = null;
                _selectedTime = null;
              }
            });
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Text(
            usetaskerTime
                ? 'Propozoni kohën tuaj të punës'
                : 'Rikthehu tek disponibiliteti i profesionistit',
            style: usetaskerTime
                ? TextStyle(fontSize: 16.sp, color: AppColors.tomatoRed)
                : TextStyle(fontSize: 16.sp, color: AppColors.grey500),
          ),
        ),
      ],
    );
  }
}
