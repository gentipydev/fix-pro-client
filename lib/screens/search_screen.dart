import 'dart:async';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart' as lottie;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  bool _showAnimation = false;
  bool _isLocationSelected = false;
  bool _showProfileContainer = false; 
  String _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
  final LatLng _currentLocation = const LatLng(41.333556, 19.849746);
  LatLng _taskerPosition = const LatLng(41.333688, 19.846087);
  BitmapDescriptor? currentLocationIcon;
  bool isAccepted = false;
  BitmapDescriptor? taskerIcon;
  bool isMoving = false;
  Timer? timer;
  int _currentPolylineIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAndAddCurrentLocationMarker();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final mapProvider = Provider.of<MapProvider>(context, listen: false);
    //   mapProvider.createRoute();
    //   _startTaskerMovement(mapProvider.polylines.first.points);
    // });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  // Load marker and add it to the map
  Future<void> _loadAndAddCurrentLocationMarker() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(80, 80)),
      'assets/images/tasker4.png',
    );

    setState(() {
      currentLocationIcon = icon;
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentLocation,
          icon: currentLocationIcon!,
        ),
      );
    });
  }
  
  // Center the map on the current location
  void _centerMapOnMarker() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: 15.5,
          ),
        ),
      );
    }
  }

  // Trigger the animation and center the map on the marker
  void _useCurrentLocation() {
    setState(() {
      _isLocationSelected = true;
      _showAnimation = true;

      // Ensure the map is centered when the animation starts
      _centerMapOnMarker();
    });

    // Wait for 10 seconds and then change the text and show the profile container
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _statusText = "Ky profesionist ka pranuar punen tuaj\nJu mund ta pranoni punen direkt ose pasi keni pare profilin e tij mund ta pranoni apo refuzoni ate...";
        _showProfileContainer = true;
        _showAnimation = false;
      });
    });
  }

  // Search functionality (placeholder)
  void _searchNewLocation(String location) {
    logger.d('Searching for new location: $location');
  }

  // This is going to be used when isAccepted is true 
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

  // Function to simulate tasker movement along the polyline
  void _startTaskerMovement(List<LatLng> polylinePoints) {
    if (isMoving) return; // Prevent multiple movements at the same time
    isMoving = true;

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_currentPolylineIndex < polylinePoints.length - 1) {
        setState(() {
          // Move to the next point in the polyline
          _currentPolylineIndex++;
          _taskerPosition = polylinePoints[_currentPolylineIndex];

          // Update the polyline by removing the traveled part
          final mapProvider = Provider.of<MapProvider>(context, listen: false);
          mapProvider.updatePolyline(polylinePoints.sublist(_currentPolylineIndex));

          // Update the tasker marker
          _updateTaskerMarker();
        });
      } else {
        timer.cancel();
        isMoving = false;
        // _showArrivalConfirmation(context);
      }
    });
  }

  // Function to update the tasker marker position with the preloaded custom image
  void _updateTaskerMarker() {
    setState(() {
      if (_taskerPosition == const LatLng(41.332918, 19.854820)) {
        markers = {
          Marker(
            markerId: const MarkerId('userLocation'),
            position: const LatLng(41.332918, 19.854820),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        };
      } else {
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
      }
    });
  }

  // Callback to handle when task is accepted
  void _onTaskAccepted() {
    setState(() {
      _statusText = "Profesionisti u pranua për të kryer punën\nJu mund ta kontaktoni atë direkt ose të prisni...";
      isAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              _buildSearchSection(),
              Expanded(
                child: Stack(
                  children: [
                    Consumer<MapProvider>(
                      builder: (context, mapProvider, child) {
                        return GoogleMap(
                          padding: EdgeInsets.only(bottom: _showProfileContainer ? 350.h : 0),
                          initialCameraPosition: CameraPosition(
                            target: _currentLocation,
                            zoom: 15.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            mapProvider.loadMapStyle(context);
                          },
                          style: mapProvider.mapStyle,
                          polylines: mapProvider.polylines,
                          markers: markers,
                          zoomControlsEnabled: false,
                        );
                      },
                    ),
                    if (_showAnimation)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.6,
                            child: ClipOval(
                              child: SizedBox(
                                height: 340.w,
                                width: 340.w,
                                child: lottie.Lottie.asset(
                                  'assets/animations/circular_dot_animation.json',
                                  repeat: true,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Animated Positioned Container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: _showProfileContainer ? 0 : -400.h, // Show or hide the container
            child: _buildProfileContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.tomatoRedLight, AppColors.tomatoRed],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusText,
              key: const ValueKey<String>('request_status'),
              style: GoogleFonts.roboto(
                color: AppColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          // Location input container sliding up
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isLocationSelected ? 0 : 1,
            child: _isLocationSelected
                ? const SizedBox() // Hide when location is selected
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.tomatoRed,
                          size: 22.sp,
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.grey700,
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: 'Kërkoni një vendodhje tjetër...',
                              hintStyle: TextStyle(color: AppColors.grey300, fontSize: 16.sp),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              _searchNewLocation(value);
                            },
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: AppColors.tomatoRed,
                          size: 22.sp,
                        ),
                      ],
                    ),
                  ),
          ),
          SizedBox(height: 20.h),
          // Use current location button sliding up
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isLocationSelected ? 0 : 1,
            child: _isLocationSelected
                ? const SizedBox()
                : GestureDetector(
                    onTap: _useCurrentLocation,
                    child: Column(
                      children: [
                        Text(
                          'Përdor Vendodhjen Aktuale',
                          style: GoogleFonts.roboto(
                            color: AppColors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.white,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Profile Container that pushes up the map
  Widget _buildProfileContainer() {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: AppColors.grey700),
                  SizedBox(width: 8.w),
                  Text(
                    'Rrethrrotullimi i Farkës, Tiranë',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp
                    ),
                  ),
                ],
              ),
              Text(
                'Rreth 0.7 km larg',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey700,
                ),
              ),
            ],
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
                          radius: 36.r,
                          backgroundImage: const AssetImage('assets/images/client3.png'),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Arben Gashi',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/taskerProfile');
                        },
                        child: Text(
                          'Shiko profilin',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.tomatoRed,
                            fontWeight: FontWeight.w500
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
              ExpandableFab(
                phoneNumber: '+355696443833',
                onAcceptTask: _onTaskAccepted
              ),
            ],
          ),
        ],
      ),
    );
  }
}
