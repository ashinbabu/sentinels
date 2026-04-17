import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:busco/models/user.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/providers/user_details_provider.dart';
import 'package:busco/services/api_client.dart';
import 'package:busco/utils/constants.dart';

class AuthenticationApi {
  static final baseURL = baseUrl;

  //1. Login request to Api
  static Future<bool> loginRequest(AuthProvider authProvider,
      {required String email, required String password}) async {
    bool success = false;
    final response = await ApiClient.postForm('login', fields: {
      'email': email,
      'password': password,
    });

    if (response.success && response.body['data'] is Map) {
      final data = response.body['data'] as Map;
      authProvider
          .setAuthToken(data["token"].toString(), int.tryParse(data["user_id"].toString()) ?? 0);
      success = true;
    } else {
      authProvider.errorMessage = response.error ?? 'Something went wrong';
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
    final response = await ApiClient.postForm('register', fields: {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPass
    });

    if (response.success) {
      success = true;
    } else if (response.body['error'] is Map) {
      final errors = response.body['error'] as Map;
      if (errors.containsKey('email')) {
        authProvider.errorMessage = errors['email'][0];
      } else if (errors.containsKey('name')) {
        authProvider.errorMessage = errors['name'][0];
      } else if (errors.containsKey('password')) {
        authProvider.errorMessage = errors['password'][0];
      } else if (errors.containsKey('confirm_password')) {
        authProvider.errorMessage = errors['confirm_password'][0];
      } else {
        authProvider.errorMessage = response.error ?? 'Something went wrong';
      }
    } else {
      authProvider.errorMessage = response.error ?? 'Something went wrong';
    }

    return success;
  }

  //3.Get profile details with Auth token
  static getProfileDetailsRequest(AuthProvider authProvider,
      UserDetailsProvider userDetailsProvider) async {
    bool success = false;
    final response = await ApiClient.get(
      'user/data',
      query: {'user_id': authProvider.userId},
    );

    if (response.success && response.body['data'] is Map) {
      userDetailsProvider
          .setUserDetails(User.fromMap(Map<String, dynamic>.from(response.body['data'])));
      success = true;
    } else {
      authProvider.errorMessage = response.error ?? 'Failed to get profile';
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
