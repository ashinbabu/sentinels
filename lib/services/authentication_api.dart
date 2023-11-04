import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:busco/models/user.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/providers/user_details_provider.dart';
import 'package:busco/utils/constants.dart';

class AuthenticationApi {
  // static final baseURL = 'https://services.mimiandbowbow.com/api';

  //1. Login request to Api
  static Future<bool> loginRequest(AuthProvider authProvider,
      {required email, required password}) async {
    bool success = false;
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}login'));

    request.fields.addAll({
      'email': email,
      'password': password,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      if (body["status"] == "success") {
        authProvider.setAuthToken(
            body['data']["token"], body['data']["user_id"]);

        success = true;
      } else if (body['status'] == 'failure') {
        authProvider.errorMessage = body['error'];
      } else {
        authProvider.errorMessage = 'Something went wrong';
      }
    } else {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);
      print(body);

      if (body["status"] == 'failure') {
        if (body.containsKey('error')) {
          authProvider.errorMessage = body['error'];
        } else {
          authProvider.errorMessage = 'Something went wrong';
        }
      }
    }
    return success;
  }

  //2.Register a new user Api
  static Future<bool> registerUserRequest(
    AuthProvider authProvider, {
    required name,
    required email,
    required password,
    required confirmPass,
  }) async {
    bool success = false;

    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}register'));
    request.fields.addAll({
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPass
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      print(body);

      if (body["status"] == 'failure') {
        success = true;
      } else {
        print(body['error']['email'][0]);
      }
    } else {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      if (body['error'].containsKey('email')) {
        authProvider.errorMessage = body['error']['email'][0];
      } else if (body['error'].containsKey('name')) {
        authProvider.errorMessage = body['error']['name'][0];
      } else if (body['error'].containsKey('password')) {
        authProvider.errorMessage = body['error']['password'][0];
      } else if (body['error'].containsKey('confirm_password')) {
        authProvider.errorMessage = body['error']['confirm_password'][0];
      } else {
        authProvider.errorMessage = 'Something went wrong';
      }
    }

    return success;
  }

  //3.Get profile details with Auth token
  static getProfileDetailsRequest(AuthProvider authProvider,
      UserDetailsProvider userDetailsProvider) async {
    bool success = false;

    final request = http.MultipartRequest(
        'GET', Uri.parse('${baseUrl}user/data?user_id=${authProvider.userId}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      if (body["status"] == 'success') {
        userDetailsProvider.setUserDetails(User.fromMap(body['data']));
        print(body);
        success = true;
      }
    } else {
      print(response.stream.bytesToString());
    }
    return success;
  }

  //4. User profile update api

  static updateProfile(AuthProvider authProvider,
      UserDetailsProvider userDetailsProvider, User userDetails) async {
    print('update profile called');
    final headers = {'Authorization': 'Bearer ${authProvider.authToken}'};
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}update/user'));

    request.fields.addAll({
      'name': userDetails.name,
      'nationality': userDetails.nationality,
      'phone': userDetails.phone,
      'address': userDetails.address
    });
    print(request.fields);

    request.headers.addAll(headers);
    final response = await request.send();
    var body;
    print(response.statusCode);
    if (response.statusCode == 201) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      body = json.decode(responseString);
      return "success";
    } else {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      return "fail";
    }
  }
  //5. Profile pic update

  static updateProfilePic(AuthProvider authProvider, path) async {
    bool success = false;

    var headers = {'Authorization': 'Bearer ${authProvider.authToken}'};
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}update/image'));
    request.files.add(await http.MultipartFile.fromPath('picture', path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      if (body['status'] == 'success') {
        success = true;
      }
    } else {
      print(response.reasonPhrase);
    }

    return success;
  }

  static googleLogin(AuthProvider authProvider, email, name) async {
    var body;
    bool success = false;
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}google/login'));
    request.fields.addAll({'email': '$email', 'name': '$name'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      body = await response.stream.bytesToString();
      if (json.decode(body)["status"] == "failure") {
        if (json.decode(body)["error"] ==
            "A fresh verification link has been sent to your email address.") {
          return 'Please verify your email using the link sent yo your inbox';
        } else {
          return json.decode(body)["error"];
        }
      } else if (json.decode(body)["status"] == "success") {
        authProvider.setAuthToken(json.decode(body)['data']["token"],
            json.decode(body)['data']["user_id"]);
        success = true;

        return success;
      }
    } else {
      body = await response.stream.bytesToString();
      if (json.decode(body)["error"] == true) {
        print(json.decode(body)["errorMessage"]);
        return success;
      }
    }
    return success;
  }

  
  static changeCurrency(AuthProvider authProvider, id) async {
    bool success = false;

    var headers = {'Authorization': 'Bearer ${authProvider.authToken}'};
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}change/currency'));
    request.fields.addAll({'id': '$id'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);

      if (body['status'] == 'success') {
        success = true;
      }
    } else {
      print(response.reasonPhrase);
    }

    return success;
  }

}