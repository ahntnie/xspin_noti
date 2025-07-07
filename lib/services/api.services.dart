import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  // Header mặc định
  final Map<String, dynamic> _defaultHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    // Bạn có thể thêm các header mặc định khác nếu cần
    // 'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
  };

  ApiService() {
    dio.options.headers = _defaultHeaders;
  }

  // Kết hợp header mặc định với header tùy chỉnh
  Map<String, dynamic> _mergeHeaders(Map<String, dynamic>? customHeaders) {
    return {..._defaultHeaders, ...?customHeaders};
  }

  Future<Response> handleRedirect(
    Response response, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? customHeaders,
  }) async {
    if (response.statusCode == 302) {
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.post(
          newUrl,
          queryParameters: queryParameters,
          options: Options(
            headers: _mergeHeaders(customHeaders),
          ),
        );
      } else {
        throw Exception('No redirection URL found');
      }
    }
    return response;
  }

  Future<Response> getRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      Response response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: _mergeHeaders(customHeaders),
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.get(
            newUrl,
            queryParameters: queryParams,
            options: Options(
              headers: _mergeHeaders(customHeaders),
              followRedirects: false,
              validateStatus: (status) => status! < 500,
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> postRequest(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      Response response = await dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: _mergeHeaders(customHeaders),
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      response = await handleRedirect(
        response,
        queryParameters: queryParameters,
        customHeaders: customHeaders,
      );
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> patchRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      Response response;
      if (data != null) {
        response = await dio.patch(
          url,
          queryParameters: data,
          options: Options(
            headers: _mergeHeaders(customHeaders),
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        );
        response = await handleRedirect(
          response,
          queryParameters: data,
          customHeaders: customHeaders,
        );
      } else {
        response = await dio.patch(
          url,
          options: Options(
            headers: _mergeHeaders({
              ...?customHeaders,
              'Content-Type': 'multipart/form-data',
            }),
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        );
      }

      return response;
    } catch (e) {
      throw Exception('PATCH request error: $e');
    }
  }

  Future<Response> deleteRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      Response response = await dio.delete(
        url,
        queryParameters: data,
        options: Options(
          headers: _mergeHeaders(customHeaders),
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.delete(
            newUrl,
            queryParameters: data,
            options: Options(
              headers: _mergeHeaders(customHeaders),
              followRedirects: false,
              validateStatus: (status) => status! < 500,
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }
}
