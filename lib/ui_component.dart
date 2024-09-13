class UIComponent {
  final String type;
  final Map<String, dynamic> properties;
  final List<UIComponent>? children;
  final Map<String, dynamic>?
      event; // <-- Add this field for events (actions like push, pop, etc.)

  UIComponent({
    required this.type,
    required this.properties,
    this.children,
    this.event, // <-- Initialize the event field
  });

  factory UIComponent.fromJson(Map<String, dynamic> json) {
    return UIComponent(
      type: json['type'],
      properties: Map<String, dynamic>.from(json['properties']),
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => UIComponent.fromJson(child))
              .toList()
          : null,
      event: json['event'], // <-- Parse the event field from JSON
    );
  }
}
