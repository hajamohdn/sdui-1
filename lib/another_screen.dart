import 'package:flutter/material.dart';
import 'package:pookie/ui_component.dart';
import 'package:pookie/ui_service.dart';

class AnotherScreen extends StatefulWidget {
  final String url;
  const AnotherScreen({required this.url, super.key});

  @override
  State<AnotherScreen> createState() => _AnotherScreenState();
}

class _AnotherScreenState extends State<AnotherScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<UIComponent>(
          future: UIService().fetchUIConfig(widget.url),
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
