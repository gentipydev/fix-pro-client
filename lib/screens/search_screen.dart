import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  bool isMoving = false;
  BitmapDescriptor? taskerIcon;
  final LatLng _taskerPosition = const LatLng(41.333688, 19.846087);

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).createRoute();
    });
  }

  Future<void> _navigateToLocation() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=41.332918,19.854820&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  // Load the custom marker icon
  Future<void> _loadCustomMarker() async {
    taskerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(38, 38)),
      'assets/icons/handyman.png',
    );

    setState(() {
      // Initialize markers after loading the custom icon
      markers = {
        Marker(
          markerId: const MarkerId('taskerLocation'),
          position: _taskerPosition,
          icon: taskerIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
        Marker(
          markerId: const MarkerId('userLocation'),
          position: const LatLng(41.332918, 19.854820),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Container(
              color: AppColors.tomatoRedLight,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Label
                  Column(
                    children: [
                      Text(
                        'Ky është profesionisti më afër zonës tuaj ne bazë te vendodhjes tuaj aktuale',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '* Nderkohë këtu mund te përcaktoni zonën e vendodhjes së punës tuaj, nëse ajo nuk përkon me vendodhjen tuaj aktuale',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Search TextField for Location Input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.tomatoRed,
                          size: 24.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.grey300,
                            decoration: InputDecoration(
                              hintText: 'Vendodhja e punës...',
                              hintStyle: TextStyle(color: AppColors.grey300, fontSize: 16.sp),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              // search functionality 
                            },
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: AppColors.tomatoRed,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
                children: [
                  SizedBox(
                    height: 300.h,
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
                          onPressed: _navigateToLocation,
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
                      ],
                    ),
                  ),
                ],
              ),
              Container(
              color: AppColors.grey100,
              padding: EdgeInsets.all(16.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.grey700),
                              SizedBox(width: 8.w),
                              Text(
                                'Rrethrrotullimi i Farkës, Tiranë',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Rreth 0.7 km larg',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      backgroundImage: const AssetImage('assets/images/client3.png'),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Arben Gashi',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.grey700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/taskerProfile');
                                    },
                                    child: Text(
                                      'Shiko profilin e plotë',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.tomatoRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 2.w,
                                right: 2.w,
                                child: Icon(
                                  Icons.military_tech,
                                  color: AppColors.tomatoRed,
                                  size: 28.sp,
                                ),
                              ),
                            ],
                          ),
                          const ExpandableFab(phoneNumber: '+355696443833'),
                        ],
                      ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
