// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news/constants/gaps.dart';
import 'package:news/constants/sizes.dart';
import 'package:news/screens/detail_screen.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];

  /// GET News info from "https://newsapi.org" as jSON Format
  Future<void> _getNewsInfo() async {
    const apiKey = "228e79b0edb94ac8af43a22e2bed6c50";
    const apiUrl =
        "https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey";

    // Network Communication Request
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          lstNewsInfo = responseData["articles"];
        });
      } else {
        throw Exception("Communication failed: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatTime = DateFormat("yyyy.MM.dd HH:mm");

    return formatTime.format(dateTime);
  }

  @override
  void initState() {
    super.initState();

    _getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(
            Sizes.size10,
          ),
          child: Image.asset(
            "assets/images/splash.png",
            height: Sizes.size24,
            width: Sizes.size24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade700,
        title: const Text(
          "헤드라인 뉴진스",
          style: TextStyle(
            fontSize: Sizes.size24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          Sizes.size16,
        ),
        child: ListView.builder(
          itemCount: lstNewsInfo.length,
          itemBuilder: (BuildContext context, int index) {
            var newsItem = lstNewsInfo[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: newsItem,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(
                  Sizes.size16,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // News Image
                    SizedBox(
                      height: Sizes.size150 + Sizes.size20,
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
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              Sizes.size10,
                            ),
                            bottomRight: Radius.circular(
                              Sizes.size10,
                            ),
                          ),
                        ),
                      ),
                      height: Sizes.size58,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          Sizes.size6,
                        ),
                        child: Column(
                          children: [
                            // News Title
                            Text(
                              newsItem['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gaps.v10,
                            // News Datetime
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                formatDate(newsItem['publishedAt']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
