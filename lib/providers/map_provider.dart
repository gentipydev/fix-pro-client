import 'dart:convert';

import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class MapProvider with ChangeNotifier {
  Logger logger = Logger();
  String? _mapStyle;
  String? get mapStyle => _mapStyle;

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  Future<void> loadMapStyle(BuildContext context) async {
    _mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    notifyListeners();
  }

  Future<void> fetchRouteFromOSRMApi(LatLng start, LatLng end) async {
    try {
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route_from_api'),
          points: routeCoordinates,
          color: AppColors.black,
          width: 3,
        ),
      };
      notifyListeners();
    } catch (e) {
      logger.e('Failed to fetch route: $e');
    }
  }

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    final String osrmUrl =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline';

    final response = await http.get(Uri.parse(osrmUrl));

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final polyline = decodedJson['routes'][0]['geometry'];
      return decodePolyline(polyline);
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  List<LatLng> decodePolyline(String polylineString) {
    PolylinePoints polylinePoints = PolylinePoints();

    // Decode the polyline string into a list of PointLatLng objects
    List<PointLatLng> result = polylinePoints.decodePolyline(polylineString);

    // Convert PointLatLng to LatLng for Google Maps
    List<LatLng> coordinates = result.map((point) => LatLng(point.latitude, point.longitude)).toList();

    return coordinates;
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
  
  // Method to clear all polylines
  void clearPolylines() {
    _polylines = {};
    notifyListeners();
  }

    // Get LatLng from Address using OpenStreetMap Nominatim API
  Future<LatLng> getLatLngFromAddress(String address) async {
    final String url = 'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final double latitude = double.parse(data[0]['lat']);
        final double longitude = double.parse(data[0]['lon']);
        return LatLng(latitude, longitude);
      } else {
        throw Exception('No results found for this address');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }
}
