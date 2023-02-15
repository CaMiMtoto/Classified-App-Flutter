import 'dart:convert';

import 'package:classifieds_app/models/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isAuthenticated() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  return token != null;
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<void> login(token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}

Future<String?>? getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  return token;
}

Future<User?>? getCurrentUser() async {
  String? jwtToken = await getToken();
  if (jwtToken == null) return null;

  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

// Access the payload data
  String name = decodedToken['name'];
  String userId = decodedToken['_id'];
  String email = decodedToken['email'];
  return User(id: userId, name: name, email: email);
}
