import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:new_chat/models/article_model.dart';
import 'package:new_chat/pages/article_view.dart';
import 'package:new_chat/services/news.dart';

class ViewAllPage extends StatefulWidget {
  final String news; // Make news parameter final
  final String category;
  final String name; // Add a name property

  ViewAllPage({required this.news, required this.category, required this.name});

  @override
  _ViewAllPageState createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  List<ArticleModel> articles = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    setState(() {
      articles = newsclass.news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return AllNewsSection(
            Image: articles[index].urlToImage ?? '',
            desc: articles[index].description ?? '',
            title: articles[index].title ?? '',
            url: articles[index].url ?? '',
          );
        },
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  final String Image, desc, title, url;

  AllNewsSection({
    required this.Image,
    required this.desc,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)),
        );
      },
      child: Container(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: Image,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              desc,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
