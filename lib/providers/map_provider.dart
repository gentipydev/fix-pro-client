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
  List<String> _fetchedAddresses = [];

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  List<String> get fetchedAddresses => _fetchedAddresses;

  Future<void> loadMapStyle(BuildContext context) async {
    _mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    notifyListeners();
  }

  Future<LatLngBounds?> fetchRoute(LatLng start, LatLng end) async {
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
      LatLngBounds bounds = await _calculateLatLngBounds(routeCoordinates);
      
      return bounds;
    } catch (e) {
      logger.e('Failed to fetch route: $e');
      return null; // Return null if fetching fails
    }
  }

  Future<Map<String, dynamic>?> fetchPastTaskRoute(LatLng start, LatLng end) async {
    try {
      // Fetch route coordinates from OSRM API
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);

      if (routeCoordinates.isEmpty) {
        return null;
      }

      LatLngBounds bounds = await _calculateLatLngBounds(routeCoordinates);
      
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
    const String googleApiKey = 'AIzaSyDTsA-ao5QZRG8ZDb0O3RxRlk2mytT1wGo';
    final String directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$googleApiKey';

    int attempt = 0;
    while (attempt < retries) {
      try {
        // Perform the HTTP request with a timeout
        final response = await http
            .get(Uri.parse(directionsUrl))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          // Decode the JSON response and check for valid routes
          final decodedJson = jsonDecode(response.body);
          if (decodedJson['routes'] != null &&
              decodedJson['routes'].isNotEmpty &&
              decodedJson['routes'][0]['overview_polyline'] != null) {
            final polyline = decodedJson['routes'][0]['overview_polyline']['points'];

            // Decode the polyline to get the route coordinates
            List<LatLng> routeCoordinates = await decodePolyline(polyline);

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
        logger.e('Network error: $e');
      } on TimeoutException catch (e) {
        logger.e('Request timed out: $e');
      } catch (e) {
        logger.e('Unexpected error: $e');
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

    throw Exception('Failed to fetch route after $retries attempts');
  }

  Future<List<LatLng>> decodePolyline(String polylineString) async {
    PolylinePoints polylinePoints = PolylinePoints();

    // Decode the polyline string into a list of PointLatLng objects
    List<PointLatLng> result = polylinePoints.decodePolyline(polylineString);

    // Convert PointLatLng to LatLng for Google Maps
    List<LatLng> coordinates = result.map((point) => LatLng(point.latitude, point.longitude)).toList();

    return coordinates;
  }

  Future<LatLngBounds> _calculateLatLngBounds(List<LatLng> polylinePoints) async {
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

  void clearPolylines() {
    _polylines = {};
    notifyListeners();
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    const String googleApiKey = 'AIzaSyDTsA-ao5QZRG8ZDb0O3RxRlk2mytT1wGo';
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final double latitude = location['lat'];
        final double longitude = location['lng'];
        return LatLng(latitude, longitude);
      } else {
        throw Exception('No results found for this address');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  Future<String> getAddressFromLatLng(LatLng location, {bool isFullAddress = true}) async {
    const String googleApiKey = 'AIzaSyDTsA-ao5QZRG8ZDb0O3RxRlk2mytT1wGo';
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        final addressComponents = data['results'][0]['address_components'];
        logger.d("addressComponents: $addressComponents");

        // Extract address parts
        String houseNumber = '';
        String road = '';
        String suburb = '';
        String city = '';

        // Iterate through address components to find relevant data
        for (var component in addressComponents) {
          final List types = component['types'];

          if (types.contains('street_number')) {
            houseNumber = component['long_name'];
          } else if (types.contains('route')) {
            road = component['long_name'];
          } else if (types.contains('sublocality') || types.contains('neighborhood') || types.contains('suburb')) {
            suburb = component['long_name'];
          } else if (types.contains('locality')) {
            city = component['long_name'];
          }
        }

        if (isFullAddress) {
          // Create the full address string without state and country
          final List<String> fullAddressParts = [
            if (houseNumber.isNotEmpty) houseNumber,
            if (road.isNotEmpty) road,
            if (suburb.isNotEmpty) suburb,
            if (city.isNotEmpty) city,
          ];

          return fullAddressParts.join(', ');
        } else {
          // Create the short address (road and city)
          final List<String> shortAddressParts = [
            if (road.isNotEmpty) road,
            if (city.isNotEmpty) city,
          ];
          logger.d("road: $road");
          return shortAddressParts.join(', ');
        }
      } else {
        return 'No address found';
      }
    } else {
      throw Exception('Failed to fetch the address');
    }
  }

  Future<double> calculateDistance(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(
      start.latitude, start.longitude,
      end.latitude, end.longitude
    );
  }

  Future<void> fetchAddresses(String input) async {
    const String googleApiKey = 'AIzaSyDTsA-ao5QZRG8ZDb0O3RxRlk2mytT1wGo';
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    
    const String locationBias = '41.3275,19.8189';
    const String radius = '50000';

    final Uri uri = Uri.parse(
        '$baseUrl?input=$input&location=$locationBias&radius=$radius&key=$googleApiKey&components=country:al');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      logger.d("API Response: ${response.body}");

      if (data['predictions'] != null) {
        _fetchedAddresses = data['predictions'].map<String>((item) {
          return item['description'] as String;
        }).toList();

        logger.d("Fetched Addresses (Suggestions for Tirana): $_fetchedAddresses");
        notifyListeners();
      } else {
        throw Exception('No predictions found for the input');
      }
    } else {
      throw Exception('Failed to load place suggestions from Google Places API');
    }
  }
}
