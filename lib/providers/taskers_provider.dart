import 'package:fit_pro_client/models/tasker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskersProvider extends ChangeNotifier {
  List<Tasker> _taskers = [];
  LatLng? _centralLocation;

  // Getters for taskers
  List<Tasker> get taskers => _taskers;               // All taskers

  // Get favorite taskers where isFavorite is true
  List<Tasker> get favoriteTaskers => _taskers.where((tasker) => tasker.isFavorite).toList();

  // Past taskers (return all for now, as an example)
  List<Tasker> get pastTaskers => _taskers;

  LatLng? get centralLocation => _centralLocation;

  TaskersProvider() {
    _loadFakeTaskers();
  }

  // Function to load fake taskers
  void _loadFakeTaskers() {
    _taskers = [
      Tasker(
        fullName: 'Arben G.',
        location: const LatLng(41.3317, 19.8318),
        rating: 4.8,
        profileImage: 'assets/images/client1.png',
        mapProfileImage: 'assets/images/tasker1.png',
        phoneNumber: '+355671234567',
        email: 'arbengashi@example.com',
        skills: ['Shtrim pllakash', 'Punime elektrike'],
        bio: 'Jam një punëtor me përvojë me mbi 10 vjet në zanatin tim. Kam punuar me firma te ndryshme te instalimeve elektrike dhe...',
        isSuperPunetor: true,
        isFavorite: true,
      ),
      Tasker(
        fullName: 'Eriona H.',
        location: const LatLng(41.3444, 19.8220),
        rating: 4.9,
        profileImage: 'assets/images/client2.png',
        mapProfileImage: 'assets/images/tasker2.png',
        phoneNumber: '+355682345678',
        email: 'erionahoxha@example.com',
        skills: ['Lyerje', 'Punime druri'],
        bio: 'Jam nje eksperte në përmirësimin dhe dekorimin e shtëpisë. Kam pasur nje pasion të madh që në fëmijeri që te merrem me punime druri dhe ...',
        isFavorite: true,  
      ),
      Tasker(
        fullName: 'Lule B.',
        location: const LatLng(41.3565, 19.7494),
        rating: 4.6,
        profileImage: 'assets/images/client4.png',
        mapProfileImage: 'assets/images/tasker4.png',
        phoneNumber: '+355692345678',
        email: 'lulebajraktari@example.com',
        skills: ['Pastrim', 'Organizimi i hapësirave'],
        bio: 'Jam një eksperte në pastrimin dhe organizimin e hapësirave të banimit. Jam shum e përkushtuar ndaj cdo detaji dhe kujdesem ...',
        isSuperPunetor: true,
        isFavorite: false, 
      ),
    ];

    // Calculate the central location
    _calculateCentralLocation();

    notifyListeners();
  }

  // Function to remove a tasker from the favorites list
  void removeTaskerFromFavorites(Tasker tasker) {
    int taskerIndex = _taskers.indexOf(tasker);
    
    if (taskerIndex != -1) {
      _taskers[taskerIndex] = Tasker(
        fullName: tasker.fullName,
        location: tasker.location,
        rating: tasker.rating,
        profileImage: tasker.profileImage,
        mapProfileImage: tasker.mapProfileImage,
        phoneNumber: tasker.phoneNumber,
        email: tasker.email,
        skills: tasker.skills,
        bio: tasker.bio,
        isSuperPunetor: tasker.isSuperPunetor,
        isFavorite: false, // Set isFavorite to false
      );

      notifyListeners(); // Notify listeners to update the UI
    }
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
