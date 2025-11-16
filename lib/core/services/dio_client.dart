import 'package:dio/dio.dart';
import '../../config/constants/api_constants.dart';
import '../utils/storage_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectionTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to all requests
          final token = await StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            try {
              await _refreshToken();
              // Retry the request
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              // Refresh failed, logout user
              await StorageService.clearAll();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _refreshToken() async {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await _dio.post(
      ApiConstants.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode == 200) {
      final newToken = response.data['data']['token'];
      await StorageService.saveToken(newToken);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
