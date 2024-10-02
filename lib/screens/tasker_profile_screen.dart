import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/providers/tasks_provider.dart';
import 'package:fit_pro_client/screens/search_screen/search_screen.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class TaskerProfileScreen extends ConsumerStatefulWidget {
  final Tasker tasker;

  const TaskerProfileScreen({super.key, required this.tasker});

  @override
  TaskerProfileScreenState createState() => TaskerProfileScreenState();
}

class TaskerProfileScreenState extends ConsumerState<TaskerProfileScreen> {
  Logger logger = Logger();
  bool isLoadingAccept = false; 
  bool isLoadingReject = false; 
  bool _showAllReviews = false;

  Future<Task?> _handleAcceptTask() async {
    setState(() {
      isLoadingAccept = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final tasksNotifier = ref.read(tasksProvider.notifier);
    final taskStateNotifier = ref.read(taskStateProvider.notifier);
    final mapStateNotifier = ref.read(mapStateProvider.notifier);
    final fakeData = FakeData();

    LatLng? userLocation = ref.read(taskStateProvider).currentSearchLocation;
    LatLng? taskerLocation = ref.read(taskStateProvider).taskerLocation;

    if (userLocation == null || taskerLocation == null) {
      logger.e("User or Tasker location is missing");
      setState(() {
        isLoadingAccept = false;
      });
      return null;
    }

    try {
      String taskerArea = await mapStateNotifier.getAddressFromLatLng(taskerLocation, isFullAddress: false);
      String taskFullAddress = await mapStateNotifier.getAddressFromLatLng(taskerLocation, isFullAddress: true);

      double taskerPlaceDistance = await mapStateNotifier.calculateDistance(userLocation, taskerLocation);
      double distanceInKm = taskerPlaceDistance / 1000;
      String formattedDistance = distanceInKm.toStringAsFixed(1);

      Tasker currentTasker = fakeData.fakeTaskers[ref.read(taskStateProvider).currentTaskerIndex];

      // Create the task and return it
      Task newTask = tasksNotifier.createTask(
        client: fakeData.fakeUser,
        tasker: currentTasker,
        userLocation: userLocation,
        taskerLocation: taskerLocation,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        taskWorkGroup: ref.read(taskStateProvider).selectedTaskGroup!,
        taskerArea: taskerArea,
        taskPlaceDistance: formattedDistance,
        taskFullAddress: taskFullAddress,
        taskDetails: '',
        paymentMethod: '',
        promoCode: '',
        taskEvaluation: '',
        taskTools: [],
        taskExtraDetails: '',
        userArea: '',
        status: TaskStatus.accepted,
      );

      setState(() {
        isLoadingAccept = false;
      });

      // Pop the current screen and return the task instance
      Navigator.pop(context, newTask);
      
      taskStateNotifier.setTaskState(TaskState.accepted);
      return newTask;
    } catch (e) {
      logger.e("Failed to fetch tasker area: $e");
      setState(() {
        isLoadingAccept = false;
      });
      return null;
    }
  }

  void _handleRejectTask() async {
    setState(() {
      isLoadingReject = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final taskStateNotifier = ref.read(taskStateProvider.notifier);
    final mapStateNotifier = ref.read(mapStateProvider.notifier);

    // Reset task and clear the map polylines
    taskStateNotifier.rejectTask();
    mapStateNotifier.clearPolylines();

    final fakeData = FakeData();
    taskStateNotifier.incrementTaskerIndex(fakeData.fakeTaskers.length);

    setState(() {
      isLoadingReject = false;
    });

    // Check whether the previous search was from the current position or an address
    final bool searchFromCurrentPosition = ref.read(taskStateProvider).searchFromCurrentPosition;
    final LatLng? currentSearchLocation = ref.read(taskStateProvider).currentSearchLocation;
    final String? searchedAddress = ref.read(taskStateProvider).searchedAddress;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchFromCurrentPosition: searchFromCurrentPosition,
          currentSearchLocation: currentSearchLocation,
          searchedAddress: searchedAddress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskStateProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h),
                _buildProfileSection(),
                _buildPresentationProfileSection(),
                _buildTasksSection(),
                _buildClientReviewsSection(),
                _buildScheduleSection(),
                SizedBox(height: 120.h),
              ],
            ),
          ),
          if (taskState.taskState == TaskState.profileView)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                color: AppColors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isLoadingAccept
                          ? null
                          : () async {
                              await _handleAcceptTask();
                            },
                      icon: isLoadingAccept
                          ? const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: SpinKitThreeBounce(
                                color: AppColors.tomatoRed,
                                size: 16.0,
                              ),
                            )
                          : const Icon(Icons.flash_on, color: AppColors.black),
                      label: isLoadingAccept
                          ? const SizedBox.shrink()
                          : Text(
                              'Pranoje për punë',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.black,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tomatoRed,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: isLoadingReject ? null : _handleRejectTask,
                      icon: isLoadingReject
                        ? const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: SpinKitThreeBounce(
                              color: AppColors.tomatoRed,
                              size: 16.0,
                            ),
                          )
                        : const Icon(Icons.close, color: AppColors.black),
                      label: isLoadingReject
                        ? const SizedBox.shrink()
                        : Text(
                            'Hiq dorë',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.black,
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey300,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Container(
            color: AppColors.tomatoRedLight,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ky është profesionisti me afër jush !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Zgjidhni atë per të kryer punën tuaj ose refuzo për të parë detajet e nje ofruesi tjetër...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
              CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.tasker.profileImage),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tasker.fullName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Profesionist me përvoja në fusha të ndryshme',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.verified, size: 20.w, color: AppColors.grey700),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Të gjitha shërbimet janë të garantuara',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Ju mund të kërkoni një shërbim tjetër ose rimbursim',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.build, size: 20.w, color: AppColors.grey700),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Ofron shërbime të riparimit në shtëpi',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresentationProfileSection() {
    return Container(
      color: AppColors.grey100,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  'assets/images/worker.jpg',
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.tomatoRed,
                  radius: 26.r,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: AppColors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.7),
                          builder: (context) => const VideoPlayerWidget(videoUrl: 'assets/videos/sample_video.mp4'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileDetail(Icons.star, '4.9', '48 vlerësime'),
              _buildProfileDetail(Icons.handyman, '350', 'punë të kryera'),
              _buildProfileDetail(null, '2.000 Lek', 'për orë pune'),
            ],
          ),
          SizedBox(height: 20.h),
          OutlinedButton(
            onPressed: () {
              // Handle button press
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 40.h),
              side: const BorderSide(color: AppColors.grey700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          child: Text(
              'Shtoje tek të preferuarit', 
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700
              )
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(Icons.whatshot, color: AppColors.tomatoRed, size: 16.w),
              SizedBox(width: 8.w),
              Text('Popullor', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 4.h),
          Text('2 punë te prenotuara ne 24 orët e fundit', style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.grey700, size: 16.w),
              SizedBox(width: 8.w),
              Text('Zakonisht përgjigjet brenda 1 minuti', style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rreth meje',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Jam shumë i përkushtuar për riparimet në shtëpi dhe mendoj se ju do të përfitoni një shërbim cilësor, një perspektivë të re për mirëmbajtjen e shtëpisë dhe një ambient më të sigurt e funksional.',
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Unë punoj',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildTaskChip('Riparim Dyer/Dritare', AppColors.tomatoRed.withOpacity(0.8)),
              _buildTaskChip('Instalim Pajisjesh të ndryshme', AppColors.tomatoRed.withOpacity(0.8)),
              _buildTaskChip('Lyerje Muresh', AppColors.tomatoRed.withOpacity(0.7)),
              _buildTaskChip('Montim Mobiliesh', AppColors.tomatoRed.withOpacity(0.6)),
              _buildTaskChip('Rregullime Hidraulike', AppColors.tomatoRed.withOpacity(0.6)),
              _buildTaskChip('Riparime Elektrike', AppColors.tomatoRed.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientReviewsSection() {
    return Container(
      color: AppColors.grey100,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Çfarë thonë klientët e mi',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                '5.0',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.tomatoRed, size: 24.w),
                      Icon(Icons.star, color: AppColors.tomatoRed, size: 24.w),
                      Icon(Icons.star, color: AppColors.tomatoRed, size: 24.w),
                      Icon(Icons.star, color: AppColors.tomatoRed, size: 24.w),
                      Icon(Icons.star, color: AppColors.tomatoRed, size: 24.w),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '3 vlerësime',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.grey700),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildRatingBar(5, 3),
          _buildRatingBar(4, 0),
          _buildRatingBar(3, 0),
          _buildRatingBar(2, 0),
          _buildRatingBar(1, 0),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          
          // Show the first two reviews always
          _buildReview(
            'Harriet',
            '27 Shkurt, 2023',
            'Jam shumë e kënaqur me riparimin e lavatriçes time! Gentiani ishte shumë profesionist dhe i saktë. Do ta rekomandoja patjetër!',
            'assets/images/client2.png',
          ),
          SizedBox(height: 16.h),
          _buildReview(
            'Aurora',
            '25 Janar, 2023',
            'Punëtor i mrekullueshëm! Ai e bëri montimin e mobilieve shumë të lehtë dhe i sqaroi të gjitha detajet në mënyrë të thjeshtë.',
            'assets/images/client4.png',
          ),
          
          if (_showAllReviews) ...[
            SizedBox(height: 16.h),
            _buildReview(
              'Bashkim',
              '12 Dhjetor, 2022',
              'Shërbim i shkëlqyer! Do të thërras patjetër përsëri për riparime të tjera. Shumë profesional dhe i sjellshëm.',
              'assets/images/client6.png',
            ),
          ],
          
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () {
              setState(() {
                _showAllReviews = !_showAllReviews;
              });
            },
            child: Text(
              _showAllReviews ? "Trego me pak..." : "Shiko te gjitha...",
              style: TextStyle(
                color: AppColors.tomatoRed,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disponibiliteti im',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // Handle back navigation
                },
              ),
              Text(
                'Aug 17–23',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // Handle forward navigation
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 2.h,
            color: AppColors.grey300,
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayColumn('Sat', 17, []),
                _buildDayColumn('Sun', 18, []),
                _buildDayColumn('Mon', 19, [
                  '16:00',
                  '17:00',
                  '18:00',
                  '19:00',
                ]),
                _buildDayColumn('Tue', 20, [
                  '09:00',
                  '11:00',
                  '18:00',
                  '19:00',
                ]),
                _buildDayColumn('Wed', 21, [
                  '09:00',
                  '11:00',
                  '13:00',
                  '14:00',
                ]),
                _buildDayColumn('Thu', 22, [
                  '09:00',
                  '11:00',
                  '12:00',
                  '13:00',
                ]),
                _buildDayColumn('Fri', 23, [
                  '17:00',
                  '18:00',
                  '19:00',
                  '20:00',
                ]),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              // Handle "View full schedule" action
            },
            child: Text(
              'Shiko disponibilitetin e plote',
              style: TextStyle(
                color: AppColors.tomatoRed,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskChip(String task, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        task,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, int reviewsCount) {
    return Row(
      children: [
        Text('$stars', style: TextStyle(fontSize: 16.sp)),
        Icon(Icons.star, color: AppColors.tomatoRed, size: 16.w),
        SizedBox(width: 8.w),
        Expanded(
          child: LinearProgressIndicator(
            value: reviewsCount / 3,
            backgroundColor: Colors.grey[300],
            color: AppColors.tomatoRed,
            minHeight: 8.h,
          ),
        ),
        SizedBox(width: 8.w),
        Text('($reviewsCount)', style: TextStyle(fontSize: 16.sp)),
      ],
    );
  }

  Widget _buildReview(String name, String date, String review, String imagePath) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.tomatoRed, size: 12.w),
                  Icon(Icons.star, color: AppColors.tomatoRed, size: 12.w),
                  Icon(Icons.star, color: AppColors.tomatoRed, size: 12.w),
                  Icon(Icons.star, color: AppColors.tomatoRed, size: 12.w),
                  Icon(Icons.star, color: AppColors.tomatoRed, size: 12.w),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                review,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayColumn(String day, int date, List<String> times) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            date.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Column(
            children: times.map((time) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(IconData? icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.black, size: 16.w),
              SizedBox(width: 4.w),
            ],
            Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.grey700)),
      ],
    );
  }
}
