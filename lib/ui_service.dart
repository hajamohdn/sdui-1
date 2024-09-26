import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ui_component.dart';

const String mainViewUrl = "https://657fe3c26ae0629a3f53cd6b.mockapi.io/pookie";
const String secondViewUrl =
    "https://657fe3c26ae0629a3f53cd6b.mockapi.io/page_2";

class UIService {
  Future<UIComponent> fetchUIConfig(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UIComponent.fromJson(json);
    } else {
      throw Exception('Failed to load UI configuration');
    }
  }
}
