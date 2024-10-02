import 'package:flutter/material.dart';
import 'components/ui_service.dart';
import 'components/ui_component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<UIComponent>(
          future: UIService().fetchUIConfig(mainViewUrl),
          builder: (BuildContext context, AsyncSnapshot<UIComponent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView(
                children: [snapshot.data!]
                    .map((component) => component.toWidget(context))
                    .toList(),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
