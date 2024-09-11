import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/providers/taskers_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskerMapScreen extends StatefulWidget {
  const TaskerMapScreen({super.key});

  @override
  TaskerMapScreenState createState() => TaskerMapScreenState();
}

class TaskerMapScreenState extends State<TaskerMapScreen> {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  String? mapStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    final taskersProvider = Provider.of<TaskersProvider>(context, listen: false);
    
    for (final tasker in taskersProvider.taskers) {
      final customMarker = await taskersProvider.getAssetImageDescriptor(tasker.mapProfileImage);
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(tasker.fullName),
            position: tasker.location,
            icon: customMarker,
            onTap: () {
              _showTaskerInfoBottomSheet(tasker);
            },
            infoWindow: InfoWindow.noText,
            flat: true,
          ),
        );
      });
    }

    // Add a hardcoded user location marker in Tirana
    const LatLng userLocation = LatLng(41.3275, 19.899);
    final userLocationMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      flat: true,
    );

    setState(() {
      markers.add(userLocationMarker);
    });
  }


  Future<void> _navigateToLocation(Tasker tasker) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${tasker.location.latitude},${tasker.location.longitude}&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void _showTaskerInfoBottomSheet(Tasker tasker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.r,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(tasker.profileImage),
                    radius: 35.r,
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tasker.fullName,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey700,
                              ),
                            ),
                            Text(
                              '2000 Lek/Ore',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.tomatoRed,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${tasker.rating} (227 vleresime)',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '223 montime mobiliesh ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.tomatoRed,
                                ),
                              ),
                              TextSpan(
                                text: 'te perfunduara',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '447 pune ne total',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey700
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                tasker.bio,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskerProfileScreen(tasker: tasker),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.tomatoRed,
                        ),
                        icon: const Icon(Icons.person),
                        label: Text(
                          'Shiko profilin',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToLocation(tasker);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.tomatoRed,
                    ),
                    child: const Icon(Icons.directions), 
                  ),
                ]
              ),
            ],
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    final taskersProvider = Provider.of<TaskersProvider>(context);
    final taskers = taskersProvider.taskers;

    // Find central LatLng point
    final double averageLat = taskers.map((t) => t.location.latitude).reduce((a, b) => a + b) / taskers.length;
    final double averageLng = taskers.map((t) => t.location.longitude).reduce((a, b) => a + b) / taskers.length;
    final LatLng centralLocation = LatLng(averageLat, averageLng);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: const Text(
          'Zgjidh një punëtor',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: centralLocation,
              zoom: 11.5,
            ),
            style: mapStyle,
            onMapCreated: _onMapCreated,
            markers: markers,
            zoomControlsEnabled: false,
          ),
        ]
      ),
    );
  }
}
