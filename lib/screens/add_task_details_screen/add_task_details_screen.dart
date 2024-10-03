import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/detail_section.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/payment_section.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/select_time_section.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/tools_suggestion_section.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

class AddTaskDetails extends ConsumerStatefulWidget {
  final Task task;

  const AddTaskDetails({super.key, required this.task});

  @override
  ConsumerState<AddTaskDetails> createState() => _AddTaskDetailsState();
}

class _AddTaskDetailsState extends ConsumerState<AddTaskDetails> {
  Logger logger = Logger();
  final TextEditingController _detailsController = TextEditingController();
  String? selectedPaymentMethod = 'Shto mënyrën e pagesës';

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Rishiko dhe konfirmo',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.white, AppColors.grey100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Lottie.asset(
                          'assets/animations/credit_card_payment.json',
                          repeat: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Mos u shqetësoni, ju do të paguani vetëm\nne përfundim te punës',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.task.taskWorkGroup.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.grey300,
                            width: 3.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(widget.task.tasker.profileImage),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            const SelectTime(),
            Divider(color: AppColors.grey300, thickness: 1.w),

            PaymentSection(task: widget.task),
            SizedBox(height: 20.h),
            
            DetailsSection(
              detailsController: _detailsController,
              initialDetails: widget.task.taskDetails
            ),
            SizedBox(height: 10.h),

            ToolSuggestionSection(task: widget.task),
            SizedBox(height: 80.h),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tomatoRed,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            _saveTaskDetails();
          },
          child: Text(
            'Ruaj Detajet e Punës',
            style: TextStyle(fontSize: 18.sp, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  void _saveTaskDetails() {
    String newDetails = _detailsController.text;

    widget.task.taskDetails = newDetails.isNotEmpty ? newDetails : null;

    final taskStateNotifier = ref.read(taskStateProvider.notifier);
    final mapStateNotifier = ref.read(mapStateProvider.notifier);

    taskStateNotifier.resetTask();
    mapStateNotifier.clearPolylines();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen(initialIndex: 1)),
      (Route<dynamic> route) => false,
    );
  }
}
