import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sdui/view/next_view.dart';
import 'package:sdui/components/webview_component.dart';
import 'package:http/http.dart' as http;

Map<String, String> scoresData = {};

abstract class UIComponent {
  final String key;

  UIComponent(this.key);

  factory UIComponent.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      switch (json['type'].toString().toLowerCase()) {
        case 'container':
          return ContainerComponent.fromJson(json);
        case 'visibility':
          return VisibilityComponent.fromJson(json);
        case 'center':
          return ContainerComponent.fromJson(json);
        case 'padding':
          return PaddingComponent.fromJson(json);
        case 'column':
          return ColumnComponent.fromJson(json);
        case 'expanded':
          return ExpandedComponent.fromJson(json);
        case 'row':
          return RowComponent.fromJson(json);
        case 'appbar':
          return AppBarComponent.fromJson(json);
        case 'image':
          return ImageComponent.fromJson(json);
        // case 'spacer':
        //   return SpacerComponent.fromJson(json);
        case 'text':
          return TextComponent.fromJson(json);
        case 'button_with_api':
          return ButtonComponentWithAPICalls.fromJson(json);
        case 'button':
          return ButtonComponent.fromJson(json);
        case 'card':
          return CardComponent.fromJson(json);
        case 'future_builder':
          return FutureBuilderComponents.fromJson(json);
        default:
          return PlaceholderComponent(key: json['key'] ?? "");
      }
    } else if (json is List) {
      return ColumnComponent(
        key: 'auto-generated-column',
        children:
            json.map((childJson) => UIComponent.fromJson(childJson)).toList(),
      );
    } else {
      throw Exception('Unexpected JSON format: ${json.runtimeType}');
    }
  }

  Widget toWidget(BuildContext context);

  Map<String, dynamic> toJson();
}

Color getColors(String color) {
  switch (color.toLowerCase()) {
    case 'white':
      return Colors.white;
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.white;
  }
}

double convertDouble(String? height) => double.tryParse(height ?? "0") ?? 0.0;

double getPadding(String? padding) => double.tryParse(padding ?? "0") ?? 0.0;

class ContainerComponent extends UIComponent {
  final UIComponent child;
  final Color? backgroundColor;
  final double padding;
  final double? height;
  final double? width;

  ContainerComponent({
    key,
    required this.padding,
    required this.child,
    this.backgroundColor,
    this.height,
    this.width,
  }) : super(key);

  factory ContainerComponent.fromJson(Map<String, dynamic> json) {
    return ContainerComponent(
      key: json['key'] ?? "",
      backgroundColor: json['color'] != null ? getColors(json['color']) : null,
      padding: getPadding(json['padding']?.toString()),
      child: UIComponent.fromJson(json['child']),
      // height: getHeight(json['height']?.toString()),
      width: json.containsKey('width') ? json['width'] : null,
    );
  }

  @override
  Widget toWidget(context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      padding: EdgeInsets.all(padding),
      // height: height ?? double.infinity,
      // width: width ?? double.infinity,
      child: child.toWidget(context),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'container',
      'key': key,
      'backgroundColor': backgroundColor?.value.toString(),
      'padding': padding,
      'height': height,
      'width': width,
      'child': child.toJson(), // Recursive serialization
    };
  }
}

class VisibilityComponent extends UIComponent {
  final bool? isVisible;
  final UIComponent child;

  VisibilityComponent({
    key,
    this.isVisible,
    required this.child,
  }) : super(key);

  factory VisibilityComponent.fromJson(Map<String, dynamic> json) {
    return VisibilityComponent(
      key: json['key'] ?? "",
      isVisible: json['isVisible'],
      child: UIComponent.fromJson(json['child']),
    );
  }

  @override
  Widget toWidget(context) {
    return Visibility(
      visible: isVisible ?? false,
      child: child.toWidget(context),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'visibility',
      'key': key,
      'isVisible': isVisible ?? false,
      'child': child.toJson(),
    };
  }
}

class CenterComponent extends UIComponent {
  final UIComponent child;

  CenterComponent({
    key,
    required this.child,
  }) : super(key);

  factory CenterComponent.fromJson(Map<String, dynamic> json) {
    return CenterComponent(
      child: UIComponent.fromJson(json['child']),
    );
  }

  @override
  Widget toWidget(context) {
    return Center(
      // height: height ?? double.infinity,
      // width: width ?? double.infinity,
      child: child.toWidget(context),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'center',
      'key': key,
      'child': child.toJson(), // Recursive serialization
    };
  }
}

class PaddingComponent extends UIComponent {
  final UIComponent child;
  final double padding;

  PaddingComponent({
    key,
    required this.padding,
    required this.child,
  }) : super(key);

  factory PaddingComponent.fromJson(Map<String, dynamic> json) {
    return PaddingComponent(
      key: json['key'] ?? "",
      padding: getPadding(json['padding']?.toString()),
      child: UIComponent.fromJson(json['child']),
    );
  }

  @override
  Widget toWidget(context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child.toWidget(context),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'container',
      'key': key,
      'padding': padding,
      'child': child.toJson(), // Recursive serialization
    };
  }
}

class ColumnComponent extends UIComponent {
  final MainAxisAlignment? alignment;
  final List<UIComponent> children;

  ColumnComponent({
    key,
    this.alignment,
    required this.children,
  }) : super(key);

  factory ColumnComponent.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'];

    if (childrenJson is List) {
      List<UIComponent> children = childrenJson
          .map((childJson) => UIComponent.fromJson(childJson))
          .toList();

      return ColumnComponent(
        key: json['key'] ?? "",
        alignment: getMainAxisAlignment(json["alignment"]),
        children: children,
      );
    } else {
      throw Exception('Expected a list of children in ColumnComponent');
    }
  }

  @override
  Widget toWidget(context) {
    return Column(
      mainAxisAlignment: alignment ?? MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: children.map((child) => child.toWidget(context)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'column',
      'key': key,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

MainAxisAlignment getMainAxisAlignment(String? align) {
  switch (align ?? "") {
    case "center":
      return MainAxisAlignment.center;
    case "spaceBetween":
      return MainAxisAlignment.spaceBetween;
    case "start":
      return MainAxisAlignment.start;
    case "end":
      return MainAxisAlignment.end;

    default:
      return MainAxisAlignment.center;
  }
}

class RowComponent extends UIComponent {
  final List<UIComponent> children;
  final MainAxisAlignment? mainAxisAlignment;
  final double padding;

  RowComponent({
    key,
    this.mainAxisAlignment,
    required this.padding,
    required this.children,
  }) : super(key);

  factory RowComponent.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'];

    if (childrenJson is List) {
      List<UIComponent> children = childrenJson
          .map((childJson) => UIComponent.fromJson(childJson))
          .toList();

      return RowComponent(
        key: json['key'] ?? "",
        padding: convertDouble(json["padding"]?.toString()),
        mainAxisAlignment: getMainAlignment(json["mainAxisAlignment"]),
        children: children,
      );
    } else {
      throw Exception('Expected a list of children in RowComponent');
    }
  }

  @override
  Widget toWidget(context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: children.map((child) => child.toWidget(context)).toList(),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'row',
      'key': key,
      'mainAxisAlignment': mainAxisAlignment.toString().split('.').last,
      'padding': padding,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

MainAxisAlignment getMainAlignment(String? mainAxisAlignment) {
  switch (mainAxisAlignment ?? "") {
    case "center":
      return MainAxisAlignment.center;
    case "end":
      return MainAxisAlignment.end;
    case "spaceAround":
      return MainAxisAlignment.spaceAround;
    case "spaceBetween":
      return MainAxisAlignment.spaceBetween;
    case "spaceEvenly":
      return MainAxisAlignment.spaceEvenly;
    case "start":
      return MainAxisAlignment.start;
    default:
      return MainAxisAlignment.center;
  }
}

class TextComponent extends UIComponent {
  final String text;
  final double? padding;

  TextComponent({
    key,
    required this.text,
    this.padding,
  }) : super(key);

  factory TextComponent.fromJson(Map<String, dynamic> json) {
    return TextComponent(
        key: json['key'] ?? "",
        text: json['text'],
        padding: getPadding(json['padding']?.toString()));
  }

  @override
  Widget toWidget(context) {
    String textFromApi = "";
    if (scoresData.keys.contains(text)) {
      for (var i = 0; i < scoresData.length; i++) {
        if (scoresData.keys.elementAt(i) == text) {
          textFromApi = scoresData.values.elementAt(i);
        }
      }
    }
    return Padding(
      padding:
          padding != null ? EdgeInsets.all(padding ?? 0.0) : EdgeInsets.zero,
      child: textFromApi != "" ? Text(textFromApi) : Text(text),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'text',
      'padding': padding,
      'key': key,
      'text': text,
    };
  }
}

class AppBarComponent extends UIComponent {
  final String title;
  final String leadAction;
  final UIComponent child;
  final Color? color;

  AppBarComponent({
    key,
    required this.title,
    required this.leadAction,
    required this.child,
    this.color,
  }) : super(key);

  factory AppBarComponent.fromJson(Map<String, dynamic> json) {
    return AppBarComponent(
      key: json['key'] ?? "",
      title: json['title'],
      leadAction: json['leadAction'],
      color: getColors(json['color']),
      child: UIComponent.fromJson(json['child']),
    );
  }

  @override
  Widget toWidget(context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          child.toWidget(context),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      "type": "appbar",
      "color": color,
      "title": title,
      "leadAction": leadAction,
      "child": child.toJson(),
    };
  }
}

class SpacerComponent extends UIComponent {
  SpacerComponent({
    key,
  }) : super(key);

  factory SpacerComponent.fromJson(Map<String, dynamic> json) {
    return SpacerComponent(key: json['key'] ?? "");
  }

  @override
  Widget toWidget(context) {
    return const Spacer();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'spacer',
    };
  }
}

class ButtonComponent extends UIComponent {
  final UIComponent child;
  final String actionType;
  final String? url;
  final double? padding;
  final String? firebaseEvent;

  ButtonComponent({
    key,
    required this.child,
    required this.actionType,
    required this.padding,
    required this.firebaseEvent,
    this.url,
  }) : super(key);

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      key: json['key'] ?? "",
      child: UIComponent.fromJson(json['child']),
      actionType: json['actionType'],
      url: json['url'],
      padding: getPadding(json['padding']?.toString()),
      firebaseEvent: json['firebaseEvent'],
    );
  }

  @override
  Widget toWidget(context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0.0),
      child: ElevatedButton(
        onPressed: () {
          if (firebaseEvent != null) {
            print("firebaseEvent : $firebaseEvent ");
          }
          if (actionType == "push_and_call_api" && url != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnotherScreen(
                        url: url ?? "",
                      )),
            );
          } else if (actionType == 'open_webview' && url != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebviewScreen(url: url!)),
            );
            print('Opening WebView: $url');
          } else {
            print('Action triggered: $actionType');
          }
        },
        child: child.toWidget(context),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': 'button',
      'data': {
        'event': {
          'actionType': actionType,
          'url': url,
        },
        'padding': padding,
        'firebaseEvent': {'event_name': firebaseEvent},
        'child': child.toJson(), // recursively serialize child component
      },
    };
  }
}

class ButtonComponentWithAPICalls extends UIComponent {
  final UIComponent child;
  final String? apiUrl;
  final String method;
  final Map<String, dynamic>? body;
  final double padding;

  ButtonComponentWithAPICalls({
    key,
    required this.padding,
    required this.child,
    this.apiUrl,
    this.method = 'GET',
    this.body,
  }) : super(key);

  factory ButtonComponentWithAPICalls.fromJson(Map<String, dynamic> json) {
    return ButtonComponentWithAPICalls(
      key: json['key'] ?? "",
      child: UIComponent.fromJson(json['child']),
      apiUrl: json['event']?['apiUrl'],
      method: json['event']?['method'] ?? 'GET',
      body: json['event']?['body'],
      padding: getPadding(json['padding']?.toString()),
    );
  }

  @override
  Widget toWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton(
        onPressed: () async {
          if (apiUrl != null) {
            await makeApiCall(context);
          }
        },
        child: child.toWidget(context),
      ),
    );
  }

  Future<void> makeApiCall(BuildContext context) async {
    // API logic here
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'button_with_api',
      'key': key,
      'padding': padding,
      'event': {
        'apiUrl': apiUrl,
        'method': method,
        'body': body,
      },
      'child': child.toJson(),
    };
  }
}

class ImageComponent extends UIComponent {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final int? width;

  ImageComponent({
    key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
  }) : super(key);

  factory ImageComponent.fromJson(Map<String, dynamic> json) {
    return ImageComponent(
      key: json['key'] ?? "",
      imageUrl: json['url'],
      fit: getFit(json['fit']),
      height: convertDouble(json['height']?.toString()),
    );
  }

  @override
  Widget toWidget(context) {
    return Image.network(
      imageUrl,
      fit: fit,
      height: height?.toDouble(),
      width: width?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'image',
      'key': key,
      'data': {
        'url': imageUrl,
      },
    };
  }
}

BoxFit getFit(String? fit) {
  switch (fit ?? "") {
    case "contain":
      return BoxFit.contain;
    case "cover":
      return BoxFit.cover;
    case "fill":
      return BoxFit.fill;
    case "fitHeight":
      return BoxFit.fitHeight;
    case "fitWidth":
      return BoxFit.fitWidth;
    default:
      return BoxFit.contain;
  }
}

class ExpandedComponent extends UIComponent {
  final UIComponent child;
  final int? flex;

  ExpandedComponent({
    key,
    this.flex,
    required this.child,
  }) : super(key);

  factory ExpandedComponent.fromJson(Map<String, dynamic> json) {
    return ExpandedComponent(
      key: json["key"] ?? "",
      flex: json["flex"],
      child: UIComponent.fromJson(json['child']),
    );
  }

  @override
  Widget toWidget(context) {
    return Expanded(
      flex: flex ?? 1,
      child: child.toWidget(context),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'image',
      'key': key,
      "child": child.toJson(),
    };
  }
}

class CardComponent extends UIComponent {
  final UIComponent child;
  final double? elevation;
  final Color? color;
  final double? height;
  final double? width;
  final double padding;

  CardComponent({
    key,
    required this.padding,
    this.elevation,
    required this.child,
    this.color,
    this.height,
    this.width,
  }) : super(key);

  factory CardComponent.fromJson(Map<String, dynamic> json) {
    return CardComponent(
      key: json['key'] ?? "",
      padding: convertDouble(json["padding"]?.toString()),
      child: UIComponent.fromJson(json['child']),
      elevation: convertDouble(json['elevation']?.toString()),
      color: json['color'] != null ? getColors(json["color"]) : null,
      height:
          json['height'] == null ? double.infinity : json['height']?.toDouble(),
      width:
          json['width'] == null ? double.infinity : json['width']?.toDouble(),
    );
  }

  @override
  Widget toWidget(context) {
    return Card(
      elevation: elevation,
      color: color,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SizedBox(
          // height: height,
          width: width,
          child: child.toWidget(context),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'card',
      'key': key,
      'data': {
        'padding': padding,
        'child': child.toJson(),
        'elevation': elevation,
        'color': color?.value.toString(),
        'height': height,
        'width': width,
      },
    };
  }
}

class FutureBuilderComponents extends UIComponent {
  final UIComponent child;
  final String url;
  final String method;

  FutureBuilderComponents({
    key,
    required this.url,
    required this.method,
    required this.child,
  }) : super(key);

  factory FutureBuilderComponents.fromJson(Map<String, dynamic> json) {
    return FutureBuilderComponents(
      key: json['key'] ?? "",
      url: json["url"],
      method: json["method"],
      child: UIComponent.fromJson(json['child']),
    );
  }

  Future<List> fetchData(String url) async {
    log("FutureBuilderComponents - url : $url");
    final response = await http.get(Uri.parse(url));
    log("FutureBuilderComponents - response : $response");
    if (response.statusCode == 200) {
      log("FutureBuilderComponents - status code : ${response.statusCode}");
      var json = jsonDecode(response.body);
      for (var i = 0; i < json[0].length; i++) {
        final scrMap = <String, String>{
          json[0].keys.elementAt(i): json[0].values.elementAt(i)
        };
        scoresData.addEntries(scrMap.entries);
      }
      log("from store_data : $scoresData");
      log("FutureBuilderComponents - json : $json");
      return json;
    } else {
      return [];
    }
  }

  @override
  Widget toWidget(context) {
    Future<List> futureBuilderCom = fetchData(url);
    return FutureBuilder<List>(
      future: futureBuilderCom,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else {
          return child.toWidget(context);
        }
      },
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'future_builder',
      'key': key,
      "url": url,
      "method": method,
      "child": child.toJson(),
    };
  }
}

class PlaceholderComponent extends UIComponent {
  PlaceholderComponent({key}) : super(key);

  factory PlaceholderComponent.fromJson(Map<String, dynamic> json) {
    return PlaceholderComponent(key: json['key'] ?? "");
  }

  @override
  Widget toWidget(context) {
    return const Placeholder();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'placeholder',
      'key': key,
    };
  }
}
