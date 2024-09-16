import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pookie/webview_screen.dart';

abstract class UIComponent {
  final String key;

  UIComponent(this.key);

  factory UIComponent.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      switch (json['type']) {
        case 'container':
          return ContainerComponent.fromJson(json);
        case 'column':
          return ColumnComponent.fromJson(json);
        case 'text':
          return TextComponent.fromJson(json);
        case 'button_with_api':
          return ButtonComponentWithAPICalls.fromJson(json);
        case 'button':
          return ButtonComponent.fromJson(json);
        // Add more components here like button, card, etc.
        case 'card':
          return CardComponent.fromJson(json);
        default:
          return PlaceholderComponent(key: json['key']);
      }
    } else if (json is List) {
      return ColumnComponent(
        key: 'auto-generated-column',
        children:
            json.map((childJson) => UIComponent.fromJson(childJson)).toList(),
      );
    } else {
      throw Exception('Unexpected JSON format: ${json.runtimeType}');
    }
  }

  Widget toWidget(BuildContext context);
}

class ContainerComponent extends UIComponent {
  final UIComponent child;
  final Color backgroundColor;
  final double padding;
  final double? height;
  final double? width;

  ContainerComponent({
    required String key,
    required this.child,
    required this.backgroundColor,
    required this.padding,
    this.height,
    this.width,
  }) : super(key);

  factory ContainerComponent.fromJson(Map<String, dynamic> json) {
    return ContainerComponent(
      key: json['key'],
      backgroundColor: Color(int.parse(json['data']['backgroundColor'])),
      padding: json['data']['padding']?.toDouble() ?? 0.0,
      child: UIComponent.fromJson(json['data']['child']),
      height: json['data'].containsKey('height')
          ? json['data']['height']?.toDouble()
          : null,
      width: json['data'].containsKey('width')
          ? json['data']['width']?.toDouble()
          : null,
    );
  }

  @override
  Widget toWidget(context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(padding),
      // height: height ?? double.infinity,
      width: width ?? double.infinity,
      child: child.toWidget(context),
    );
  }
}

class ColumnComponent extends UIComponent {
  final List<UIComponent> children;

  ColumnComponent({
    required String key,
    required this.children,
  }) : super(key);

  factory ColumnComponent.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['data']['children'];

    if (childrenJson is List) {
      List<UIComponent> children = childrenJson
          .map((childJson) => UIComponent.fromJson(childJson))
          .toList();

      return ColumnComponent(
        key: json['key'],
        children: children,
      );
    } else {
      throw Exception('Expected a list of children in ColumnComponent');
    }
  }

  @override
  Widget toWidget(context) {
    return Column(
      children: children.map((child) => child.toWidget(context)).toList(),
    );
  }
}

class TextComponent extends UIComponent {
  final String text;

  TextComponent({
    required String key,
    required this.text,
  }) : super(key);

  factory TextComponent.fromJson(Map<String, dynamic> json) {
    return TextComponent(
      key: json['key'],
      text: json['data']['text'],
    );
  }

  @override
  Widget toWidget(context) {
    return Text(text);
  }
}

class ButtonComponent extends UIComponent {
  final UIComponent child;
  final String actionType;
  final String? url;
  final int? padding;
  final String? firebaseEvent;

  ButtonComponent({
    required String key,
    required this.child,
    required this.actionType,
    required this.padding,
    required this.firebaseEvent,
    this.url,
  }) : super(key);

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      actionType: json['data']['event']['actionType'],
      url: json['data']['event']['url'],
      padding: json['data']['padding'],
      firebaseEvent: json['data']['firebaseEvent']?["event_name"],
    );
  }

  @override
  Widget toWidget(context) {
    return Padding(
      padding: EdgeInsets.all(padding?.toDouble() ?? 0.0),
      child: ElevatedButton(
        onPressed: () {
          if (firebaseEvent != null) {
            print("firebaseEvent : $firebaseEvent ");
          }
          if (actionType == 'open_webview' && url != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebviewScreen(url: url!)),
            );
            print('Opening WebView: $url');
          } else {
            print('Action triggered: $actionType');
          }
        },
        child: child.toWidget(context),
      ),
    );
  }
}

class ButtonComponentWithAPICalls extends UIComponent {
  final UIComponent child;
  final String? apiUrl;
  final String method;
  final Map<String, dynamic>? body;
  final int? padding;

  ButtonComponentWithAPICalls({
    required String key,
    required this.child,
    this.apiUrl,
    required this.padding,
    this.method = 'GET',
    this.body,
  }) : super(key);

  factory ButtonComponentWithAPICalls.fromJson(Map<String, dynamic> json) {
    return ButtonComponentWithAPICalls(
      key: json['key'] ?? 'unknown',
      child: UIComponent.fromJson(json['data']['child']),
      apiUrl: json['data']['event']?['apiUrl'],
      method: json['data']['event']?['method'] ?? 'GET',
      body: json['data']['event']?['body'],
      padding: json['data']['padding'],
    );
  }

  Future<void> makeApiCall(BuildContext context) async {
    if (apiUrl == null) {
      print('No API URL provided');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No API URL provided')),
      );
      return;
    }

    try {
      http.Response response;

      if (method == 'POST') {
        response = await http.post(
          Uri.parse(apiUrl!),
          headers: {'Content-Type': 'application/json'},
          body: body != null ? jsonEncode(body) : null,
        );
      } else {
        response = await http.get(Uri.parse(apiUrl!));
      }

      print('API Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success: ${response.body}')),
      );
    } catch (e) {
      print('Error making API call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget toWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding?.toDouble() ?? 0.0),
      child: ElevatedButton(
        onPressed: () async {
          await makeApiCall(context);
        },
        child: child.toWidget(context),
      ),
    );
  }
}

class ImageComponent extends UIComponent {
  final String imageUrl;

  ImageComponent({
    required String key,
    required this.imageUrl,
  }) : super(key);

  factory ImageComponent.fromJson(Map<String, dynamic> json) {
    return ImageComponent(
      key: json['key'],
      imageUrl: json['data']['url'],
    );
  }

  @override
  Widget toWidget(context) {
    return Image.network(imageUrl);
  }
}

class CardComponent extends UIComponent {
  final UIComponent child;
  final double? elevation;
  final Color color;
  final double? height;
  final double? width;

  CardComponent({
    required String key,
    required this.child,
    required this.elevation,
    required this.color,
    this.height,
    this.width,
  }) : super(key);

  factory CardComponent.fromJson(Map<String, dynamic> json) {
    return CardComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      elevation: json['data']['elevation']?.toDouble(),
      color: Color(int.parse(json['data']['color'])),
      height: json['data']['height'] == null
          ? double.infinity
          : json['data']['height']?.toDouble(),
      width: json['data']['width'] == null
          ? double.infinity
          : json['data']['width']?.toDouble(),
    );
  }

  @override
  Widget toWidget(context) {
    return Card(
      elevation: elevation,
      color: color,
      child: SizedBox(
        // height: height,
        width: width,
        child: child.toWidget(context),
      ),
    );
  }
}

class PlaceholderComponent extends UIComponent {
  PlaceholderComponent({required String key}) : super(key);

  factory PlaceholderComponent.fromJson(Map<String, dynamic> json) {
    return PlaceholderComponent(key: json['key']);
  }

  @override
  Widget toWidget(context) {
    return const Placeholder();
  }
}
