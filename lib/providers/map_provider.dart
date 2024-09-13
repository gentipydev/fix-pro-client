import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider with ChangeNotifier {
  String? _mapStyle;
  String? get mapStyle => _mapStyle;

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  Future<void> loadMapStyle(BuildContext context) async {
    _mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    notifyListeners();
  }

  void createRoute() {
  List<LatLng> polylineCoordinates = [
    const LatLng(41.333688, 19.846087),
    const LatLng(41.333723, 19.846414), 
    const LatLng(41.333758, 19.846741),
    const LatLng(41.333793, 19.847068), 
    const LatLng(41.333829, 19.847395),
    const LatLng(41.333856, 19.847873), 
    const LatLng(41.333883, 19.848350),
    const LatLng(41.333910, 19.848828), 
    const LatLng(41.333937, 19.849306),
    const LatLng(41.333872, 19.849343), 
    const LatLng(41.333808, 19.849379),
    const LatLng(41.333744, 19.849411), 
    const LatLng(41.333680, 19.849443),
    const LatLng(41.333632, 19.849518), 
    const LatLng(41.333585, 19.849593),
    const LatLng(41.333570, 19.849669), 
    const LatLng(41.333556, 19.849746),
    const LatLng(41.333548, 19.849755), 
    const LatLng(41.333541, 19.849765),
    const LatLng(41.333453, 19.849857), 
    const LatLng(41.333365, 19.849950),
    const LatLng(41.333277, 19.850042), 
    const LatLng(41.333189, 19.850135),
    const LatLng(41.333113, 19.850294), 
    const LatLng(41.333036, 19.850453),
    const LatLng(41.332959, 19.850611), 
    const LatLng(41.332883, 19.850770),
    const LatLng(41.332860, 19.851289), 
    const LatLng(41.332836, 19.851808),
    const LatLng(41.332812, 19.852327), 
    const LatLng(41.332789, 19.852846),
    const LatLng(41.332821, 19.853339), 
    const LatLng(41.332853, 19.853833),
    const LatLng(41.332885, 19.854327), 
    const LatLng(41.332918, 19.854820),
  ];


    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylineCoordinates,
        color: AppColors.black,
        width: 3,
      ),
    };
    notifyListeners();
  }

  // Method to update polyline points dynamically
  void updatePolyline(List<LatLng> updatedPolylinePoints) {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: updatedPolylinePoints,
        color: AppColors.black,
        width: 3,
      ),
    };
    notifyListeners();
  }
}
