import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class GetWebsites {
  String rootUrl = "https://www.karl-heine-schule-leipzig.de:443/Vertretung/";
  Future<List<Document>> getWebsite() async {
    List<Document> websites = [];
    // get site-urls for available days
    List<String> urls = await getAvailableDays(rootUrl);
    if (kDebugMode) {
      print("Number of read URLS: ${urls.length}");
    }
    for (var url in urls) {
      // executes the code below for every element (url) in the list
      final getSite = await http.Client().get(Uri.parse(url));
      if(getSite.statusCode!=200){
        break;
      }
      final response = utf8.decode(getSite.bodyBytes);
      Document document = parser.parse(response);
      websites.add(document);
    }
    return websites;
  }

  Future<List<String>> getAvailableDays(String mainpageUrl) async {
    // besser wäre es natürlich, wenn URI Datentypen zurückgegeben werden würden
    List<String> availableDays = [];

    final getSite = await http.Client().get(Uri.parse(mainpageUrl));
    if (getSite.statusCode == 200) {
      Document site = parser.parse(getSite.body);
      final data = site.querySelectorAll(".month-group .day");
      data.forEach((element) {
        String? dataUrl = element.attributes["onclick"]?.split("'")[1];
        availableDays.add(rootUrl + dataUrl!);
      });
      if (kDebugMode) {
        print("Website URLS: ${availableDays.toString()}");
      }
      return availableDays;
    } else {
      // TODO: Add Error message, Return something else
      if (kDebugMode) {
        print("getAvailableDays error!");
      }
      return [];
    }
  }
}