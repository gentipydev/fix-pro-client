import 'dart:async';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:fit_pro_client/widgets/custom_shooting_icon_animation.dart';
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

class SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  String _statusText = 'Këtu mund të përdorni vendodhjen tuaj aktuale,\nose adresën se ku dëshironi që të kryhet puna';
  LatLng currentLocation = const LatLng(41.332918, 19.854820);
  LatLng taskerPosition = const LatLng(41.333688, 19.846087);
  BitmapDescriptor? currentLocationIcon;
  BitmapDescriptor? taskerIcon;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _onTaskAcceptedCalled = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _loadAndAddCurrentLocationMarker();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
  
  // Center the map on the current location
  void _centerMapOnMarker(LatLng location) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15.5,
          ),
        ),
      );
    }
  }

  // Trigger the animation and center the map on the marker
  void _useCurrentLocation() {
    final taskState = Provider.of<TaskStateProvider>(context, listen: false);

    taskState.setLocationSelected(true);
    taskState.setShowAnimation(true);

    setState(() {
      _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
    });

    // Center the map on the current location
    _centerMapOnMarker(currentLocation);

    // Wait for 10 seconds and then update the status and show profile container
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _statusText = "Urime! Ky profesionist ka pranuar punen tuaj\nJu mund ta pranoni punen direkt ose pasi keni pare profilin e tij mund ta pranoni apo refuzoni atë...";
      });

      taskState.setShowProfileContainer(true);
      taskState.setShowAnimation(false);

      // After the state change, create the route and start tasker movement
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final mapProvider = Provider.of<MapProvider>(context, listen: false);

        // Create route polyline and load tasker marker
        mapProvider.createRoute();
        _loadTaskerMarker();

        // Center the map to tasker’s position
        LatLng centerLocation = const LatLng(41.329046, 19.849708);
        _centerMapOnMarker(centerLocation);
      });
    });
  }

  // Search functionality (placeholder)
  void _searchNewLocation(String location) {
    logger.d('Searching for new location: $location');
  }

  Future<void> _loadTaskerMarker() async {
    // Load tasker icon
    final taskerIconLoaded = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(80, 80)),
      'assets/images/tasker3.png',
    );

    // Load default user location icon
    final currentLocationIconLoaded = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    );

    setState(() {
      taskerIcon = taskerIconLoaded;
      currentLocationIcon = currentLocationIconLoaded;

      // Update markers for both tasker and current location
      markers = {
        Marker(
          markerId: const MarkerId('taskerLocation'),
          position: taskerPosition,
          icon: taskerIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLocation,
          icon: currentLocationIcon!,
        ),
      };
    });
  }

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
          position: currentLocation,
          icon: currentLocationIcon!,
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isAccepted = Provider.of<TaskStateProvider>(context).isAccepted;

    if (isAccepted && !_onTaskAcceptedCalled) {
      _onTaskAccepted();
      _onTaskAcceptedCalled = true;
    }
  }

  void _onTaskAccepted() {
    _controller.forward().then((_) {
      setState(() {
        _statusText = "Profesionisti u pranua për të kryer punën\nJu mund ta kontaktoni atë direkt ose të prisni...";
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.reverse();
      });
    });
  }

@override
Widget build(BuildContext context) {
  final taskState = Provider.of<TaskStateProvider>(context);

  return Scaffold(
    body: Stack(
      children: [
        // Google Map Layer
        Positioned.fill(
          child: Consumer<MapProvider>(
            builder: (context, mapProvider, child) {
              return GoogleMap(
                padding: EdgeInsets.only(
                  top: 90,
                  bottom: taskState.showProfileContainer ? 250.h : 0,
                ),
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
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
        ),
        // Shooting Icons Animation
       if (!taskState.isLocationSelected)
        const Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ShootingIconsAnimation(),
          ),
        ),
        // Circular dot animation (optional)
        if (taskState.showAnimation)
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            _buildSearchSection(),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          bottom: taskState.showProfileContainer ? 0 : -400.h,
          child: _buildProfileContainer(),
        ),
      ],
    ),
  );
}


Widget _buildSearchSection() {
  final taskState = Provider.of<TaskStateProvider>(context);
  return SlideTransition(
      position: _slideAnimation,
      child: AnimatedContainer(
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
              opacity: taskState.isLocationSelected ? 0 : 1,
              child: taskState.isLocationSelected
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
              opacity: taskState.isLocationSelected ? 0 : 1,
              child: taskState.isLocationSelected
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: AppColors.grey700),
              SizedBox(width: 8.w),
              Text(
                'Rrethrrotullimi i Farkës, Tiranë',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16.sp,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Arben Gashi',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.grey700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.grey700,
                          fontWeight: FontWeight.w500,
                        ),
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
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskerProfileScreen(
                          ),
                        ),
                      );
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
