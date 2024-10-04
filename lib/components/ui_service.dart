// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'ui_component.dart';

const String mainViewUrl =
    "https://34.49.13.231.nip.io/dyn-screens/v1/screen1?apikey=WaqjGsSlJu8RMeamjEIpZYbEycwiPoz47AL4Es7ypFG7EIG7";
// "https://657fe3c26ae0629a3f53cd6b.mockapi.io/pookie";

class UIService {
  Future<UIComponent> fetchUIConfig(String url) async {
    log("sdui - url : $url");
    final response = await http.get(Uri.parse(url));
    log("sdui - response : $response");
    if (response.statusCode == 200) {
      log("sdui - status code : ${response.statusCode}");
      final json = jsonDecode(response.body);
      log("sdui - json : $json");
      return UIComponent.fromJson(json);
    } else {
      throw Exception('Failed to load UI configuration');
    }
  }
}
