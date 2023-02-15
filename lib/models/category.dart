import 'dart:convert';
import 'dart:io';

import 'package:classifieds_app/utils/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? description;

  CategoryModel({required this.id, required this.name, this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description}';
  }
}

List<CategoryModel> parseCategories(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<CategoryModel>((json) => CategoryModel.fromJson(json))
      .toList();
}

Future<List<CategoryModel>> fetchCategories() async {
  var uri = '$baseUrl/categories';
  var token = await getToken();
  final response = await http.get(Uri.parse(uri), headers: {
    HttpHeaders.authorizationHeader: "bearer $token",
  });
  return compute(parseCategories, response.body);
}
