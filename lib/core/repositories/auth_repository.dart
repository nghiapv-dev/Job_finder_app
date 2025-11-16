import 'package:dio/dio.dart';
import '../services/dio_client.dart';
import '../utils/storage_service.dart';
import '../../config/constants/api_constants.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['data']['token'];
        final refreshToken = response.data['data']['refreshToken'];
        
        await StorageService.saveToken(token);
        await StorageService.saveRefreshToken(refreshToken);
        
        return response.data['data']['user'];
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final token = response.data['data']['token'];
        final refreshToken = response.data['data']['refreshToken'];
        
        await StorageService.saveToken(token);
        await StorageService.saveRefreshToken(refreshToken);
        
        return response.data['data']['user'];
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Login with Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Implement Google Sign-In logic here
      // This is a placeholder - you'll need to implement actual Google Sign-In
      throw UnimplementedError('Google Sign-In not implemented yet');
    } catch (e) {
      throw Exception('Google login error: $e');
    }
  }

  /// Login with Facebook
  Future<Map<String, dynamic>> loginWithFacebook() async {
    try {
      // Implement Facebook Sign-In logic here
      // This is a placeholder - you'll need to implement actual Facebook Sign-In
      throw UnimplementedError('Facebook Sign-In not implemented yet');
    } catch (e) {
      throw Exception('Facebook login error: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout API to invalidate token on server
      await _dioClient.dio.post(ApiConstants.logout);
    } catch (e) {
      // Continue with local logout even if API fails
    } finally {
      // Clear local storage
      await StorageService.clearAll();
    }
  }

  /// Forgot password - send reset code
  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password reset email sent';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send reset email');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Reset password with code
  Future<String> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Password reset successful';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Get current user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get user');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await StorageService.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Handle Dio errors
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'];
        if (statusCode == 401) {
          return message ?? 'Invalid credentials.';
        } else if (statusCode == 404) {
          return message ?? 'Resource not found.';
        } else if (statusCode == 500) {
          return message ?? 'Server error. Please try again later.';
        }
        return message ?? 'An error occurred. Please try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
