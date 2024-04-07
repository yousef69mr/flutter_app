import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constants/file_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ApiConfig {
  static String? _token;

  static String get baseUrl => '${dotenv.env['BACKEND_DOMAIN']}';

  static String get apiBaseUrl => '${dotenv.env['BACKEND_DOMAIN']}/api';

  static const int _timeoutLimit = 10;

  static setToken(String token) {
    _token = token;
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$apiBaseUrl$endpoint');
    final client = http.Client();

    try {
      // print(client);
      final response = await client
          .get(
            url,
            headers:
                _token != null ? {'Authorization': 'Bearer $_token'} : null,
          )
          .timeout(const Duration(seconds: _timeoutLimit));

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
      var response = await client
          .post(
            url,
            headers: _token != null
                ? {
                    'Authorization': 'Bearer $_token',
                    'Content-Type': 'application/json',
                  }
                : {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: _timeoutLimit));

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

  static Future<Map<String, dynamic>> uploadFile(
    String url, {
    required String mediaType,
    required String method,
    required String filename,
  }) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath(mediaType, filename));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
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
    }
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, String> data, {
    Map<String, List<XFile?>>? files,
  }) async {
    final url = Uri.parse('$apiBaseUrl$endpoint');

    http.Client client = http.Client();

    try {
      http.MultipartRequest request = http.MultipartRequest('PATCH', url);

      // Add headers
      request.headers.addAll(_token != null
          ? {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'multipart/form-data',
            }
          : {'Content-Type': 'multipart/form-data'});

      // Add data fields
      request.fields.addAll(data);

      // Add files
      if (files != null) {
        for (var fieldName in files.keys) {
          var fileList = files[fieldName];
          if (fileList != null) {

            print(fileList);
            for (var file in fileList) {
              if (file != null) {
                String filename = basename(file.path);
                // Convert XFile to bytes
                List<int> fileBytes = await file.readAsBytes();

                // Determine file type based on extension
                String fileType = fileDetector(filename)['type']!;
                String fileExtension = fileDetector(filename)['extension']!;

                // Add file to the request
                http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
                  fieldName,
                  fileBytes,
                  filename: filename, // Get the filename from XFile path
                  contentType: MediaType(fileType, fileExtension),
                );

                // Convert XFile to http.MultipartFile
                request.files.add(multipartFile);
              }
            }
          }
        }
      }

      // Send request
      var response = await client
          .send(request)
          .timeout(const Duration(seconds: _timeoutLimit));

      // Read response
      var responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = json.decode(responseBody);

      // Check status code
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
