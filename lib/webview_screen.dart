import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewScreen extends StatelessWidget {
  final String url;

  const WebviewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Webview"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onWebViewCreated: (controller) {
          // You can use controller for additional customization or JavaScript injection
        },
        onLoadStart: (controller, url) {
          // Handle any start of the webview load actions here
        },
        onLoadStop: (controller, url) {
          // Handle any webview load stop actions here
        },
      ),
    );
  }
}