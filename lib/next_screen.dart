import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  final String title;

  const NextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Welcome to $title', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}