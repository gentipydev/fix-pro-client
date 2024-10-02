import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapStateData {
  final String? mapStyle;
  final Set<Polyline> polylines;
  final List<String> fetchedAddresses;

  MapStateData({
    required this.mapStyle,
    required this.polylines,
    required this.fetchedAddresses,
  });

  factory MapStateData.initial() {
    return MapStateData(
      mapStyle: null,
      polylines: {},
      fetchedAddresses: [],
    );
  }

  MapStateData copyWith({
    String? mapStyle,
    Set<Polyline>? polylines,
    List<String>? fetchedAddresses,
  }) {
    return MapStateData(
      mapStyle: mapStyle ?? this.mapStyle,
      polylines: polylines ?? this.polylines,
      fetchedAddresses: fetchedAddresses ?? this.fetchedAddresses,
    );
  }
}

class MapStateNotifier extends StateNotifier<MapStateData> {
  Logger logger = Logger();

  MapStateNotifier() : super(MapStateData.initial());

  // Load the map style from the asset bundle and update state
  Future<void> loadMapStyle(BuildContext context) async {
    try {
      final mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
      state = state.copyWith(mapStyle: mapStyle);
    } catch (e) {
      logger.e('Failed to load map style: $e');
    }
  }

  // Fetch route and set polylines in the state
  Future<LatLngBounds?> fetchRoute(LatLng start, LatLng end) async {
    try {
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);

      // Update polylines in the state
      final polyline = Polyline(
        polylineId: const PolylineId('route_from_api'),
        points: routeCoordinates,
        color: AppColors.black,
        width: 3,
      );

      state = state.copyWith(polylines: {polyline});

      // Calculate bounds
      LatLngBounds bounds = await _calculateLatLngBounds(routeCoordinates);
      return bounds;
    } catch (e) {
      logger.e('Failed to fetch route: $e');
      return null;
    }
  }

  // Fetch route and return both bounds and coordinates for past task
  Future<Map<String, dynamic>?> fetchPastTaskRoute(LatLng start, LatLng end) async {
    try {
      List<LatLng> routeCoordinates = await getRouteCoordinates(start, end);
      if (routeCoordinates.isEmpty) return null;

      LatLngBounds bounds = await _calculateLatLngBounds(routeCoordinates);
      return {
        'bounds': bounds,
        'routeCoordinates': routeCoordinates,
      };
    } catch (e) {
      logger.e('Failed to fetch past task route: $e');
      return null;
    }
  }

  // Get route coordinates using Google Directions API
  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end, {int retries = 3}) async {
    final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
    final String directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$googleApiKey';

    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final response = await http.get(Uri.parse(directionsUrl)).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final decodedJson = jsonDecode(response.body);
          if (decodedJson['routes'] != null &&
              decodedJson['routes'].isNotEmpty &&
              decodedJson['routes'][0]['overview_polyline'] != null) {
            final polyline = decodedJson['routes'][0]['overview_polyline']['points'];
            List<LatLng> routeCoordinates = await decodePolyline(polyline);

            if (routeCoordinates.isNotEmpty) {
              routeCoordinates[0] = start;
              routeCoordinates[routeCoordinates.length - 1] = end;
            }

            return routeCoordinates;
          } else {
            throw Exception('No route found');
          }
        } else {
          throw Exception('Failed to fetch route, status code: ${response.statusCode}');
        }
      } catch (e) {
        if (attempt == retries - 1) rethrow; // On last attempt, rethrow the error
        logger.e('Retrying... Attempt $attempt of $retries');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    throw Exception('Failed to fetch route after $retries attempts');
  }

  // Decode the polyline string into LatLng points
  Future<List<LatLng>> decodePolyline(String polylineString) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(polylineString);
    return result.map((point) => LatLng(point.latitude, point.longitude)).toList();
  }

  // Calculate the bounds for a list of LatLng points
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

  // Clear polylines from the state
  void clearPolylines() {
    state = state.copyWith(polylines: {});
  }

  // Get LatLng from an address
  Future<LatLng> getLatLngFromAddress(String address) async {
    final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('No results found for this address');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  // Get address from LatLng
  Future<String> getAddressFromLatLng(LatLng location, {bool isFullAddress = true}) async {
    final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        final addressComponents = data['results'][0]['address_components'];
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
          return shortAddressParts.join(', ');
        }
      } else {
        return 'No address found';
      }
    } else {
      throw Exception('Failed to fetch the address');
    }
  }

  // Fetch place suggestions from Google Places API
  Future<void> fetchAddresses(String input) async {
    final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    const String locationBias = '41.3275,19.8189';
    const String radius = '50000';

    final Uri uri = Uri.parse(
        '$baseUrl?input=$input&location=$locationBias&radius=$radius&key=$googleApiKey&components=country:al');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fetchedAddresses = (data['predictions'] as List).map<String>((item) {
        return item['description'] as String;
      }).toList();

      state = state.copyWith(fetchedAddresses: fetchedAddresses);
    } else {
      throw Exception('Failed to fetch address suggestions');
    }
  }

  // Calculate the distance between two LatLng points
  Future<double> calculateDistance(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);
  }
}

// Provider for MapStateNotifier
final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapStateData>(
  (ref) => MapStateNotifier(),
);
