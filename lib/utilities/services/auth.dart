import "package:flutter/material.dart";
import "package:flutter_application_1/models/user.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:image_picker/image_picker.dart";
import "package:jwt_decoder/jwt_decoder.dart";
import "package:flutter_application_1/utilities/sql_database.dart";
import "package:flutter_application_1/utilities/secure_storage.dart";
import "api_config.dart";
// import 'dart:io';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;

  bool get authenticated => _isLoggedIn;

  User? get user => _user;

  String? get authToken => _token;

  final SqlDatabase _sqlDatabase = SqlDatabase();

  Future<void> initial() async {
    // get token from secure folder
    // print(await _storage.readAll());
    String? storedToken = await SecureStorage.getItem("auth_token");
    // print(storedToken);
    //no logged user before
    if (storedToken == null || storedToken.isEmpty) {
      return;
    }

    bool isValid = isTokenValid(storedToken);
    // print(isValid);
    if (!isValid) {
      return;
    }

    // Decode the token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(storedToken);
    // print(decodedToken);
    //fetch user from sqflite

    // List<Map<String, dynamic>> usersQuery = await _sqlDatabase.readData(
    //     "SELECT * FROM 'users' ");

    // print(usersQuery);

    List<Map<String, dynamic>> query = await _sqlDatabase.readData(
        "SELECT * FROM 'users' WHERE id = '${decodedToken['user']['id']}'");

    // print(query);
    if (query.isNotEmpty) {
      _user = User.fromJson(query[0]);
      _isLoggedIn = true;
      _token = storedToken;
    }

    // print(_user);

    // notifyListeners();
  }

  bool isTokenValid(String token) {
    try {
      // Check if token is expired
      bool isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        // Token is expired
        // print('Token is expired');
        return false;
      } else {
        // Token is valid
        // print('Token is valid');
        return true;
      }
    } catch (e) {
      // Token is invalid
      // print('Token is invalid: $e');
      return false;
    }
  }

  Future<void> login({required Map<String, dynamic> credentials}) async {
    //login api call
    final responseData = await ApiConfig.post('/login', credentials);
    await tryToken(token: responseData["token"]);

    // print(_user);
    if (_user != null) {
      // save user in sqflite if not exists

      List<Map<dynamic, dynamic>> storedUser = await _sqlDatabase
          .readData("SELECT * FROM 'users' WHERE id = '${_user!.id}'");

      // print(storedUser);

      if (storedUser.isEmpty) {
        // insert new User
        await _sqlDatabase.insertData('''
  INSERT INTO users(id, name, email, password, avatar, studentId, level, gender,role) VALUES('${_user!.id}', '${_user!.name}', '${_user!.email}', '${_user!.password}', ${_user!.avatar}, '${_user!.studentId}', '${_user!.level}', '${_user!.gender}', '${_user!.role}')
''');
      } else {
        //update existing User
        await _sqlDatabase.updateData('''
  UPDATE 'users' 
  SET name='${_user!.name}', email='${_user!.email}', password='${_user!.password}', studentId='${_user!.studentId}', level='${_user!.level}'${_user!.avatar != null ? ", gender='${_user!.gender}'" : ""}, role='${_user!.role}'
            WHERE id='${_user!.id}';
            ''');
      }

// print(_token);
    }

    // print(authenticated);
    // print(_user);
    // print(_token);
    notifyListeners();
  }

  Future<void> register({required Map<String, dynamic> userData}) async {
    final responseData = await ApiConfig.post('/register', userData);
    await tryToken(token: responseData["token"]);

    if (_user != null) {
      // save user in sqflite
      // try {
      await _sqlDatabase.insertData('''
            INSERT INTO users (id, name, email, password, studentId, level,
            gender, role)
        VALUES(
            '${_user!.id}',
            '${_user!.name}',
            '${_user!.email}',
            '${_user!.password}',
            '${_user!.studentId}',
            '${_user!.level}',
            '${_user!.gender}',
            '${_user!.role}')
        ''');
    }
    notifyListeners();
  }

  Future<void> updateUser({
    required Map<String, String> userData,
    Map<String, List<XFile?>>? files,
  }) async {
    if (_token == null) {
      throw "no token provided";
    }

    ApiConfig.setToken(_token!);
    Map<String, dynamic> responseData =
        await ApiConfig.patch('/users/${_user?.id}', userData, files: files);
    _user = User.fromJson(responseData);
    // print(_user);
    //  update to sqflite

    await _sqlDatabase.updateData('''
        UPDATE users
        SET name = '${_user!.name}',
            email = '${_user!.email}',
            password = '${_user!.password}',
            studentId = '${_user!.studentId}',
            level = '${_user!.level}',
            ${_user!.gender != null ? "gender='${_user!.gender}'," : ""}
            ${_user!.avatar != null ? "avatar='${_user!.avatar}'," : ""}
            role = '${_user!.role}'
        WHERE id = '${_user!.id}';
        ''');
    //tryToken(token: responseData["token"]);

    notifyListeners();
  }

  Future<void> tryToken({String? token}) async {
    if (token == null) {
      throw "no token provided";
    }

    // get active user api
    ApiConfig.setToken(token);
    Map<String, dynamic> data = await ApiConfig.get(
      '/active_user',
    );

    // print(data);
    _user = User.fromJson(data);
    _isLoggedIn = true;
    _token = token;

    try {
      // Save token securely
      await SecureStorage.setItem("auth_token", token);
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
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    _token = null;

    // delete token from secure folder
    SecureStorage.removeItem("auth_token");
    notifyListeners();
  }
}
