import 'package:flutter/material.dart';
import 'package:pookie/dynamic_screen.dart';
import 'ui_component.dart';

class UIBuildService {
  final BuildContext context;

  UIBuildService(this.context);

  Widget buildUI(UIComponent component) {
    switch (component.type) {
      case 'Text':
        return Text(
          component.properties['text'] ?? '',
          style: _getTextStyle(component.properties['style']),
        );
      case 'Container':
        return Container(
          key: Key(component.properties['key'] ?? ''),
          color: _parseColor(component.properties['color']),
          padding: EdgeInsets.all(component.properties['padding'] ?? 0.0),
          alignment: _parseAlignment(component.properties['alignment']),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                component.children?.map((child) => buildUI(child)).toList() ??
                    [],
          ),
        );
      case 'Button':
        return ElevatedButton(
          key: Key(component.properties['key'] ?? ''),
          onPressed: () {
            _handleAction(component.event);
          },
          child: Text(component.properties['text'] ?? 'Button'),
        );
      default:
        return Container();
    }
  }

  void _handleAction(Map<String, dynamic>? event) async {
    if (event == null) return;

    String action = event['action'] ?? '';
    String? target = event['target'];
    Map<String, dynamic>? data = event['data'];
    switch (action) {
      case 'push':
        if (target != null) {
          _navigateTo(target, data);
        }
        break;
      case 'pushReplacement':
        if (target != null) {
          _replaceWith(target, data);
        }
        break;
      case 'pop':
        Navigator.pop(context, data);
        break;
      default:
        print('Unknown action: $action');
    }
  }

  void _navigateTo(String target, Map<String, dynamic>? data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicScreen(data: data),
        settings: RouteSettings(name: target),
      ),
    );
  }

  void _replaceWith(String target, Map<String, dynamic>? data) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicScreen(data: data),
        settings: RouteSettings(name: target),
      ),
    );
  }

  TextStyle _getTextStyle(String? style) {
    switch (style) {
      case 'header1':
        return TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      default:
        return TextStyle(fontSize: 14);
    }
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return Colors.transparent;
    final buffer = StringBuffer();
    if (colorString.length == 6 || colorString.length == 7) buffer.write('ff');
    buffer.write(colorString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Alignment _parseAlignment(String? alignment) {
    switch (alignment) {
      case 'center':
        return Alignment.center;
      default:
        return Alignment.center;
    }
  }
}
