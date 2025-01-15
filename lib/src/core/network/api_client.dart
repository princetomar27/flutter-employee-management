import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE;

  String get method {
    switch (this) {
      case HttpMethod.GET:
        return 'GET';
      case HttpMethod.POST:
        return 'POST';
      case HttpMethod.PUT:
        return 'PUT';
      case HttpMethod.DELETE:
        return 'DELETE';
    }
  }
}

abstract class APIRouter {
  String get path;

  Map<String, String>? get queryParams;

  Map<String, String>? get headers;

  dynamic get body;
}

class ApiClient {
  final http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Future<http.Response> request(
    HttpMethod method,
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    dynamic body,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Set headers for form-data if required
    if (method == HttpMethod.POST || method == HttpMethod.PUT) {
      // Handling form-data for POST and PUT requests
      headers ??= {}; // Ensure headers are not null
      if (body is Map<String, String>) {
        headers['Content-Type'] = 'application/x-www-form-urlencoded';
        body = body.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }
    }

    try {
      switch (method) {
        case HttpMethod.GET:
          return await httpClient.get(uri, headers: headers);
        case HttpMethod.POST:
          return await httpClient.post(uri, headers: headers, body: body);
        case HttpMethod.PUT:
          return await httpClient.put(uri, headers: headers, body: body);
        case HttpMethod.DELETE:
          return await httpClient.delete(uri, headers: headers, body: body);
      }
    } catch (error) {
      debugPrint("Error making request: $error");
      rethrow;
    }
  }

  Future<http.Response> getRequest(APIRouter route) {
    return request(
      HttpMethod.GET,
      'https://apimis.in/recib/wapi${route.path}',
      headers: route.headers,
      queryParams: route.queryParams,
    );
  }

  Future<http.Response> postRequest(APIRouter route) {
    return request(
      HttpMethod.POST,
      'https://apimis.in/recib/wapi${route.path}',
      headers: route.headers,
      queryParams: route.queryParams,
      body: route.body,
    );
  }

  Future<http.Response> putRequest(APIRouter route) {
    return request(
      HttpMethod.PUT,
      'https://apimis.in/recib/wapi${route.path}',
      headers: route.headers,
      queryParams: route.queryParams,
      body: route.body,
    );
  }

  Future<http.Response> deleteRequest(APIRouter route) {
    return request(
      HttpMethod.DELETE,
      'https://apimis.in/recib/wapi${route.path}',
      headers: route.headers,
      queryParams: route.queryParams,
      body: route.body,
    );
  }
}
