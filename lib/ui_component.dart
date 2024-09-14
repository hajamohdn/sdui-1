import 'package:flutter/material.dart';

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
  Widget toWidget();
}

class ContainerComponent extends UIComponent {
  final UIComponent child;
  final double padding;
  final int backgroundColor;

  ContainerComponent({
    required String key,
    required this.child,
    required this.padding,
    required this.backgroundColor,
  }) : super(key);

  factory ContainerComponent.fromJson(Map<String, dynamic> json) {
    return ContainerComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      padding: json['data']['padding'] ??
          8.0, // Default to 8.0 if padding is not provided
      backgroundColor: int.parse(json['data']['backgroundColor']),
    );
  }

  @override
  Widget toWidget() {
    return Container(
      padding: EdgeInsets.all(padding),
      color: Color(backgroundColor),
      child: child.toWidget(),
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
  Widget toWidget() {
    return Column(
      children: children.map((child) => child.toWidget()).toList(),
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
  Widget toWidget() {
    return Text(text);
  }
}

class ButtonComponent extends UIComponent {
  final String label;
  final String actionUrl; // Assuming the button will trigger a URL action

  ButtonComponent({
    required String key,
    required this.label,
    required this.actionUrl,
  }) : super(key);

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      key: json['key'],
      label: json['data']['label'], // Button label text
      actionUrl: json['data']['actionUrl'], // URL to navigate when clicked
    );
  }

  @override
  Widget toWidget() {
    return ElevatedButton(
      onPressed: () {
        // Handle the button action, like navigating or opening a WebView
        // For now, just printing the URL as an example
        print('Navigating to: $actionUrl');
      },
      child: Text(label),
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
  Widget toWidget() {
    return Image.network(imageUrl);
  }
}

class CardComponent extends UIComponent {
  final UIComponent child;
  final double elevation;
  final int color;

  CardComponent({
    required String key,
    required this.child,
    required this.elevation,
    required this.color,
  }) : super(key);

  factory CardComponent.fromJson(Map<String, dynamic> json) {
    return CardComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      elevation: json['data']['elevation'],
      color: int.parse(json['data']['color']),
    );
  }

  @override
  Widget toWidget() {
    return Card(
      color: Color(color),
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child.toWidget(),
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
  Widget toWidget() {
    return const Placeholder();
  }
}
