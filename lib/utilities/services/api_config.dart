import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  static String? _token;

  static String get baseUrl => '${dotenv.env['BACKEND_DOMAIN']}';

  static String get apiBaseUrl => '${dotenv.env['BACKEND_DOMAIN']}/api';

  static setToken(String token) {
    _token = token;
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$apiBaseUrl$endpoint');
    final client = http.Client();

    try {
      // print(client);
      final response = await client.get(
        url,
        headers: _token != null ? {'Authorization': 'Bearer $_token'} : null,
      );

      Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        // Request failed with error message
        throw responseData["message"];
      }
      // Successful request
      return responseData;
    } catch (e) {
      // Request failed due to an error
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$apiBaseUrl$endpoint');

    var client = http.Client();

    try {
      var response = await client.post(
        url,
        headers: _token != null
            ? {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
              }
            : {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      Map<String, dynamic> responseData = json.decode(response.body);

      if (![200, 201].contains(response.statusCode)) {
        // Request failed with error message
        throw responseData["message"];
      }
      // Successful request
      return responseData;
    } catch (e) {
      // Request failed due to an error
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> patch(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$apiBaseUrl$endpoint');

    var client = http.Client();

    try {
      var response = await client.patch(
        url,
        headers: _token != null
            ? {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
              }
            : {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        // Request failed with error message
        throw responseData["message"];
      }
      // Successful request
      return responseData;
    } catch (e) {
      // Request failed due to an error
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    } finally {
      client.close();
    }
  }
}
