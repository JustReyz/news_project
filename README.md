# 📱 News App Project

Flutter Based Project with [NewsAPI.org](https://newsapi.org)

## 🚀 Overview
A simple Flutter application that fetches and displays the latest news articles using the NewsAPI.org service.  
This project demonstrates integration of REST API with Flutter, state management, and clean architecture.

---

## 🛠️ Requirements
- Flutter & Dart SDK (sdk: ^3.9.0 or above)
- NewsAPI.org account (for API key)

---

## 🔑 Setup API Key
You must add your **NewsAPI key** in the file:

`lib/services/news_api_service.dart`  
**Line 8**:

```dart
class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your NewsAPI key
  ...
  ...
}
```
Replace "YOUR_NEWS_API_KEY" with your actual key from NewsAPI.org.


## ▶️ How to Run
1. Clone this repository:
```
git clone https://github.com/JustReyz/news_project.git
cd news_project
```
2. Install dependencies:
```
flutter pub get
```
3. Run the app:
```
flutter run
```


## 📄 License
This project is for educational purposes. Feel free to modify and expand.
