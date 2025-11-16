import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_response_model.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your NewsAPI key
  
  Future<NewsResponseModel> getTopHeadlines({
    String country = 'us',
    String? category,
  }) async {
    try {
      String url = '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey';
      
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
  
  Future<NewsResponseModel> searchNews(String query) async {
    try {
      final url = '$_baseUrl/everything?q=$query&apiKey=$_apiKey&sortBy=publishedAt';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}
