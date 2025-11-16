import 'package:get/get.dart';
import '../models/article_model.dart';

class DetailController extends GetxController {
  late ArticleModel article;
  
  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as ArticleModel;
  }
  void shareArticle() {
    Get.snackbar(
      'Info',
      'Share will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
    void bookmarkArticle() {
    Get.snackbar(
      'Info',
      'Article bookmarked successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
