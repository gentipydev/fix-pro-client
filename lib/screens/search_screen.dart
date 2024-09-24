import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/utils/fake_addresses.dart';
import 'package:fit_pro_client/widgets/custom_expandable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart' as lottie;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  Logger logger = Logger();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  String _statusText = 'Këtu mund të përdorni vendodhjen tuaj aktuale,\nose adresën se ku dëshironi që të kryhet puna';
  LatLng? currentLocation;
  LatLng? userAddressLocation;
  LatLng? taskerPosition;
  BitmapDescriptor? currentLocationIcon;
  BitmapDescriptor? taskerIcon;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _onTaskAcceptedCalled = false;
  List<String> _filteredAddresses = [];
  final TextEditingController searchController = TextEditingController();
  bool _mapInteractionDisabled = false;
  bool _isWaiting = false;
  bool _isAddressSelected = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero, 
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _getCurrentLocationAndInitializeMap();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    mapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Lifecycle observer to handle app resume
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isWaiting) {
      _restartWaitTimer(); 
    }
  }

  // Disable map gestures when needed
  void _toggleMapInteraction(bool disable) {
    setState(() {
      _mapInteractionDisabled = disable;
    });
  }

  // Trigger the animation and center the map on the marker
  Future<void> _useCurrentLocation() async {
    final taskState = Provider.of<TaskStateProvider>(context, listen: false);
    taskState.setLocationSelected(true);
    taskState.setShowAnimation(true);

    setState(() {
      _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
      _isWaiting = true;
    });

    _centerMapOnMarker(currentLocation!);
    _toggleMapInteraction(true); // Disable map gestures

    // Generate a fake tasker location near the current location
    LatLng fakeTaskerLocation = _generateFakeTaskerLocation(currentLocation!);

    // Start the 10-second countdown
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        _statusText = "Urime! Ky profesionist ka pranuar punen tuaj\nJu mund ta pranoni punen direkt ose pasi keni pare profilin e tij mund ta pranoni apo refuzoni atë...";
        _isWaiting = false;
      });

      // Fetch and draw the polyline between user and fake tasker location
      final mapProvider = Provider.of<MapProvider>(context, listen: false);
      mapProvider.fetchRouteFromOSRMApi(currentLocation!, fakeTaskerLocation);
      LatLng centralPoint = _findCentralPoint(currentLocation!, fakeTaskerLocation);

      taskState.setShowProfileContainer(true);
      taskState.setShowAnimation(false);
      _toggleMapInteraction(false); // Re-enable map gestures

      // Create the route and load tasker marker
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTaskerMarkerCurrentLocation(fakeTaskerLocation);

        // Center the map
        _centerMapOnMarker(centralPoint);
      });
    });
  }

  Future<void> _performSearch(String address) async {
    try {
      // Fetch LatLng for the provided address
      LatLng addressLocation = await Provider.of<MapProvider>(context, listen: false).getLatLngFromAddress(address);
      setState(() {
        userAddressLocation = addressLocation;
      });

      // Similar to _useCurrentLocation but using the searched location
      final taskState = Provider.of<TaskStateProvider>(context, listen: false);
      taskState.setLocationSelected(true);
      taskState.setShowAnimation(true);

      setState(() {
        _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
        _isWaiting = true;
      });

      // Center the map on the found location
      _centerMapOnMarker(addressLocation);
      _toggleMapInteraction(true); // Disable map gestures

      // Generate a fake tasker location near the current location
      LatLng fakeTaskerLocation = _generateFakeTaskerLocation(addressLocation);

      // Start the 10-second countdown
      Future.delayed(const Duration(seconds: 10), () {
        if (!mounted) return;
        setState(() {
          _statusText = "Urime! Ky profesionist ka pranuar punen tuaj\nJu mund ta pranoni punen direkt ose pasi keni pare profilin e tij mund ta pranoni apo refuzoni atë...";
          _isWaiting = false;
        });

        // Fetch and draw the polyline between user and fake tasker location
        final mapProvider = Provider.of<MapProvider>(context, listen: false);
        mapProvider.fetchRouteFromOSRMApi(addressLocation, fakeTaskerLocation);
        LatLng centralPoint = _findCentralPoint(addressLocation, fakeTaskerLocation);
        
        taskState.setShowProfileContainer(true);
        taskState.setShowAnimation(false);
        _toggleMapInteraction(false); // Re-enable map gestures

        // Create the route and load tasker marker
       WidgetsBinding.instance.addPostFrameCallback((_) {
          // Load the tasker marker
          _loadTaskerMarkerAddressLocation(fakeTaskerLocation);
          
          // Center the map on the central point
          _centerMapOnMarker(centralPoint);
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nuk u gjet vendodhja. Ju lutem provoni përsëri.'))
      );
    }
  }

  // Function to generate a fake tasker location near the current location
  LatLng _generateFakeTaskerLocation(LatLng currentLocation) {
    double offsetLat = 0.0027;

    double offsetLng = 0.0035;

    return LatLng(currentLocation.latitude + offsetLat, currentLocation.longitude + offsetLng);
  }

  // Function to find the midpoint between two LatLng objects
  LatLng _findCentralPoint(LatLng point1, LatLng point2) {
    double midLat = (point1.latitude + point2.latitude) / 2;
    double midLng = (point1.longitude + point2.longitude) / 2;

    return LatLng(midLat, midLng);
  }

  // Restart the 10-second countdown when the app resumes
  void _restartWaitTimer() {
    setState(() {
      _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
      _isWaiting = true;
    });
    _useCurrentLocation();
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

  void _searchNewLocation(String query) {
    logger.d('Searching for new location: $query');
    setState(() {
      _filteredAddresses = simplifiedAddresses.where((address) =>
              address.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _selectLocation(String address) {
    logger.d('Location selected: $address');
    setState(() {
      searchController.text = address;
      _isAddressSelected = true;
      _filteredAddresses.clear();
    });
  }

  Future<void> _loadTaskerMarkerCurrentLocation(LatLng taskerPosition) async {
    // Load tasker icon
    final taskerIconLoaded = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(90, 90)),
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
          position: currentLocation!,
          icon: currentLocationIcon!,
        ),
      };
    });
  }

  Future<void> _loadTaskerMarkerAddressLocation(LatLng taskerPosition) async {
    // Load tasker icon
    final taskerIconLoaded = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(90, 90)),
      'assets/images/tasker3.png',
    );

    // Load default user location icon
    final currentLocationIconLoaded = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
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
          position: userAddressLocation!,
          icon: currentLocationIcon!,
        ),
      };
    });
  }

  Future<void> _getCurrentLocationAndInitializeMap() async {
    try {
      // Get the current location from the phone's GPS
      LatLng currentPosition = await getCurrentLocation();

      // Update the map and marker for the current location
      final icon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(90, 90)),
        'assets/images/tasker4.png',
      );

      setState(() {
        currentLocation = currentPosition;
        currentLocationIcon = icon;

        // Update the camera position on the map
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLocation!,
              zoom: 15.5,
            ),
          ),
        );

        // Add marker for current location
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocation!,
            icon: currentLocationIcon!,
          ),
        );
      });
    } catch (e) {
      logger.e('Error getting current location: $e');
    }
  }

  // Function to get the current location of the user
  Future<LatLng> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location services are not enabled, throw an error
        throw Exception('Location services are disabled.');
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Permissions are denied, throw an error
        throw Exception('Location permissions are denied.');
      }
    }

    // Get the current location of the user
    locationData = await location.getLocation();

    // Return the current location as a LatLng object
    return LatLng(locationData.latitude!, locationData.longitude!);
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

  void _addAddressNotification(BuildContext context) {
    Flushbar(
      message: "Ju lutem vendosni nje adrese",
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.tomatoRed,
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(
        Icons.error,
        color: AppColors.white,
      ),
    ).show(context);
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          titlePadding: const EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jeni i sigurt që doni të largoheni?',
                style: TextStyle(
                  color: AppColors.grey700,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.warning,
                    size: 22,
                    color: AppColors.tomatoRed,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Kërkesa për punë do të anullohet menjëherë',
                      style: TextStyle(
                        color: AppColors.tomatoRed,
                        fontSize: 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.grey300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Jo',
                    style: TextStyle(
                      color: AppColors.grey700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.tomatoRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Cancel Task 
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text(
                    'Po, jam i sigurt',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  final taskState = Provider.of<TaskStateProvider>(context);

  return PopScope(
    canPop: false, // Prevent default back behavior
    onPopInvoked: (didPop) {
      final taskState = Provider.of<TaskStateProvider>(context, listen: false);

      if (taskState.isAccepted) {
        // If the task is accepted, allow the user to go back normally
        Navigator.of(context).pop(); 
      } else {
        // If the task is not accepted, show the custom cancel dialog
        _showCancelDialog(); 
      }
    },
    child: Scaffold(
      appBar: AppBar(),
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
                    target: currentLocation ?? const LatLng(41.3275, 19.8189),
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
                  scrollGesturesEnabled: !_mapInteractionDisabled, 
                  zoomGesturesEnabled: !_mapInteractionDisabled,
                  rotateGesturesEnabled: !_mapInteractionDisabled,
                );
              },
            ),
          ),
    
          if (taskState.showAnimation)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: ClipOval(
                        child: SizedBox(
                          height: 400.w,
                          width: 400.w,
                          child: lottie.Lottie.asset(
                            'assets/animations/circular_dot_animation.json',
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.3,
                      child: SizedBox(
                        height: 300.w,
                        width: 300.w,
                        child: lottie.Lottie.asset(
                          'assets/animations/radar_searching.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
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
                  ? const SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
			                  borderRadius: BorderRadius.circular(12.r),
                        gradient: const LinearGradient(
                          colors: [AppColors.white, AppColors.grey100],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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
                        children: [
                          // Search Input Field
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.tomatoRed,
                                  size: 24.sp,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    cursorColor: AppColors.grey700,
                                    style: TextStyle(fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: 'Kërkoni një vendodhje tjetër...',
                                      hintStyle: TextStyle(
                                        color: AppColors.grey300,
                                        fontSize: 16.sp,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w), 
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _isAddressSelected = false;  // Reset flag when user types
                                        if (value.isEmpty) {
                                          _filteredAddresses.clear();
                                        } else {
                                          _searchNewLocation(value);
                                        }
                                      });
                                    },
                                    onSubmitted: (value) {
                                      _searchNewLocation(value);
                                    },
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: () {
                                    if (_isAddressSelected) {
                                      _performSearch(searchController.text);
                                    } else {
                                      logger.d("heyyyy");
                                      _addAddressNotification(context);
                                    }
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: AppColors.tomatoRed,
                                    size: 32.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          
                          // Display filtered suggestions
                          if (_filteredAddresses.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SizedBox(
                                height: 200.h,
                                child: ListView.separated(
                                  itemCount: _filteredAddresses.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = _filteredAddresses[index];
                                    return ListTile(
                                      title: Text(
                                        suggestion,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onTap: () {
                                        _selectLocation(suggestion);
                                      },
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w), 
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: AppColors.grey100,
                                      thickness: 1.0,
                                      height: 1.0,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      )
                    ),
            ),
            SizedBox(height: 40.h),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '5',
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
