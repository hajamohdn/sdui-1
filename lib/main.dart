import 'package:flutter/material.dart';
import 'package:pookie/ui_builder.dart';
import 'package:pookie/ui_component.dart';
import 'package:pookie/ui_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Derived UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UIComponent> futureUIComponent;

  @override
  void initState() {
    super.initState();
    futureUIComponent = UIService().fetchUIConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Derived UI'),
      ),
      body: FutureBuilder<UIComponent>(
        future: futureUIComponent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return UIBuildService(context).buildUI(snapshot.data!);
          }
        },
      ),
    );
  }
}
