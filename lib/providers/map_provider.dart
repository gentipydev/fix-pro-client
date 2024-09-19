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
    const LatLng(41.333705, 19.846250), 
    const LatLng(41.333723, 19.846414),
    const LatLng(41.333740, 19.846577), 
    const LatLng(41.333758, 19.846741),
    const LatLng(41.333775, 19.846904), 
    const LatLng(41.333793, 19.847068),
    const LatLng(41.333811, 19.847231), 
    const LatLng(41.333829, 19.847395),
    const LatLng(41.333842, 19.847634), 
    const LatLng(41.333856, 19.847873),
    const LatLng(41.333869, 19.848112), 
    const LatLng(41.333883, 19.848350),
    const LatLng(41.333896, 19.848589), 
    const LatLng(41.333910, 19.848828),
    const LatLng(41.333923, 19.849067), 
    const LatLng(41.333937, 19.849306),
    const LatLng(41.333905, 19.849324), 
    const LatLng(41.333872, 19.849343),
    const LatLng(41.333840, 19.849361), 
    const LatLng(41.333808, 19.849379),
    const LatLng(41.333776, 19.849395), 
    const LatLng(41.333744, 19.849411),
    const LatLng(41.333712, 19.849427), 
    const LatLng(41.333680, 19.849443),
    const LatLng(41.333656, 19.849480), 
    const LatLng(41.333632, 19.849518),
    const LatLng(41.333608, 19.849555), 
    const LatLng(41.333585, 19.849593),
    const LatLng(41.333577, 19.849631), 
    const LatLng(41.333570, 19.849669),
    const LatLng(41.333563, 19.849708), 
    const LatLng(41.333556, 19.849746),
    const LatLng(41.333552, 19.849751), 
    const LatLng(41.333548, 19.849755),
    const LatLng(41.333545, 19.849760), 
    const LatLng(41.333541, 19.849765),
    const LatLng(41.333497, 19.849811), 
    const LatLng(41.333453, 19.849857),
    const LatLng(41.333409, 19.849903), 
    const LatLng(41.333365, 19.849950),
    const LatLng(41.333321, 19.849996), 
    const LatLng(41.333277, 19.850042),
    const LatLng(41.333233, 19.850089), 
    const LatLng(41.333189, 19.850135),
    const LatLng(41.333151, 19.850215), 
    const LatLng(41.333113, 19.850294),
    const LatLng(41.333074, 19.850374), 
    const LatLng(41.333036, 19.850453),
    const LatLng(41.332998, 19.850532), 
    const LatLng(41.332959, 19.850611),
    const LatLng(41.332921, 19.850691), 
    const LatLng(41.332883, 19.850770),
    const LatLng(41.332872, 19.851029), 
    const LatLng(41.332860, 19.851289),
    const LatLng(41.332848, 19.851548), 
    const LatLng(41.332836, 19.851808),
    const LatLng(41.332824, 19.852068), 
    const LatLng(41.332812, 19.852327),
    const LatLng(41.332801, 19.852587), 
    const LatLng(41.332789, 19.852846),
    const LatLng(41.332805, 19.853093), 
    const LatLng(41.332821, 19.853339),
    const LatLng(41.332837, 19.853586), 
    const LatLng(41.332853, 19.853833),
    const LatLng(41.332869, 19.854080), 
    const LatLng(41.332885, 19.854327),
    const LatLng(41.332902, 19.854573), 
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
