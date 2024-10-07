import 'package:flutter/material.dart';
import 'package:sdui/components/ui_component.dart';

void main() {
  // Card
  final cardOutContainer = ContainerComponent(
    key: "outlineCardKey",
    padding: 6,
    child: ColumnComponent(
      key: "key",
      children: [
        ContainerComponent(
            key: "key",
            child: RowComponent(
              children: [
                ColumnComponent(
                  key: "columnKey",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "Repayment History",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Hign Impact",
                    ),
                  ],
                ),
                ColumnComponent(
                  key: "column2Key",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "100%",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Excellent",
                    ),
                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              padding: 4,
            ),
            padding: 2),
        ContainerComponent(
            key: "key",
            child: RowComponent(
              children: [
                ColumnComponent(
                  key: "columnKey",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "Credit Urilisation",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Low Impact",
                    ),
                  ],
                ),
                ColumnComponent(
                  key: "column2Key",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "80%",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Excellent",
                    ),
                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              padding: 4,
            ),
            padding: 2),
        ContainerComponent(
            key: "key",
            child: RowComponent(
              children: [
                ColumnComponent(
                  key: "columnKey",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "Credit Age",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Hign Impact",
                    ),
                  ],
                ),
                ColumnComponent(
                  key: "column2Key",
                  children: [
                    TextComponent(
                      key: "cardHeading",
                      text: "40%",
                    ),
                    TextComponent(
                      key: "cardSubHeading",
                      text: "Excellent",
                    ),
                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              padding: 4,
            ),
            padding: 2),
      ],
    ),
  );

  final importantFactors = PaddingComponent(
      key: "",
      padding: 4,
      child: ContainerComponent(
        key: "key",
        padding: 4,
        child:
            ContainerComponent(key: "key", child: cardOutContainer, padding: 2),
      ));

  final initialView = ColumnComponent(
    key: "key",
    children: [
      ExpandedComponent(
          child: CenterComponent(child: TextComponent(key: "", text: ""))),
      ExpandedComponent(
          child: ButtonComponent(
              key: "key",
              child: TextComponent(key: "", text: ""),
              actionType: "push",
              padding: 4,
              firebaseEvent: "firebaseEvent"))
    ],
  );

  final dahsboardFactors = ContainerComponent(
    key: "key",
    child: ContainerComponent(
      key: "key",
      child: CardComponent(
          key: "key",
          child: RowComponent(
            padding: 0,
            children: [
              ExpandedComponent(
                child: CardComponent(
                  key: "key",
                  padding: 4,
                  elevation: 1,
                  child: CenterComponent(
                    child: TextComponent(
                      key: "key",
                      text: "782",
                    ),
                  ),
                ),
              ),
              ExpandedComponent(
                child: CardComponent(
                  key: "key",
                  padding: 4,
                  elevation: 1,
                  child: ColumnComponent(
                    key: "key",
                    children: [
                      TextComponent(
                        key: "key",
                        text: "Excellent",
                      ),
                      TextComponent(
                        key: "key",
                        text: "As of 02 sep 2024",
                      ),
                      ButtonComponent(
                          key: "key",
                          child: TextComponent(
                              key: "key", text: "Refresh in 7 days"),
                          actionType: "refresh_page",
                          padding: 6,
                          firebaseEvent: ""),
                    ],
                  ),
                ),
              ),
            ],
          ),
          elevation: 1,
          padding: 4),
      padding: 4,
    ),
    padding: 4,
  );
  //
  final textChild = TextComponent(key: 'text1', text: 'Click Me!');

  final imageComponent = ImageComponent(
    key: 'image1',
    imageUrl: 'https://example.com/image.png',
  );

  final buttonComponentWithAPICalls = ButtonComponentWithAPICalls(
    key: 'button1',
    child: textChild,
    apiUrl: 'https://api.example.com/click',
    method: 'POST',
    body: {'param1': 'value1'},
    padding: 8,
  );

  final cardComponent = CardComponent(
    key: 'card1',
    child: textChild,
    elevation: 2.0,
    color: Colors.white,
    padding: 16.0,
  );

  final rowComponent = RowComponent(
    key: 'row1',
    mainAxisAlignment: MainAxisAlignment.center,
    padding: 10.0,
    children: [imageComponent, buttonComponentWithAPICalls],
  );

  final placeholderComponent = PlaceholderComponent(
    key: 'placeholder1',
  );

  final cardJson = cardComponent.toJson();
  final buttonJson = buttonComponentWithAPICalls.toJson();
  final rowJson = rowComponent.toJson();
  final placeholderJson = placeholderComponent.toJson();

  final dahsboardFactorsJson = dahsboardFactors.toJson();
  final cardOutContainerJson = cardOutContainer.toJson();
  // print("CardComponent JSON: ${jsonEncode(cardJson)}");
  // print("ButtonComponentWithAPICalls JSON: ${jsonEncode(buttonJson)}");
  // print("RowComponent JSON: ${jsonEncode(rowJson)}");
  // print("PlaceholderComponent JSON: ${jsonEncode(placeholderJson)}");
  print(dahsboardFactorsJson);
  print(cardOutContainerJson);
}
