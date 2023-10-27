// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  static String routeName = "/main";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];

  /// GET News info from [newspai.org]
  Future<void> getNewsInfo() async {
    const apiKey = "228e79b0edb94ac8af43a22e2bed6c50";
    const apiUrl =
        "https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey";

    // Network Communication Request
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        lstNewsInfo = responseData["articles"];

        for (var element in lstNewsInfo) {
          print(element);
        }
      } else {
        throw Exception("Communication failed: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
