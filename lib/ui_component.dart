import 'package:flutter/material.dart';
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
        case 'button':
          return ButtonComponent.fromJson(json);
        // Add more components here like button, card, etc.
        case 'card':
          return CardComponent.fromJson(json);
        default:
          return PlaceholderComponent(key: json['key']);
      }
    } else if (json is List) {
      // If it's a list of components, return them all as a ColumnComponent.
      return ColumnComponent(
        key: 'auto-generated-column', // Or any key you'd prefer.
        children:
            json.map((childJson) => UIComponent.fromJson(childJson)).toList(),
      );
    } else {
      throw Exception('Unexpected JSON format: ${json.runtimeType}');
    }
  }

  // Convert UIComponent into a Flutter Widget
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
      height: height ?? double.infinity,
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

    // Ensure it's a list before trying to map it
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
  final UIComponent child; // A nested UI component (e.g., TextComponent)
  final String actionType; // The type of action when the button is pressed
  final String? url; // Optional URL for actions like opening a webview

  ButtonComponent({
    required String key,
    required this.child,
    required this.actionType,
    this.url,
  }) : super(key);

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      actionType: json['data']['event']['actionType'],
      url: json['data']['event']['url'],
    );
  }

  @override
  Widget toWidget(context) {
    return ElevatedButton(
      onPressed: () {
        if (actionType == 'open_webview' && url != null) {
          // Example of opening a WebView or triggering any action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebviewScreen(url: url!)),
          );
          print('Opening WebView: $url');
          // Call your WebView or navigation logic here
        } else {
          // Handle other action types if necessary
          print('Action triggered: $actionType');
        }
      },
      child: child.toWidget(
          context), // Render the nested child component (e.g., TextComponent)
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
      imageUrl: json['data']
          ['url'], // Assuming the image URL is stored under 'data'
    );
  }

  @override
  Widget toWidget(context) {
    return Image.network(imageUrl);
  }
}

class CardComponent extends UIComponent {
  final UIComponent child;
  final double elevation;
  final int color;
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
      elevation: json['data']['elevation'],
      color: int.parse(json['data']['color']),
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
    return Card(
      elevation: elevation,
      color: Color(color),
      child: SizedBox(
        height: height ??
            double.infinity, // Fill height if provided, otherwise let it expand
        width: width ??
            double.infinity, // Fill width if provided, otherwise let it expand
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
