import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final mapProvider = Provider.of<MapProvider>(context, listen: false);
      // mapProvider.createRoute();
    });
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
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: const Text(
          'Detajet e punës',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
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
                            target: LatLng(41.333556, 19.849746),
                            zoom: 15.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapProvider.loadMapStyle(context);
                          },
                          style: mapProvider.mapStyle,
                          polylines: mapProvider.polylines,
                          markers: {
                            Marker(
                              markerId: const MarkerId('taskLocation'),
                              position: const LatLng(41.332918, 19.854820),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure),
                            ),
                            Marker(
                              markerId: const MarkerId('userLocation'),
                              position: const LatLng(41.333688, 19.846087),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                            ),
                          },
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
                      GestureDetector(
                        onTap: () {
                          // Add logic to open the big map here
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.grey),
                                    SizedBox(width: 8.w),
                                    Text(
                                      widget.task.taskArea!,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Rreth ${widget.task.taskPlaceDistance} km larg',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.grey300,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 36.sp,
                                      backgroundImage:
                                          AssetImage(widget.task.clientImage),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    widget.task.clientName,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.grey700),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.grey300,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: EdgeInsets.all(4.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.task.taskWorkGroup?.title}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.grey700,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Text(
                                              '${widget.task.taskWorkGroup?.feePerHour.round()} Lek',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.tomatoRed,
                                              ),
                                            ),
                                            Text(
                                              '/orë pune',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.grey700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: ExpandableFab(
                                phoneNumber: widget.task.clientPhoneNumber!),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        widget.task.title,
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
                      Text(
                        widget.task.taskDetails!,
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.grey700),
                      ),
                      SizedBox(height: 4.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        'Vlerësimi i punës',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.task.taskTimeEvaluation!,
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
                        widget.task.taskTools!,
                        style: TextStyle(
                        fontSize: 14.sp, color: AppColors.grey700
                        ),
                      ),
                      SizedBox(height: 4.h),
                      const Divider(color: AppColors.grey300, thickness: 0.5),
                      Text(
                        'Adresa ku do të kryhet puna',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.task.taskFullAddress!,
                        style: TextStyle(
                        fontSize: 14.sp, color: AppColors.grey700
                        ),
                      ),
                      SizedBox(height: 80.h),
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
