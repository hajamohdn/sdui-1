import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ui_component.dart';

class UIService {
  Future<UIComponent> fetchUIConfig() async {
    final response = await http
        .get(Uri.parse('https://657fe3c26ae0629a3f53cd6b.mockapi.io/pookie'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)[0];
      return UIComponent.fromJson(json);
    } else {
      throw Exception('Failed to load UI configuration');
    }
  }
}
