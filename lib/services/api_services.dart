import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/content_model.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<List<ContentItem>> getContentList(String type) async {
    try {
      final endpoint = ApiConstants.endpoints[type];
      if (endpoint == null) throw Exception('Invalid content type');

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => ContentItem.fromJson(json, type)).toList();
      } else {
        throw Exception('Failed to load $type');
      }
    } catch (e) {
      throw Exception('Error fetching $type: $e');
    }
  }

  Future<ContentItem> getContentDetail(String type, int id) async {
    try {
      final endpoint = ApiConstants.endpoints[type];
      if (endpoint == null) throw Exception('Invalid content type');

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint/$id/'),
      );

      if (response.statusCode == 200) {
        return ContentItem.fromJson(json.decode(response.body), type);
      } else {
        throw Exception('Failed to load $type detail');
      }
    } catch (e) {
      throw Exception('Error fetching $type detail: $e');
    }
  }
}
