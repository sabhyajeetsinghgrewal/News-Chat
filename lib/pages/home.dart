import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_chat/models/article_model.dart';
import 'package:new_chat/models/slider_model.dart';
import 'package:new_chat/pages/article_view.dart';
import 'package:new_chat/pages/view_all.dart'; // Import ViewAllPage
import 'package:new_chat/pages/chatting.dart'; // Import Chatting Page
import 'package:new_chat/services/news.dart';
import 'package:new_chat/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    getSlider();
    getNews();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    setState(() {
      articles = newsclass.news;
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    setState(() {
      sliders = slider.sliders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(
            255, 75, 150, 255), // Match with the page background color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.16,
            ),
            Text(
              'News ',
              style: TextStyle(
                color: Colors.black, // Match with the text color of the page
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Chat',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 242,
                    0), // Match with the accent color of the page
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 75, 150, 255),
                          Color.fromARGB(255, 75, 150, 255)
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0),
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: ClipPath(
                                clipper: BottomCurveClipper(),
                                child: Image.asset(
                                  'images/building.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: buildCategoryCard(
                                  'images/science.jpg',
                                  'Science',
                                  () => navigateToCategoryNews('science'),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: buildCategoryCard(
                                  'images/business.jpg',
                                  'Business',
                                  () => navigateToCategoryNews('business'),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: buildCategoryCard(
                                  'images/sport.jpg',
                                  'Sports',
                                  () => navigateToCategoryNews('sports'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Breaking News!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        CarouselSlider.builder(
                          itemCount: sliders.length,
                          itemBuilder: (context, index, realIndex) {
                            String? imageUrl = sliders[index].urlToImage;
                            String? title = sliders[index].title;
                            return buildImage(imageUrl!, title!);
                          },
                          options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: activeIndex,
                            count: 5,
                            effect: SlideEffect(
                              dotWidth: 20,
                              dotHeight: 15,
                              activeDotColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Trending News!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return BlogTile(
                                url: articles[index].url!,
                                desc: articles[index].description!,
                                imageUrl: articles[index].urlToImage!,
                                title: articles[index].title!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chatting(),
                        ),
                      );
                    },
                    child: Container(
                      width: 80, // Increased width for zoom effect
                      height: 130, // Increased height for zoom effect
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage('images/chat.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildCategoryCard(String imagePath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.asset(
                imagePath,
                height: 50,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String image, String name) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 250,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: image,
              ),
            ),
            Container(
              height: 250,
              padding: EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(top: 90.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                name,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  void navigateToCategoryNews(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAllPage(
          category: category,
          news: '',
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = 30.0; // adjust the height of the curve
    Path path = Path();
    path.lineTo(0, size.height - height);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;

  BlogTile({
    required this.desc,
    required this.imageUrl,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          desc,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
