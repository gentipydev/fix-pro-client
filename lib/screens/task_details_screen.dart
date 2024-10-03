import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/screens/add_task_details_screen/add_task_details_screen.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final Task task;
  final bool isCurrentTask;

  const TaskDetailsScreen({
    required this.task,
    required this.isCurrentTask,
    super.key,
  });

  @override
  TaskDetailsScreenState createState() => TaskDetailsScreenState();
}

class TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};


  Future<void> _setupMap(LatLng taskerPosition, LatLng userPosition, LatLngBounds? bounds) async {
    try {
      // Load tasker icon with fallback
      BitmapDescriptor taskerIconLoaded;
      try {
        taskerIconLoaded = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(90, 90)),
          widget.task.tasker.mapProfileImage,
        );
      } catch (e) {
        logger.e("Error loading tasker icon: $e");
        taskerIconLoaded = BitmapDescriptor.defaultMarker;
      }

      // Load default user location icon
      final currentLocationIconLoaded = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

      // If bounds are not provided, fetch them using MapProvider
      LatLngBounds? effectiveBounds = bounds;
      if (effectiveBounds == null) {
        final result = await ref.read(mapStateProvider.notifier).fetchPastTaskRoute(userPosition, taskerPosition);

        if (result != null) {
          effectiveBounds = result['bounds'];
          widget.task.polylineCoordinates.clear();
          widget.task.polylineCoordinates.addAll(result['routeCoordinates']);
        }
      }

      final polyline = Polyline(
        polylineId: const PolylineId('taskRoute'),
        points: widget.task.polylineCoordinates,
        color: AppColors.black,
        width: 3,
      );

      setState(() {
        markers = {
          Marker(
            markerId: const MarkerId('taskerLocation'),
            position: taskerPosition,
            icon: taskerIconLoaded,
            anchor: const Offset(0.5, 0.5),
          ),
          Marker(
            markerId: const MarkerId('userLocation'),
            icon: currentLocationIconLoaded,
            position: userPosition,
          ),
        };

        polylines = {polyline};
      });

      if (mapController != null && effectiveBounds != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(effectiveBounds, 30),
        );
      }
    } catch (e) {
      logger.e("Error setting up map: $e");
    }
  }


  Future<void> _openGoogleMaps() async {
    final double userLat = widget.task.userLocation.latitude;
    final double userLng = widget.task.userLocation.longitude;

    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$userLat,$userLng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _navigateToLocation() async {
    final double userLat = widget.task.userLocation.latitude;
    final double userLng = widget.task.userLocation.longitude;
    final double taskerLat = widget.task.taskerLocation.latitude;
    final double taskerLng = widget.task.taskerLocation.longitude;

    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLng&destination=$taskerLat,$taskerLng&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = ref.watch(mapStateProvider);
    final mapStateNotifier = ref.read(mapStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Detajet e punës',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                  SizedBox(
                    height: 220.h,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(41.3275, 19.8189),
                            zoom: 15.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            mapStateNotifier.loadMapStyle(context);
                            _setupMap(widget.task.taskerLocation, widget.task.userLocation, widget.task.bounds);
                          },
                          style: mapProvider.mapStyle,
                          mapToolbarEnabled: false,
                          polylines: polylines,
                          markers: markers,
                          zoomControlsEnabled: false,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 1.h,
                    left: 70.w,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _navigateToLocation();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.tomatoRed,
                            backgroundColor: AppColors.white,
                            padding: EdgeInsets.all(4.w),
                            minimumSize: Size(30.w, 30.h),
                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            Icons.directions,
                            color: AppColors.tomatoRed,
                            size: 25.w,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _openGoogleMaps();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.tomatoRed,
                            backgroundColor: AppColors.white,
                            padding: EdgeInsets.all(4.w),
                            minimumSize: Size(30.w, 30.h),
                            shape: const CircleBorder(),
                          ),
                          child: Icon(
                            Icons.map,
                            color: AppColors.tomatoRed,
                            size: 25.w,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
                Padding(
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
                              widget.task.taskerArea!,
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
                        'Rreth ${widget.task.taskPlaceDistance!} km',
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
                                      widget.task.tasker.fullName,
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
                                      widget.task.tasker.rating.toString(),
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
                                      '(${widget.task.tasker.reviews.length} vlerësime)',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.grey700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskerProfileScreen(tasker: widget.task.tasker),
                                      ),
                                    );
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: SimpleExpandableFab(phoneNumber: widget.task.tasker.contactInfo),
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        widget.task.taskWorkGroup.title,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Përshkrimi i punës',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                    widget.task.taskDetails != null && widget.task.taskDetails!.isNotEmpty
                    ? Text(
                        widget.task.taskDetails!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey700,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.tomatoRed,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              'Ju lutem shtoni detaje në lidhje me punën më poshtë',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.tomatoRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        'Vlerësimi i punës',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Kjo pune vlerësohet sipas statistikave nga 1-2 orë',
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.grey700),
                      ),
                      SizedBox(height: 4.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      SizedBox(height: 4.h),
                      Text(
                        'Veglat Kryesore',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      widget.task.bringOwnTools 
                        ? Text(
                            'Profesionisti duhet te sjellë veglat e veta',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey700,
                            ),
                          )
                        : (widget.task.taskTools != null && widget.task.taskTools!.isNotEmpty)
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: widget.task.taskTools!.map((tool) {
                                    return Chip(
                                      label: Text(
                                        tool,
                                        style: const TextStyle(
                                          color: AppColors.grey700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: AppColors.tomatoRedLighter,
                                      deleteIcon: const Icon(Icons.close, size: 20),
                                      onDeleted: () {
                                        setState(() {
                                          widget.task.taskTools!.remove(tool);
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        side: BorderSide.none,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Text(
                                'Asnjë vegël nuk është zgjedhur',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.grey700,
                                ),
                              ),
                      SizedBox(height: 4.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        'Adresa e plotë ku do të kryhet puna',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.task.taskFullAddress!,
                        style: TextStyle(
                        fontSize: 14.sp, color: AppColors.grey700
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (widget.isCurrentTask) 
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTaskDetails(task: widget.task),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Shto detaje të tjera',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.tomatoRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.tomatoRed,
                                size: 26.sp, 
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 60.h),
                    ],
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
