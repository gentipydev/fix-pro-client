import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AuthState { uninitialized, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  final Logger logger = Logger();

  late AuthState _state = AuthState.uninitialized;
  AuthState get state => _state;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get isAuthenticatedSync => _accessToken != null;

  // Singleton instance
  static final AuthProvider _instance = AuthProvider._internal();

  // Factory constructor that returns the singleton instance
  factory AuthProvider() {
    return _instance;
  }

  // Private constructor
  AuthProvider._internal() {
    loadTokensFromStorage();
  }

  Future<void> loadTokensFromStorage() async {
    const storage = FlutterSecureStorage();
    _accessToken = await storage.read(key: 'access_token');
    _refreshToken = await storage.read(key: 'refresh_token');
    _state = _accessToken != null ? AuthState.authenticated : AuthState.unauthenticated;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    await loadTokensFromStorage();
    return _accessToken != null;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> deleteTokens() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
      _accessToken = null;
      _refreshToken = null;
      notifyListeners();
    } catch (e) {
      logger.i("Error deleting tokens: $e");
    }
  }

  Future<void> setCurrentUserEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserEmail', email.trim().toLowerCase());
  }

  Future<String?> getCurrentUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUserEmail')?.trim();
  }
}

