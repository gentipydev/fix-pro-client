import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/providers/tasks_provider.dart';
import 'package:fit_pro_client/services/communication_service.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

class ExpandableFab extends ConsumerStatefulWidget {
  final String phoneNumber;
  final Function(Task task) onTaskAccepted;

  const ExpandableFab({
    super.key,
    required this.phoneNumber,
    required this.onTaskAccepted,
  });

  @override
  ExpandableFabState createState() => ExpandableFabState();
}

class ExpandableFabState extends ConsumerState<ExpandableFab> with SingleTickerProviderStateMixin {
  Logger logger = Logger();
  late AnimationController animationController;
  late Animation rotationAnimation;
  late Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  bool isExpanded = false;
  bool isLoading = false;

  final CommunicationService _communicationService = CommunicationService();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  // Handle expanding the FAB to show more actions
  void _onContactPressed() {
    setState(() {
      isExpanded = !isExpanded;

      // If expanded, start the animation
      if (isExpanded) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  double getRadiansFromDegree(double degree) {
    const double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskStateProvider).taskState;

    return Container(
      color: Colors.transparent,
      width: 190.w,
      height: 190.h,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 30.w,
            bottom: 30.h,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    height: 200.h,
                    width: 180.w,
                  ),
                ),
                // Show expanded buttons only when expanded
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 36.w,
                      height: 36.h,
                      content: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _communicationService.makePhoneCall(widget.phoneNumber);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225), degTwoTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 36.w,
                      height: 36.h,
                      content: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendAnSMS("", [widget.phoneNumber]);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180), degThreeTranslationAnimation.value * 100),
                    child: CircularButton(
                      color: AppColors.tomatoRed,
                      width: 36.w,
                      height: 36.h,
                      content: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendWhatsAppMessage("", widget.phoneNumber);
                      },
                    ),
                  ),
                Transform(
                  transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                  alignment: Alignment.center,
                  child: CircularButton(
                    color: AppColors.tomatoRed,
                    width: 80.w,
                    height: 80.h,
                    content: isLoading
                        ? Lottie.asset(
                            'assets/animations/loading_round.json',
                            repeat: false,
                            animate: true,
                          )
                        : Text(
                            taskState == TaskState.accepted ? "Kontakto" : "Prano",
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                onClick: taskState == TaskState.accepted
                    ? _onContactPressed
                    : () async {
                        // Set task state to accepted
                        ref.read(taskStateProvider.notifier).setTaskState(TaskState.accepted);

                        // Start loading
                        setState(() {
                          isLoading = true;
                        });

                        // Fetch required providers and data
                            // Fetch providers and data using ref.read
                            final mapProvider = ref.read(mapStateProvider.notifier);
                            final taskStateData = ref.read(taskStateProvider);
                            final tasksNotifier = ref.read(tasksProvider.notifier);
                            final fakeData = FakeData();

                        LatLng? userLocation = taskStateData.currentSearchLocation;
                        LatLng? taskerLocation = taskStateData.taskerLocation;

                        if (userLocation == null || taskerLocation == null) {
                          logger.e("User or Tasker location is missing");
                          setState(() {
                            isLoading = false; // Stop loading in case of missing locations
                          });
                          return;
                        }
                        // imitating the network request
                        await Future.delayed(const Duration(milliseconds: 800));

                        try {
                          String taskerArea = await mapProvider.getAddressFromLatLng(taskerLocation, isFullAddress: false);
                          String taskFullAddress = await mapProvider.getAddressFromLatLng(taskerLocation, isFullAddress: true);
                          double taskerPlaceDistance = await mapProvider.calculateDistance(userLocation, taskerLocation);
                          double distanceInKm = taskerPlaceDistance / 1000;
                          String formattedDistance = distanceInKm.toStringAsFixed(1);

                          Tasker currentTasker = fakeData.fakeTaskers[taskStateData.currentTaskerIndex];
                          logger.d("selectedTaskGroup: ${taskStateData.selectedTaskGroup}");

                          Task newTask = tasksNotifier.createTask(
                            client: fakeData.fakeUser,
                            tasker: currentTasker,
                            userLocation: userLocation,
                            taskerLocation: taskerLocation,
                            date: DateTime.now(),
                            time: TimeOfDay.now(),
                            taskWorkGroup: taskStateData.selectedTaskGroup!,
                            taskerArea: taskerArea,
                            taskPlaceDistance: formattedDistance,
                            taskFullAddress: taskFullAddress,
                            status: TaskStatus.accepted,
                          );

                          widget.onTaskAccepted(newTask);
                        } catch (e) {
                          logger.e("Failed to fetch tasker area: $e");
                        }

                        // Stop loading after task creation
                        setState(() {
                          isLoading = false;
                        });
                    },
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CircularButton component to handle loading state
class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget content;
  final Function onClick;
  final bool isLoading;

  const CircularButton({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.content,
    required this.onClick,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!isLoading)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.5), color],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            width: width,
            height: height,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                onClick();
              },
              child: Center(child: content),
            ),
          ),
        // Display Lottie animation if loading
        if (isLoading)
          SizedBox(
            width: width,
            height: height,
            child: Transform.scale(
              scale: 1.5,
              child: content,
            ),
          ),
      ],
    );
  }
}



class SimpleExpandableFab extends StatefulWidget {
  final String phoneNumber;
  const SimpleExpandableFab({super.key, required this.phoneNumber});

  @override
  SimpleExpandableFabState createState() => SimpleExpandableFabState();
}

class SimpleExpandableFabState extends State<SimpleExpandableFab> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  late Animation rotationAnimation;

  final CommunicationService _communicationService = CommunicationService();

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 200.w,
      height: 200.h,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 30.w,
            bottom: 30.h,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    height: 200.h,
                    width: 180.w,
                  ),
                ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                    child: SimpleCircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onClick: () {
                        _communicationService.makePhoneCall(widget.phoneNumber);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225), degTwoTranslationAnimation.value * 100),
                    child: SimpleCircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendAnSMS("", [widget.phoneNumber]);
                      },
                    ),
                  ),
                if (animationController.value > 0)
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180), degThreeTranslationAnimation.value * 100),
                    child: SimpleCircularButton(
                      color: AppColors.tomatoRed,
                      width: 40.w,
                      height: 40.h,
                      content: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.white,
                        size: 20.w,
                      ),
                      onClick: () {
                        _communicationService.sendWhatsAppMessage("", widget.phoneNumber);
                      },
                    ),
                  ),
                Transform(
                  transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                  alignment: Alignment.center,
                  child: SimpleCircularButton(
                    color: AppColors.grey300,
                    width: 80.w,
                    height: 80.h,
                    content: Text(
                      "Kontakto",
                      style: TextStyle(
                        color: AppColors.tomatoRed,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onClick: () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleCircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget content;
  final Function onClick;

  const SimpleCircularButton({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.content,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onClick();
        },
        child: Center(child: content),
      ),
    );
  }
}

