import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class GetWebsites {
  static const String rootUrl =
      "https://www.karl-heine-schule-leipzig.de:443/Vertretung/";

  Future<List<Document>> getWebsite() async {
    List<Document> websites = [];
    // get site-urls for available days
    List<String> urls = await getAvailableDays(rootUrl);
    print(urls.length);
    urls.forEach((url) async {
      // executes the code below for every element (url) in the list
      final getSite = await http.Client().get(Uri.parse(url));
      if(getSite.statusCode==200) {
      final response = utf8.decode(getSite.bodyBytes);
      Document document = parser.parse(response);
      websites.add(document);
      }
    });
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
        String? test = element.attributes["onclick"];
        String? test2 = test?.split("'")[1];
        if (element.attributes["onclick"] != null) {
          availableDays.add(rootUrl + test2!);
        }
      });
      return availableDays;
    } else {
      // TODO: Add Error message
      print("ERROR!");
      return [];
    }
  }
}