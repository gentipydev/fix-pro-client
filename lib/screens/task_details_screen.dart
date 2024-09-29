import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/screens/add_task_details_screen.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({
    required this.task,
    super.key,
  });

  @override
  TaskDetailsScreenState createState() => TaskDetailsScreenState();
}

class TaskDetailsScreenState extends State<TaskDetailsScreen> {
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
        final result = await Provider.of<MapProvider>(context, listen: false).fetchPastTaskRoute(userPosition, taskerPosition);

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
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=41.332733,19.855935');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _navigateToLocation() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=41.332733,19.855935&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Stack(children: [
                  SizedBox(
                    height: 220.h,
                    child: Consumer<MapProvider>(
                      builder: (context, mapProvider, child) {
                        return GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(41.3275, 19.8189),
                            zoom: 15.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                             mapProvider.loadMapStyle(context);
                            _setupMap(widget.task.taskerLocation, widget.task.userLocation, widget.task.bounds);
                          },
                          style: mapProvider.mapStyle,
                          polylines: polylines,
                          markers: markers,
                          zoomControlsEnabled: true,
                          scrollGesturesEnabled: true, 
                          zoomGesturesEnabled: true,
                          rotateGesturesEnabled: true,
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
                                TextButton(
                                  onPressed: () {
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
                                      fontWeight: FontWeight.w500,
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
                        'Detaje',
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
                      Text(
                        'Veglat Kryesore',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Profesionisti duhet te sjellë veglat e veta',
                        style: TextStyle(
                        fontSize: 14.sp, color: AppColors.grey700
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddTaskDetails(),
                            ),
                          );
                        },
                        child: Text(
                          'Shto detaje të tjera...',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.tomatoRed,
                            fontWeight: FontWeight.w500,
                          ),
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
