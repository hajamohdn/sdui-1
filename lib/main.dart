import 'package:flutter/material.dart';
import 'ui_service.dart';
import 'component_factory.dart';
import 'ui_component.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<UIComponent>(
        future: UIService().fetchUIConfig(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Failed to load UI configuration')),
            );
          } else {
            return DynamicScreen(component: snapshot.data!);
          }
        },
      ),
    );
  }
}

class DynamicScreen extends StatelessWidget {
  final UIComponent component;

  const DynamicScreen({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic UI from API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ComponentFactory.buildComponent(component, context),
      ),
    );
  }
}
