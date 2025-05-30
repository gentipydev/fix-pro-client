import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/screens/search_screen/cancel_task_dialog.dart';
import 'package:fit_pro_client/screens/search_screen/profile_container.dart';
import 'package:fit_pro_client/screens/search_screen/search_section.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart' as lottie;

class SearchScreen extends ConsumerStatefulWidget {
  final bool? searchFromCurrentPosition;
  final LatLng? currentSearchLocation;
  final String? searchedAddress;

  const SearchScreen({
    super.key,
    this.searchFromCurrentPosition,
    this.currentSearchLocation,
    this.searchedAddress,
  });

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
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
  Tasker? _currentTasker;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchFromCurrentPosition ?? true) {
        if (widget.currentSearchLocation != null) {
          _getCurrentLocationAndInitializeMap();
          _performSearch(searchFromCurrentPosition: true);
        } else {
          _getCurrentLocationAndInitializeMap();
        }
      } 
      else if (widget.searchedAddress != null && widget.searchedAddress!.isNotEmpty) {
        _performSearch(searchFromCurrentPosition: false, address: widget.searchedAddress);
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    mapController?.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isWaiting) {
      _restartWaitTimer(); 
    }
  }

  void _toggleMapInteraction(bool disable) {
    setState(() {
      _mapInteractionDisabled = disable;
    });
  }

  Future<void> _performSearch({
    bool searchFromCurrentPosition = true,
    String? address,
  }) async {
    LatLng? targetLocation;

    final taskStateNotifier = ref.read(taskStateProvider.notifier);
    final mapStateNotifier = ref.read(mapStateProvider.notifier);
    
    // Determine the target location based on search mode
    if (searchFromCurrentPosition) {
      // Use the current location or fetch it from task state if unavailable
      targetLocation = currentLocation ?? ref.read(taskStateProvider).currentSearchLocation;

      // Update task state with the location search details
      taskStateNotifier.setSearchDetails(
        fromCurrentPosition: true,
        currentPosition: targetLocation,
      );
    } else {
      // Handle address search case
      if (address == null || address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ju lutem shkruani një adresë të vlefshme')),
        );
        return;
      }

      try {
        // Fetch LatLng for the provided address
        targetLocation = await mapStateNotifier.getLatLngFromAddress(address);
        setState(() {
          userAddressLocation = targetLocation;
        });

        // Update task state with the address search details
        taskStateNotifier.setSearchDetails(
          fromCurrentPosition: false,
          currentPosition: targetLocation,
          address: address,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuk u gjet vendodhja. Ju lutem provoni përsëri')),
        );
        return;
      }
    }

    // Proceed with the next steps if the target location is available
    if (targetLocation != null) {
      taskStateNotifier.setTaskState(TaskState.searching);

      // Update the UI immediately with search status
      setState(() {
        _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
        _isWaiting = true;
      });

      // Center the map on the selected location
      _centerMapOnMarker(targetLocation);
      _toggleMapInteraction(true); // Disable map gestures during search

      // Generate a fake tasker location near the target location
      LatLng fakeTaskerLocation = _generateFakeTaskerLocation(targetLocation);
      taskStateNotifier.setTaskerLocation(fakeTaskerLocation);

        // Delete the current location marker
        Future.delayed(const Duration(seconds: 8)).then((_) {
        if (mounted) {
          setState(() {
            markers.clear();
          });
        }
      });

      // Start the 10-second countdown for tasker response
      await Future.delayed(const Duration(seconds: 10));

      // If the widget is still mounted, proceed with tasker assignment
      if (!mounted) return;

      // Fetch the tasker based on the current index
      final fakeData = FakeData();
      final currentTaskerIndex = ref.read(taskStateProvider).currentTaskerIndex;
      final tasker = fakeData.fakeTaskers[currentTaskerIndex];

      try {
        // Fetch tasker's area and route concurrently
        final taskerAreaFuture = mapStateNotifier.getAddressFromLatLng(fakeTaskerLocation, isFullAddress: false);
        final routeBoundsFuture = mapStateNotifier.fetchRoute(targetLocation, fakeTaskerLocation);

        // Await both operations
        final taskerArea = await taskerAreaFuture;
        final bounds = await routeBoundsFuture;

        // If the widget is still mounted, update the UI
        if (mounted) {
          setState(() {
            _currentTasker = tasker;
            _currentTasker?.taskerArea = taskerArea;

            _statusText = "Urime! Ky profesionist ka pranuar punen tuaj\n"
                          "Ju mund ta pranoni punen direkt ose pasi keni pare profilin e tij mund ta pranoni apo refuzoni atë...";
            _isWaiting = false;

            // Enable map gestures again
            _toggleMapInteraction(false);
          });

          // Update task state to "profileView"
          taskStateNotifier.setTaskState(TaskState.profileView);

          // Update the map with the tasker marker and animate to the bounds
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadTaskerMarker(fakeTaskerLocation, useCurrentLocation: searchFromCurrentPosition);

            if (bounds != null) {
              _animateCameraToBounds(bounds);
            }
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error occurred while fetching tasker details. Please try again.')),
        );
      }
    }
  }

  void _animateCameraToBounds(LatLngBounds? bounds) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds!, 50),
      );
    }
  }

  LatLng _generateFakeTaskerLocation(LatLng currentLocation) {
    double offsetLat = 0.0027;

    double offsetLng = 0.0035;

    return LatLng(currentLocation.latitude + offsetLat, currentLocation.longitude + offsetLng);
  }

  void _restartWaitTimer() {
    setState(() {
      _statusText = 'Kërkesa i është dërguar profesionistit më të afërt\nJu lutem prisni konfirmimin nga ana e tij...';
      _isWaiting = true;
    });
    _performSearch();
  }

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

  void _searchNewLocation(String query) async {
    // Access mapStateNotifier using ref.read to trigger actions
    final mapStateNotifier = ref.read(mapStateProvider.notifier);
    
    if (query.isNotEmpty) {
      // Fetch suggestions from the Google Places API via the mapStateNotifier
      await mapStateNotifier.fetchAddresses(query);

      setState(() {
        // Update filtered addresses with the latest fetched addresses from the state
        _filteredAddresses = ref.read(mapStateProvider).fetchedAddresses;
      });
    } else {
      // Clear suggestions if the search input is empty
      setState(() {
        _filteredAddresses.clear();
      });
    }
  }

  void _selectLocation(String address) {
    setState(() {
      searchController.text = address;
      _isAddressSelected = true;
      _filteredAddresses.clear();
    });
  }

  Future<void> _loadTaskerMarker(LatLng taskerPosition, {bool useCurrentLocation = true}) async {
    // Load tasker icon
    final taskerIconLoaded = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(90, 90)),
      _currentTasker?.mapProfileImage ?? 'assets/images/tasker3.png'
    );

    // Load default user location icon
    final currentLocationIconLoaded = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    );

    setState(() {
      taskerIcon = taskerIconLoaded;
      currentLocationIcon = currentLocationIconLoaded;

      // Determine which location to use for the user
      LatLng userLocation = useCurrentLocation ? currentLocation! : userAddressLocation!;

      // Update markers for both tasker and user location
      markers = {
        Marker(
          markerId: const MarkerId('taskerLocation'),
          position: taskerPosition,
          icon: taskerIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
        Marker(
          markerId: const MarkerId('userLocation'),
          position: userLocation,
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


  void _onTaskAccepted() {
    _controller.forward().then((_) {
      setState(() {
        _statusText = "Profesionisti u pranua për të kryer punën\nJu mund ta kontaktoni atë dhe nderkohë mund të shtoni detaje në lidhje me punën...";
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


@override
Widget build(BuildContext context) {

    ref.listen<TaskStateData>(taskStateProvider, (previous, next) {

    if (next.taskState == TaskState.accepted && !_onTaskAcceptedCalled) {
      _onTaskAccepted();
      _onTaskAcceptedCalled = true;
    }
  });

  final taskState = ref.watch(taskStateProvider).taskState;

  return PopScope(
    canPop: taskState == TaskState.initial,
    onPopInvoked: (didPop) {
      final taskStateNotifier = ref.read(taskStateProvider.notifier);
      final mapStateNotifier = ref.read(mapStateProvider.notifier);

      if (taskState == TaskState.accepted) {
        taskStateNotifier.resetTask();
        mapStateNotifier.clearPolylines();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(initialIndex: 1)),
          (Route<dynamic> route) => false,
        );
      } else if (taskState == TaskState.searching || taskState == TaskState.profileView) {
        showCancelDialog(context, ref);
      }
    },
    child: Scaffold(
      body: Stack(
        children: [
          // Google Map Layer
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, child) {
                final mapProvider = ref.watch(mapStateProvider);
                final mapStateNotifier = ref.read(mapStateProvider.notifier);

                return GoogleMap(
                  padding: const EdgeInsets.only(bottom: 20),
                  initialCameraPosition: CameraPosition(
                    target: currentLocation ?? const LatLng(41.3275, 19.8189),
                    zoom: 15.5,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapStateNotifier.loadMapStyle(context);
                  },
                  // Apply map style and polylines from mapProvider
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

          // Show searching animation if the task state is searching
          if (taskState == TaskState.searching)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.5,
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
                      opacity: 0.5,
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
              SearchSection(
                searchController: searchController,
                isAddressSelected: _isAddressSelected,
                filteredAddresses: _filteredAddresses,
                onSearch: _searchNewLocation,
                onSelectLocation: _selectLocation,
                performSearch: (String address) => _performSearch(searchFromCurrentPosition: false, address: address),
                useCurrentLocation: _performSearch,
                showAddressNotification: () => _addAddressNotification(context),
                slideAnimation: _slideAnimation,
                statusText: _statusText,
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          if (_currentTasker != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: taskState == TaskState.profileView || taskState == TaskState.accepted ? 0 : -400.h,
              child: ProfileContainer(tasker: _currentTasker!),
            ),
        ],
      ),
    ),
  );
}
}
