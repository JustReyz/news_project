import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEWS - MVC'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchNews,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.articles.isEmpty) {
                return const Center(
                  child: Text('No news available.', style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              
              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  itemCount: controller.articles.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return _buildNewsCard(article);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      color: AppColors.surface,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory.value == category;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => controller.changeCategory(category),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.background,
            ),
          );
        },
      )),
    );
  }
  
  Widget _buildNewsCard(article) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.detail, arguments: article);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.background,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.background,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      if (article.author != null) ...[
                        const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.author!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(article.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Search news'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Enter keywords...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Get.back();
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
