import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';

class HomeController extends GetxController {
  final NewsApiService _apiService = NewsApiService();
  
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;
  
  final RxBool isLoading = false.obs;
  
  final RxString errorMessage = ''.obs;
  
  final RxString selectedCategory = 'general'.obs;
  
  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];
  
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }
  
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiService.getTopHeadlines(
        country: 'us',
        category: selectedCategory.value,
      );
      
      articles.value = response.articles;
      
    } catch (e) {
      errorMessage.value = 'Failed to load news: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshNews() async {
    await fetchNews();
  }
  
  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
  }
  
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      fetchNews();
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiService.searchNews(query);
      articles.value = response.articles;
      
    } catch (e) {
      errorMessage.value = 'Failed to search news: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
