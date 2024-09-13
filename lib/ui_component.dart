abstract class UIComponent {
  final String key;

  UIComponent(this.key);

  factory UIComponent.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'container':
        return ContainerComponent.fromJson(json);
      case 'column':
        return ColumnComponent.fromJson(json);
      case 'text':
        return TextComponent.fromJson(json);
      case 'button':
        return ButtonComponent.fromJson(json);
      default:
        return PlaceholderComponent(key: json['key']);
    }
  }
}

class ContainerComponent extends UIComponent {
  final int backgroundColor;
  final int padding;
  final UIComponent child;

  ContainerComponent({
    required String key,
    required this.backgroundColor,
    required this.padding,
    required this.child,
  }) : super(key);

  factory ContainerComponent.fromJson(Map<String, dynamic> json) {
    return ContainerComponent(
      key: json['key'],
      backgroundColor: int.parse(json['data']['backgroundColor']),
      padding: json['data']['padding'],
      child: UIComponent.fromJson(json['data']['child']),
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
    return ColumnComponent(
      key: json['key'],
      children: (json['data']['children'] as List)
          .map((child) => UIComponent.fromJson(child))
          .toList(),
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
}

class ButtonComponent extends UIComponent {
  final UIComponent child;
  final String actionType;
  final String? url;
  final String? screenTitle;

  ButtonComponent({
    required String key,
    required this.child,
    required this.actionType,
    this.url,
    this.screenTitle,
  }) : super(key);

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      key: json['key'],
      child: UIComponent.fromJson(json['data']['child']),
      actionType: json['data']['event']['actionType'],
      url: json['data']['event']['url'],
      screenTitle: json['data']['event']['screenTitle'],
    );
  }
}

class PlaceholderComponent extends UIComponent {
  PlaceholderComponent({required String key}) : super(key);
}