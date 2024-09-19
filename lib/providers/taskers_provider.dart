import 'package:fit_pro_client/models/tasker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskersProvider extends ChangeNotifier {
  List<Tasker> _taskers = [];
  LatLng? _centralLocation;

  List<Tasker> get taskers => _taskers;
  LatLng? get centralLocation => _centralLocation;

  TaskersProvider() {
    _loadFakeTaskers();
  }

  // Function to load fake taskers
  void _loadFakeTaskers() {
    _taskers = [
      Tasker(
        fullName: 'Arben Gashi',
        location: const LatLng(41.3317, 19.8318),
        rating: 4.8,
        profileImage: 'assets/images/client1.png',
        mapProfileImage: 'assets/images/tasker1.png',
        phoneNumber: '+355671234567',
        email: 'arbengashi@example.com',
        skills: ['Shtrim pllakash', 'Punime elektrike'],
        bio: 'Punëtor me përvojë me mbi 10 vjet në zanatin e tij...',
        isSuperPunetor: true,
      ),
      Tasker(
        fullName: 'Eriona Hoxha',
        location: const LatLng(41.3444, 19.8220),
        rating: 4.9,
        profileImage: 'assets/images/client2.png',
        mapProfileImage: 'assets/images/tasker2.png',
        phoneNumber: '+355682345678',
        email: 'erionahoxha@example.com',
        skills: ['Lyerje', 'Punime druri'],
        bio: 'Eksperte në përmirësimin dhe dekorimin e shtëpisë...',
      ),
      Tasker(
        fullName: 'Blerim Krasniqi',
        location: const LatLng(41.3077, 19.7990), 
        rating: 4.7,
        profileImage: 'assets/images/client3.png',
        mapProfileImage: 'assets/images/tasker3.png',
        phoneNumber: '+355691234567',
        email: 'blerimkrasniqi@example.com',
        skills: ['Kopshtari'],
        bio: 'Specialist për kujdesin ndaj kopshtit...',
      ),
      Tasker(
        fullName: 'Lule Bajraktari',
        location: const LatLng(41.3565, 19.7494),
        rating: 4.6,
        profileImage: 'assets/images/client4.png',
        mapProfileImage: 'assets/images/tasker4.png',
        phoneNumber: '+355692345678',
        email: 'lulebajraktari@example.com',
        skills: ['Pastrim', 'Organizimi i hapësirave'],
        bio: 'Eksperte në pastrimin dhe organizimin e hapësirave të banimit...',
        isSuperPunetor: true
      ),
      Tasker(
        fullName: 'Artan Rexhepi',
        location: const LatLng(41.2810, 19.8916),
        rating: 4.9,
        profileImage: 'assets/images/client5.png',
        mapProfileImage: 'assets/images/tasker5.png',
        phoneNumber: '+355672345679',
        email: 'artanrexhepi@example.com',
        skills: ['Lyerje', 'Instalime hidraulike'],
        bio: 'Ndërtues me përvojë të gjatë në lyerje dhe instalime hidraulike...',
      ),
    ];

    // Calculate the central location
    _calculateCentralLocation();

    notifyListeners();
  }

  // Function to remove a tasker
  void removeTasker(Tasker tasker) {
    _taskers.remove(tasker);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Calculate the central location based on the average location of all taskers
  void _calculateCentralLocation() {
    if (_taskers.isEmpty) {
      _centralLocation = const LatLng(41.3275, 19.8189);
    } else {
      final double averageLat = _taskers.map((t) => t.location.latitude).reduce((a, b) => a + b) / _taskers.length;
      final double averageLng = _taskers.map((t) => t.location.longitude).reduce((a, b) => a + b) / _taskers.length;
      _centralLocation = LatLng(averageLat, averageLng);
    }
  }

  // Function to get asset image descriptor for a map marker
  Future<BitmapDescriptor> getAssetImageDescriptor(String assetPath) async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(90, 90)),
      assetPath,
    );
  }
}
