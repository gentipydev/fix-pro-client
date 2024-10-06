import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/services/dio_client.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:logger/logger.dart';

class AccountDetailsService {
  Logger logger = Logger();
  final DioClient dioClient = DioClient();
  final FakeData fakeData = FakeData();

  // Fetch user profile data (simulated)
  Future<User> fetchUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment and use real network call later
    // try {
    //   final response = await dioClient.dio.get('/account');
    //   return User.fromJson(response.data);
    // } catch (e) {
    //   logger.e("Error fetching user profile: $e");
    //   rethrow;
    // }

    // Use fake data for now
    return fakeData.fakeUser;
  }

  // Update user profile data (simulated)
  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment and use real network call later
    // try {
    //   await dioClient.dio.put('/account', data: userData);
    //   logger.d("User profile successfully updated on the server.");
    //   return true;
    // } catch (e) {
    //   logger.e("Error updating user profile: $e");
    //   return false;
    // }

    logger.d("Simulating user profile update with data: $userData");
    // Simulate updating fake data
    fakeData.updateFakeUser(userData);
    return true;
  }

  // Upload user profile picture (simulated)
  Future<String?> uploadProfilePicture(dynamic image) async {
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment and use real network call later
    // try {
    //   final response = await dioClient.dio.post('/account/upload', data: FormData.fromMap({
    //     'file': await MultipartFile.fromFile(image.path),
    //   }));
    //   return response.data['profile_picture_url'];
    // } catch (e) {
    //   logger.e("Error uploading profile picture: $e");
    //   return null;
    // }

    logger.d("Simulating profile picture upload");
    return 'fake_uploaded_profile_picture_url'; // Simulate URL of uploaded image
  }
}
