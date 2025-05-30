import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/add_task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class ProfileContainer extends ConsumerStatefulWidget {
  final Tasker tasker;

  const ProfileContainer({super.key, required this.tasker});

  @override
  ProfileContainerState createState() => ProfileContainerState();
}

class ProfileContainerState extends ConsumerState<ProfileContainer> with TickerProviderStateMixin {
  Logger logger = Logger();
  late AnimationController _controller;
  Task? profileContainerAcceptedTask;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskStateProvider).taskState;

    // Trigger the animation when state changes to accepted
    if (taskState == TaskState.accepted) {
      _controller.forward();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.grey100, AppColors.grey300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: AppColors.grey700),
              SizedBox(width: 8.w),
              Expanded( 
                child: Text(
                  widget.tasker.taskerArea ?? '',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Rreth 0.4 km larg',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                          widget.tasker.fullName,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.military_tech,
                          color: AppColors.tomatoRed,
                          size: 28.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.tasker.rating.toString(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${widget.tasker.reviews.length} vlerësime)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Animated transition between two states
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 3),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: taskState == TaskState.profileView
                          ? SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset.zero,
                                end: const Offset(0, 1),
                              ).animate(_controller),
                              child: FadeTransition(
                                opacity: Tween<double>(
                                  begin: 1.0,
                                  end: 0.0,
                                ).animate(_controller),
                                child: GestureDetector(
                                  onTap: () async {
                                    Task? acceptedTask = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskerProfileScreen(tasker: widget.tasker),
                                      ),
                                    );

                                    if (acceptedTask != null) {
                                      logger.d("Task accepted: ${acceptedTask.id}");
                                      setState(() {
                                        profileContainerAcceptedTask = acceptedTask; // Save the accepted task
                                      });
                                    } else {
                                      logger.e("Task was not accepted");
                                    }
                                  },
                                  child: Text(
                                    'Shiko profilin',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: AppColors.tomatoRed,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -1),
                                end: Offset.zero,
                              ).animate(_controller),
                              child: FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(_controller),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTaskDetails(
                                          task: profileContainerAcceptedTask!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Shto detajet',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: AppColors.tomatoRed,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              ExpandableFab(
                phoneNumber: widget.tasker.contactInfo,
                onTaskAccepted: (Task task) {
                  setState(() {
                    profileContainerAcceptedTask = task;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
