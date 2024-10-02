import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioClient {
  Logger logger = Logger();
  static final DioClient _instance = DioClient._internal(); // Singleton instance
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 3000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Optionally, add interceptors for logging or token handling
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Modify the request (e.g., add authorization token)
        logger.d('Request: ${options.method} ${options.path}');
        return handler.next(options); // Continue the request
      },
      onResponse: (response, handler) {
        // Modify the response
        logger.d('Response: ${response.statusCode} ${response.data}');
        return handler.next(response); // Continue
      },
      onError: (DioException error, handler) {
        // Handle errors globally
        logger.d('Error: ${error.message}');
        return handler.next(error); // Continue the error
      },
    ));
  }
}
