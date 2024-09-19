import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
  BitmapDescriptor? userIcon;


    @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  // Load the custom marker icon
  Future<void> _loadCustomMarker() async {
    userIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(38, 38)),
      'assets/images/tasker4.png',
    );

    setState(() {
      // Initialize markers after loading the custom icon
      markers = {
        Marker(
          markerId: const MarkerId('userLocation'),
          position: const LatLng(41.332918, 19.854820),
          icon: userIcon!,
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
                  Text(
                    'Këtu mund te përcaktoni zonën e vendodhjes së punës tuaj',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                    ),
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
                Consumer<MapProvider>(
                  builder: (context, mapProvider, child) {
                    return GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(41.332918, 19.854820),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
