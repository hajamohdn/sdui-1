import 'package:flutter/material.dart';
import 'ui_builder.dart';
import 'ui_component.dart';

class DynamicScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  DynamicScreen({this.data});

  @override
  Widget build(BuildContext context) {
    UIBuildService uiService = UIBuildService(context);

    // You can pass the JSON for the second screen here
    String screenKey = data != null ? 'second_screen' : 'first_screen';

    // Fetch the JSON based on the key or from the API
    UIComponent screenComponent = _getScreenComponent(screenKey, data);

    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Screen')),
      body: uiService.buildUI(screenComponent),
    );
  }

  UIComponent _getScreenComponent(String key, Map<String, dynamic>? data) {
    // Here, return the component based on key, use real API or data
    if (key == 'second_screen') {
      return UIComponent(
        type: 'Container',
        properties: {
          'key': 'containerKey',
          'color': '#ffffff',
          'padding': 20,
          'alignment': 'center',
        },
        children: [
          UIComponent(
            type: 'Text',
            properties: {
              'key': 'textKey',
              'style': 'header1',
              'text': 'Welcome to the second screen!',
            },
          ),
          UIComponent(
            type: 'Text',
            properties: {
              'key': 'dataTextKey',
              'style': 'header1',
              'text': 'Received data: ${data?['name']}, Age: ${data?['age']}',
            },
          ),
        ],
      );
    }

    // Default first screen or other screen logic
    return UIComponent(
      type: 'Container',
      properties: {
        'key': 'containerKey',
        'color': '#ff0000',
        'padding': 20,
        'alignment': 'center',
      },
      children: [
        UIComponent(
          type: 'Text',
          properties: {
            'key': 'textKey',
            'style': 'header1',
            'text': 'This is the first screen!',
          },
        ),
      ],
    );
  }
}