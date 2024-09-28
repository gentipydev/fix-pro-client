import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/screens/add_task_details_screen.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  ProfileContainerState createState() => ProfileContainerState();
}

class ProfileContainerState extends State<ProfileContainer> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds transition
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskStateProvider>(context).taskState;
    final FakeData fakeData = FakeData();
    final Tasker firstTasker = fakeData.fakeTaskers[0];

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
                  'Rrethrrotullimi i Farkës, Tiranë',
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
            'Rreth 0.7 km larg',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey700,
            ),
          ),
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
                          'Arben G.',
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
                          '5',
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
                          '(3 vlerësime)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),

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
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskerProfileScreen(tasker: firstTasker),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Shiko profilin',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: AppColors.tomatoRed,
                                      fontWeight: FontWeight.w500,
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
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddTaskDetails(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Shto detajet',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: AppColors.tomatoRed,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const ExpandableFab(
                phoneNumber: '+355696443833',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
