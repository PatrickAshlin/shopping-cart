import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String apiUrl = "https://dummyjson.com/products";

  static Future<List<Product>> fetchProducts({
    int page = 1,
    int limit = 10,
  }) async {
    final int skip = (page - 1) * limit;
    final response = await http.get(
      Uri.parse("$apiUrl?limit=$limit&skip=$skip"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['products'] is List) {
        return (jsonData['products'] as List)
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Unexpected API response format");
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
