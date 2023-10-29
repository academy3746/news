import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/constants/gaps.dart';
import 'package:news/constants/sizes.dart';

//ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  static String routeName = "/detail";

  dynamic newsItem;

  DetailScreen({
    super.key,
    required this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "뒤로가기",
            style: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(
            Sizes.size24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image ['urlToImage']
              SizedBox(
                height: Sizes.size250,
                width: double.infinity,
                child: newsItem['urlToImage'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Sizes.size10,
                        ),
                        child: Image.network(
                          newsItem['urlToImage'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Sizes.size10,
                        ),
                        child: Image.asset("assets/images/no_image.png"),
                      ),
              ),
              // News Title ['title']
              Gaps.v32,
              Text(
                newsItem['title'],
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // News Datetime ['publishedAt']
              Gaps.v10,
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatDate(newsItem['publishedAt']),
                  style: const TextStyle(
                    fontSize: Sizes.size12,
                  ),
                ),
              ),
              // News Body ['description']
              Gaps.v32,
              newsItem['description'] != null
                  ? Text(newsItem['description'])
                  : const Text("해당 기사 내용이 없습니다."),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatTime = DateFormat("yyyy.MM.dd HH:mm");

    return formatTime.format(dateTime);
  }
}
