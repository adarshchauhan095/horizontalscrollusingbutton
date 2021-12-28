import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> example = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
  ];

  final itemScrollController = ItemScrollController();

  final itemPositionsListener = ItemPositionsListener.create();

  List<int> shownItemsIndexOnScreen = [];

  int startIndex = 0;

  int endIndex = 0;

  void getShownItemsIndex() {
    itemPositionsListener.itemPositions.addListener(() {
      shownItemsIndexOnScreen = itemPositionsListener.itemPositions.value
          .where((element) {
            final isPreviousVisible = element.itemLeadingEdge >= 0;
            // final isNextVisble = element.itemTrailingEdge <= 1;
            return isPreviousVisible;
          })
          .map((item) => item.index)
          .toList();

      startIndex = shownItemsIndexOnScreen.isEmpty
          ? 0
          : shownItemsIndexOnScreen.reduce(min);

      endIndex = shownItemsIndexOnScreen.isEmpty
          ? 0
          : shownItemsIndexOnScreen.reduce(max);
    });
  }

  void scrollToNext() async {
    if (shownItemsIndexOnScreen.isEmpty) {
      getShownItemsIndex();
    } else {
      if (endIndex < example.length - 1) {
        await itemScrollController.scrollTo(
            index: endIndex + 1,
            alignment: 0.8,
            duration: const Duration(milliseconds: 200));
        return;
      } else {}
    }
  }

  void scrollToPrevious() async {
    if (shownItemsIndexOnScreen.isEmpty) {
      getShownItemsIndex();
    } else {
      if (startIndex > 0) {
        await itemScrollController.scrollTo(
            index: startIndex - 1,
            alignment: 0,
            duration: const Duration(milliseconds: 200));

        return;
      } else {}
    }
  }

  @override
  void initState() {
    getShownItemsIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Horizontal Scrollable List'),
        ),
        body: SizedBox(
          height: 300.0,
          child: Stack(
            children: [
              ScrollablePositionedList.separated(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: example.length,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 300.0,
                        width: 150.0,
                        child: Center(
                          child: Text(example[index]),
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10.0,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CircularIndicatorButton(
                  isLeft: true,
                  onTap: () {
                    scrollToPrevious();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircularIndicatorButton(
                  isLeft: false,
                  onTap: () {
                    scrollToNext();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircularIndicatorButton extends StatelessWidget {
  const CircularIndicatorButton({Key? key, required this.isLeft, this.onTap})
      : super(key: key);

  final bool isLeft;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Center(
            child: Icon(
              isLeft ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
      );
}
