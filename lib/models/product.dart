import 'dart:convert';
import 'dart:io';

import 'package:classifieds_app/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/auth.dart';
import 'category.dart';

class Product {
  final String id;
  final String name;
  final CategoryModel category;
  final String shorDescription;
  final double price;
  final String imageUrl;
  final String manufacturingDate;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.shorDescription,
    required this.price,
    required this.imageUrl,
    required this.manufacturingDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      name: json['name'] as String,
      category:
          CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      shorDescription: json['shortDescription'] as String,
      price: double.parse(json['price'].toString()),
      imageUrl: json['image'] as String,
      manufacturingDate: json['manufacturingDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
      'shorDescription': shorDescription,
      'price': price,
      'imageUrl': imageUrl,
      'manufacturingDate': manufacturingDate,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, shorDescription: $shorDescription, price: $price, imageUrl: $imageUrl, manufacturingDate: $manufacturingDate}';
  }
}

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchProducts(String? categoryId) async {
  var uri = '$baseUrl/products';
  if (categoryId != null) {
    uri = '$uri?category=$categoryId';
  }
  var token = await getToken();
  final response = await http.get(Uri.parse(uri), headers: {
    HttpHeaders.authorizationHeader: "bearer $token",
  });
  var body = response.body;
  return compute(parseProducts, body);
}
