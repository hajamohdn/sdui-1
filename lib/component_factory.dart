import 'package:flutter/material.dart';
import 'ui_component.dart';
import 'webview_screen.dart';
import 'next_screen.dart';

class ComponentFactory {
  static Widget buildComponent(UIComponent component, BuildContext context) {
    if (component is ContainerComponent) {
      return Container(
        color: Color(component.backgroundColor),
        padding: EdgeInsets.all(component.padding.toDouble()),
        child: buildComponent(component.child, context),
      );
    } else if (component is ColumnComponent) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: component.children
            .map((child) => buildComponent(child, context))
            .toList(),
      );
    } else if (component is TextComponent) {
      return Text(
        component.text,
        style: const TextStyle(fontSize: 24),
      );
    } else if (component is ButtonComponent) {
      return ElevatedButton(
        onPressed: () {
          if (component.actionType == 'open_webview') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebviewScreen(url: component.url!)),
            );
          } else if (component.actionType == 'navigate') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NextScreen(title: component.screenTitle!)),
            );
          }
        },
        child: buildComponent(component.child, context),
      );
    } else {
      return const Placeholder();
    }
  }
}
