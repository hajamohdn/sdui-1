import 'package:flutter/material.dart';
import 'ui_service.dart';
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
      home: // Assuming the snapshot has a List<dynamic> and not a Map<String, dynamic>
          Scaffold(
        body: FutureBuilder<UIComponent>(
          future: UIService().fetchUIConfig(),
          builder: (BuildContext context, AsyncSnapshot<UIComponent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView(
                children: [snapshot.data!]
                    .map((component) => component.toWidget(context))
                    .toList(),
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}

class DynamicUIScreen extends StatelessWidget {
  final List<UIComponent> components;

  const DynamicUIScreen({super.key, required this.components});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic UI from API")),
      body: ListView(
        children:
            components.map((component) => component.toWidget(context)).toList(),
      ),
    );
  }
}
