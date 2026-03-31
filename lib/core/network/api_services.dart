import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

enum ApiCallMethod { get, post }

class ApiRequest {
  final String endPoint;
  final ApiCallMethod method;
  final Map<String, dynamic> body;
  final Map<String, dynamic>? queryParameters;

  ApiRequest.get(this.endPoint, {this.queryParameters})
      : body = {},
        method = ApiCallMethod.get;
  ApiRequest.post(this.endPoint, {required this.body, this.queryParameters})
      : method = ApiCallMethod.post;
}

@lazySingleton
class ApiServices {
  final String baseUrl;
  final http.Client client = http.Client();

  ApiServices(@Named('baseUrl') this.baseUrl);

  Future<Map<String, dynamic>> call(ApiRequest apiRequest) async {
    try {
      Uri url = Uri.parse(baseUrl + apiRequest.endPoint);
      if (apiRequest.queryParameters != null) {
        // Filter out null values and convert to string
        final params = <String, String>{};
        apiRequest.queryParameters!.forEach((key, value) {
          if (value != null) {
            params[key] = value.toString();
          }
        });
        url = url.replace(queryParameters: params);
      }
      
      final requestBody = apiRequest.body;
      final encodeRequestBody = jsonEncode(requestBody);

      http.Response response;

      if (kDebugMode) {
        print("Request URL: $url");
      }

      switch (apiRequest.method) {
        case ApiCallMethod.get:
          response = await client.get(url);
          break;
        case ApiCallMethod.post:
          response = await client.post(
            url, 
            body: encodeRequestBody, 
            headers: {'Content-Type': 'application/json'},
          );
          break;
      }
      return parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("API Call Error: $e");
      }
      return handleError(e);
    }
  }

  Future<Map<String, dynamic>> parseResponse(http.Response response) async {
    try {
      final decodedResponseBody = jsonDecode(response.body);
      final Map<String, dynamic> sendBackResponse = {"statusCode": response.statusCode};
      
      if (decodedResponseBody is Map) {
        decodedResponseBody.forEach((key, value) {
          sendBackResponse[key.toString()] = value;
        });
      } else if (decodedResponseBody is List) {
        sendBackResponse["data"] = decodedResponseBody;
      }
      
      if (kDebugMode) {
        print("Response Data $sendBackResponse");
      }
      return sendBackResponse;
    } catch (e) {
      if (kDebugMode) {
        print("Parse Response Error: $e");
      }
      return handleError(e);
    }
  }

  Map<String, dynamic> handleError(Object e) {
    final sendBackResponse = {"status": 0, "message": e.toString(), "statusCode": 500};
    if (kDebugMode) {
      print("Handled Error: $sendBackResponse");
    }
    return sendBackResponse;
  }
}
