import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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

  Future<LatLngBounds?> fetchRouteFromOSRMApi(LatLng start, LatLng end) async {
    try {
      // Fetch route coordinates from OSRM API
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);
      
      // Set the polyline on the map
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route_from_api'),
          points: routeCoordinates,
          color: AppColors.black,
          width: 3,
        ),
      };
      notifyListeners();

      // Calculate bounds that include both markers and polyline
      LatLngBounds bounds = _calculateLatLngBounds(routeCoordinates);
      
      return bounds;
    } catch (e) {
      logger.e('Failed to fetch route: $e');
      return null; // Return null if fetching fails
    }
  }

  Future<Map<String, dynamic>?> fetchPastTaskRouteFromOSRMApi(LatLng start, LatLng end) async {
    try {
      // Fetch route coordinates from OSRM API
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);

      if (routeCoordinates.isEmpty) {
        return null;
      }

      LatLngBounds bounds = _calculateLatLngBounds(routeCoordinates);
      
      // Return both the bounds and the route coordinates
      return {
        'bounds': bounds,
        'routeCoordinates': routeCoordinates,
      };
    } catch (e) {
      logger.e('Failed to fetch route: $e');
      return null;
    }
  }

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end, {int retries = 3}) async {
    final String osrmUrl =
        'http://192.168.0.48:5000/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline';

    int attempt = 0;
    while (attempt < retries) {
      try {
        // Perform the HTTP request with a timeout
        final response = await http
            .get(Uri.parse(osrmUrl))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          // Decode the JSON response and check for valid routes
          final decodedJson = jsonDecode(response.body);
          if (decodedJson['routes'] != null &&
              decodedJson['routes'].isNotEmpty &&
              decodedJson['routes'][0]['geometry'] != null) {
            final polyline = decodedJson['routes'][0]['geometry'];
            logger.d("start: $start");
            logger.d("end: $end");

            // Decode polyline and ensure first and last points correspond
            List<LatLng> routeCoordinates = decodePolyline(polyline);

            // Fix the first and last points to exactly match the start and end
            if (routeCoordinates.isNotEmpty) {
              routeCoordinates[0] = start;
              routeCoordinates[routeCoordinates.length - 1] = end;
            }

            return routeCoordinates;
          } else {
            throw Exception('No route found in response');
          }
        } else {
          logger.e('Failed to fetch route, status code: ${response.statusCode}');
          throw Exception('Failed to fetch route');
        }
      } on SocketException catch (e) {
        // Handle network errors
        logger.e('Network error: $e');
      } on TimeoutException catch (e) {
        // Handle timeout errors
        logger.e('Request timed out: $e');
      } catch (e) {
        // General catch for any other exceptions
        logger.e('Unexpected error: $e');
        // Retry for ClientException-like errors
        if (e.toString().contains('ClientException')) {
          logger.e('Retrying due to ClientException...');
        } else {
          rethrow; // Rethrow other errors
        }
      }

      // Delay before retrying
      attempt++;
      if (attempt < retries) {
        logger.d('Retrying... Attempt $attempt of $retries');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    // Throw only if all retry attempts have failed
    throw Exception('Failed to fetch route after $retries attempts');
  }

  List<LatLng> decodePolyline(String polylineString) {
    PolylinePoints polylinePoints = PolylinePoints();

    // Decode the polyline string into a list of PointLatLng objects
    List<PointLatLng> result = polylinePoints.decodePolyline(polylineString);

    // Convert PointLatLng to LatLng for Google Maps
    List<LatLng> coordinates = result.map((point) => LatLng(point.latitude, point.longitude)).toList();
    logger.d("first_point: ${coordinates.first}");
    logger.d("last_point: ${coordinates.last}");
    return coordinates;
  }

  LatLngBounds _calculateLatLngBounds(List<LatLng> polylinePoints) {
    double minLat = polylinePoints.first.latitude;
    double minLng = polylinePoints.first.longitude;
    double maxLat = polylinePoints.first.latitude;
    double maxLng = polylinePoints.first.longitude;

    for (LatLng point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

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
  
  void clearPolylines() {
    _polylines = {};
    notifyListeners();
  }

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

  Future<String> getAddressFromLatLng(LatLng location, {bool isFullAddress = true}) async {
    final String url =
        'https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Check if the address field is available in the response
      if (data.containsKey('address')) {
        final address = data['address'];

        // Extract the required fields
        final String houseNumber = address['house_number'] ?? '';
        final String road = address['road'] ?? '';
        final String suburb = address['suburb'] ?? '';
        final String city = address['city'] ?? address['town'] ?? address['village'] ?? '';
        final String state = address['state'] ?? '';
        final String country = address['country'] ?? '';

        // Create a list of non-empty address components
        if (isFullAddress) {
          final List<String> fullAddressParts = [
            if (houseNumber.isNotEmpty) houseNumber,
            if (road.isNotEmpty) road,
            if (suburb.isNotEmpty) suburb,
            if (city.isNotEmpty) city,
            if (state.isNotEmpty) state,
            if (country.isNotEmpty) country,
          ];

          return fullAddressParts.join(', ');
        } else {
          final List<String> shortAddressParts = [
            if (road.isNotEmpty) road,
            if (city.isNotEmpty) city,
          ];

          return shortAddressParts.join(', ');
        }
      } else {
        return 'No address available';
      }
    } else {
      throw Exception('Failed to fetch the address');
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude, start.longitude, 
      end.latitude, end.longitude
    );
  }
}
