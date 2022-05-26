import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class GetWebsites {
  Future<List<Document>> getWebsite() async {
    List<Document> websites = [];
    for(int t=1;t<6;t++){
      String url = "https://www.karl-heine-schule-leipzig.de/Vertretung/V_DC_00"+t.toString()+".html";
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
}