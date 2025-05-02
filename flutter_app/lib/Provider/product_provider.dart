import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => [..._products];

  final String baseUrl = 'http://localhost:3000/api/prod';

  Future<void> fetchProducts() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      print('🧾 Response status: ${res.statusCode}');
      print('🧾 Response body: ${res.body}');

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body); // 👈 FIXED

        _products.clear();
        _products.addAll(data.map((e) => Product.fromJson(e)).toList());

        notifyListeners();
        print('✅ Products fetched successfully');
      } else {
        print("❌ Server error: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Exception during fetch: $e");
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        body: json.encode(product.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseBody = json.decode(res.body);
        final newProduct = Product.fromJson(
          responseBody['data'] ?? responseBody,
        );
        _products.add(newProduct);
        notifyListeners();
      } else {
        print("❌ Add product failed: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Exception during add: $e");
    }
  }

  Product findById(String id) =>
      _products.firstWhere((element) => element.id == id);

  Future<void> updateProduct(String id, Product updated) async {
    final url = '$baseUrl/$id';
    try {
      final res = await http.put(
        Uri.parse(url),
        body: json.encode(updated.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final index = _products.indexWhere((prod) => prod.id == id);
        if (index != -1) {
          _products[index] = updated;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print("❌ Update error: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    // Use 10.0.2.2 for Android emulator, otherwise keep localhost
    final url = 'http://localhost:3000/api/prod/$id';

    print("🧨 Attempting to delete product with ID: $id");
    try {
      final res = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Response status: ${res.statusCode}');
      print('📡 Response body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 204) {
        _products.removeWhere((element) => element.id == id);
        notifyListeners();
        print("✅ Product deleted successfully");
      } else {
        throw Exception('Failed to delete product: ${res.statusCode}');
      }
    } catch (e) {
      print("❌ Delete error: $e");
      rethrow;
    }
  }
}
