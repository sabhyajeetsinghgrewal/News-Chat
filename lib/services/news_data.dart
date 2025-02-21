import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_chat/models/show_category.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String apiKey = 'your_api_key_here'; // Replace with your API key
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          jsonData["articles"].forEach((element) {
            if (element["urlToImage"] != null &&
                element['description'] != null) {
              ShowCategoryModel categoryModel = ShowCategoryModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                urlToImage: element["urlToImage"],
                content: element["content"],
                author: element["author"],
              );
              categories.add(categoryModel);
            }
          });
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
