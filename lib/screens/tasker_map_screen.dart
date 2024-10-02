// import 'dart:async';
// import 'dart:ui';
// import 'package:fit_pro_client/providers/map_provider.dart';
// import 'package:fit_pro_client/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:url_launcher/url_launcher.dart';

// class TaskerMapScreen extends StatefulWidget {
//   const TaskerMapScreen({super.key});

//   @override
//   TaskerMapScreenState createState() => TaskerMapScreenState();
// }

// class TaskerMapScreenState extends State<TaskerMapScreen> {
//   Logger logger = Logger();
//   GoogleMapController? mapController;
//   Set<Marker> markers = {};
//   Timer? _timer;
//   // int _currentPolylineIndex = 0;
//   final LatLng _taskerPosition = const LatLng(41.333688, 19.846087);
//   bool isMoving = false;
//   BitmapDescriptor? taskerIcon;

//   @override
//   void initState() {
//     super.initState();
//     // Preload the custom marker icon
//     _loadCustomMarker();
    
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // final mapProvider = Provider.of<MapProvider>(context, listen: false);
//       // mapProvider.createRoute();
//       // _startTaskerMovement(mapProvider.polylines.first.points);
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _navigateToLocation() async {
//     final Uri url = Uri.parse(
//         'https://www.google.com/maps/dir/?api=1&destination=41.332918,19.854820&travelmode=driving');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw Exception('Could not launch $url');
//     }
//   }

//   // Load the custom marker icon
//   Future<void> _loadCustomMarker() async {
//     taskerIcon = await BitmapDescriptor.asset(
//       const ImageConfiguration(size: Size(38, 38)),
//       'assets/icons/handyman.png',
//     );

//     setState(() {
//       // Initialize markers after loading the custom icon
//       markers = {
//         Marker(
//           markerId: const MarkerId('taskerLocation'),
//           position: _taskerPosition,
//           icon: taskerIcon!,
//           anchor: const Offset(0.5, 0.5),
//         ),
//         Marker(
//           markerId: const MarkerId('userLocation'),
//           position: const LatLng(41.332918, 19.854820),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       };
//     });
//   }

//   // Function to simulate tasker movement along the polyline
//   // void _startTaskerMovement(List<LatLng> polylinePoints) {
//   //   if (isMoving) return; // Prevent multiple movements at the same time
//   //   isMoving = true;

//   //   _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//   //     if (_currentPolylineIndex < polylinePoints.length - 1) {
//   //       setState(() {
//   //         // Move to the next point in the polyline
//   //         _currentPolylineIndex++;
//   //         _taskerPosition = polylinePoints[_currentPolylineIndex];

//   //         // Update the polyline by removing the traveled part
//   //         final mapProvider = Provider.of<MapProvider>(context, listen: false);
//   //         mapProvider.updatePolyline(polylinePoints.sublist(_currentPolylineIndex));

//   //         // Update the tasker marker
//   //         _updateTaskerMarker();
//   //       });
//   //     } else {
//   //       timer.cancel();
//   //       isMoving = false;
//   //       _showArrivalConfirmation(context);
//   //     }
//   //   });
//   // }

//   // Function to update the tasker marker position with the preloaded custom image
//   void _updateTaskerMarker() {
//     setState(() {
//       if (_taskerPosition == const LatLng(41.332918, 19.854820)) {
//         markers = {
//           Marker(
//             markerId: const MarkerId('userLocation'),
//             position: const LatLng(41.332918, 19.854820),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         };
//       } else {
//         markers = {
//           Marker(
//             markerId: const MarkerId('taskerLocation'),
//             position: _taskerPosition,
//             icon: taskerIcon!,
//             anchor: const Offset(0.5, 0.5),
//           ),
//           Marker(
//             markerId: const MarkerId('userLocation'),
//             position: const LatLng(41.332918, 19.854820),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         };
//       }
//     });
//   }

//   void _showArrivalConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.5), 
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), 
//           child: Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "A erdhi profesionisti në vendodhjen tuaj?",
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.grey700,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 40.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           logger.i("Profesionisti ka arritur");
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.tomatoRed,
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12.h, horizontal: 20.w),
//                         ),
//                         child: Text(
//                           'Po, erdhi',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           logger.i("Profesionisti nuk ka arritur");
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey,
//                           padding: EdgeInsets.symmetric(
//                             vertical: 12.h, horizontal: 20.w),
//                         ),
//                         child: Text(
//                           'Jo, nuk erdhi',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30.h),
//             Container(
//               color: AppColors.tomatoRedLight,
//               width: double.infinity,
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Puna juaj është pranuar ',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 30.h),
//                   Text(
//                     'Ndërkohë ju mund te kontaktoni profesionistin dhe të monitoroni vendodhjen e tij në kohë reale...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Stack(
//               children: [
//                 SizedBox(
//                   height: 380.h,
//                   child: Consumer<MapProvider>(
//                     builder: (context, mapProvider, child) {
//                       return GoogleMap(
//                         initialCameraPosition: const CameraPosition(
//                           target: LatLng(41.333556, 19.849746),
//                           zoom: 15.5,
//                         ),
//                         onMapCreated: (GoogleMapController controller) {
//                           mapProvider.loadMapStyle(context);
//                         },
//                         style: mapProvider.mapStyle,
//                         polylines: mapProvider.polylines,
//                         markers: markers,
//                         zoomControlsEnabled: false,
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 1.h,
//                   left: 70.w,
//                   child: Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: _navigateToLocation,
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: AppColors.tomatoRed,
//                           backgroundColor: AppColors.white,
//                           padding: EdgeInsets.all(4.w),
//                           minimumSize: Size(30.w, 30.h),
//                           shape: const CircleBorder(),
//                         ),
//                         child: Icon(
//                           Icons.directions,
//                           color: AppColors.tomatoRed,
//                           size: 25.w,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               color: AppColors.grey100,
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 16.w, top: 16.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on, color: AppColors.grey700),
//                               SizedBox(width: 8.w),
//                               Text(
//                                 'Rrethrrotullimi i Farkës, Tiranë',
//                                 style: TextStyle(fontSize: 16.sp),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: Text(
//                         'Rreth 0.7 km larg',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Stack(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Container(
//                                         width: 80.w,
//                                         height: 80.h,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color: AppColors.grey300,
//                                             width: 3.0,
//                                           ),
//                                         ),
//                                         child: CircleAvatar(
//                                           radius: 36.sp,
//                                           backgroundImage: const AssetImage('assets/images/client3.png'),
//                                         ),
//                                       ),
//                                       SizedBox(height: 10.h),
//                                       Text(
//                                         'Arben Gashi',
//                                         style: TextStyle(
//                                           fontSize: 16.sp,
//                                           color: AppColors.grey700,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 12.h),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Montim Mobiliesh",
//                                         style: TextStyle(
//                                           fontSize: 14.sp,
//                                           color: AppColors.grey700,
//                                         ),
//                                       ),
//                                       SizedBox(height: 10.h),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             '2000 Lek',
//                                             style: TextStyle(
//                                               fontSize: 12.sp,
//                                               color: AppColors.tomatoRed,
//                                             ),
//                                           ),
//                                           Text(
//                                             '/orë pune',
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: AppColors.grey700,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Positioned(
//                                 top: 2.w,
//                                 right: 2.w,
//                                 child: Icon(
//                                   Icons.military_tech,
//                                   color: AppColors.tomatoRed,
//                                   size: 28.sp,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // const ExpandableFab(phoneNumber: '+355696443833'),
//                         ],
//                       ),
//                   ],
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
