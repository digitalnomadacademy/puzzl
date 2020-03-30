import 'package:flutter/material.dart';

void main() {
  runApp(Puzzl());
}

class Puzzl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzlPage(),
    );
  }
}

class PuzzlPage extends StatefulWidget {
  @override
  _PuzzlPageState createState() => _PuzzlPageState();
}

class _PuzzlPageState extends State<PuzzlPage> {
//  here we save the widgth of the screen
  double size = 0;

//this is the map of all available positions, where you can move
//  from top left (0) you can go right and down 1 3
  Map<int, List<NumberPosition>> availablePositions = {
    0: [
      NumberPosition(direction: AxisDirection.right, index: 1),
      NumberPosition(direction: AxisDirection.down, index: 3)
    ],
    1: [
      NumberPosition(direction: AxisDirection.left, index: 0),
      NumberPosition(direction: AxisDirection.right, index: 2),
      NumberPosition(direction: AxisDirection.down, index: 4),
    ],
    2: [
      NumberPosition(direction: AxisDirection.left, index: 1),
      NumberPosition(direction: AxisDirection.down, index: 5)
    ],
    3: [
      NumberPosition(direction: AxisDirection.up, index: 0),
      NumberPosition(direction: AxisDirection.right, index: 4),
      NumberPosition(direction: AxisDirection.down, index: 6),
    ],
    4: [
      NumberPosition(direction: AxisDirection.up, index: 1),
      NumberPosition(direction: AxisDirection.left, index: 3),
      NumberPosition(direction: AxisDirection.right, index: 5),
      NumberPosition(direction: AxisDirection.down, index: 7),
    ],
    5: [
      NumberPosition(direction: AxisDirection.up, index: 2),
      NumberPosition(direction: AxisDirection.left, index: 4),
      NumberPosition(direction: AxisDirection.down, index: 8),
    ],
    6: [
      NumberPosition(direction: AxisDirection.up, index: 3),
      NumberPosition(direction: AxisDirection.right, index: 7),
    ],
    7: [
      NumberPosition(direction: AxisDirection.up, index: 4),
      NumberPosition(direction: AxisDirection.left, index: 6),
      NumberPosition(direction: AxisDirection.right, index: 8),
    ],
    8: [
      NumberPosition(direction: AxisDirection.up, index: 5),
      NumberPosition(direction: AxisDirection.left, index: 7),
    ]
  };

//  list of numbers that we show in the game
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];

//  we will create widgets and put them to this listt
  List<Widget> numbersWidgets = [];

  @override
  void initState() {
    super.initState();
    _initSize();
  }

  void _initSize() async {
//    we await one frame, so that we can call media query
    await Future(() {});
    setState(() {
//      get the width
      size = MediaQuery.of(context).size.width;
//      create Numbers from 1 to 8 (9 is transparent)
      numbersWidgets = _createChildren();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // background widget
            Container(
              width: size ?? 0,
              height: size ?? 0,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                color: Colors.orange,
              ),
//              stack for the game
              child: Stack(
//                here we have numbersWidgets that we already created
//              we will always use the same widgets, but we want to
//              wrap them with AnimatedAlign widget, so that we can position them
//
                children: numbersWidgets.map((numberWidget) {
//                  first we calculate the index of numberWidget,
                  var indexOfNumberWidget =
                      numbersWidgets.indexOf(numberWidget);
//                  after we know the index, we know also that the number inside is
//                  just + 1, becase we never shuffle that list. It was created with original
//                  [1,2,3,4,5,6,7,8,9]
                  var number = indexOfNumberWidget + 1;
//                  when we know the number, we can create AnimatedAlign with alignment from
//                  the calculateAlignmentForIndexFunction.
//                  because the alignment changes for the same widget, it will be animated
                  return AnimatedAlign(
                    duration: Duration(milliseconds: 500),
                    alignment:
                        _calculateAlignmentForIndex(numbers.indexOf(number)),
                    child: numberWidget,
                  );
                }).toList(),
              ),
            ),
            RaisedButton(
              child: Text(
                "SHUFFLE ME",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => setState(() {
//                here we shuffle the numbers list inside setState.
//              new alignments will be calculated once we change the order
                numbers.shuffle();
              }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _createChildren() {
//    here we create Number widget for each number from the list
    return numbers
        .map((numberInt) => Number(
              onTap: () => _onNumberTaped(
                  numberInt), // when number is tapped, we handle it here
              onDrag: _onNumberDragged,
              number: numberInt,
              size: size / 3, // size is one third of the screen width
            ))
        .toList();
  }

  Alignment _calculateAlignmentForIndex(int index) {
    // here we calculate alignment for index.
//    we have 9 indexes from 0 to 8
//  0 1 2
//  3 4 5
//  6 7 8

//  for y, and that is alignment on vertical axis, we have -1 top, 0 center, and 1 bottom.
//  here we can see that it is just separated by index
    double x, y;
    if (index <= 2) {
      y = -1;
    } else if (index <= 5) {
      y = 0;
    } else {
      y = 1;
    }

//    for x it is a bit more complicated, it is alignment on horizontal axis
//    -1 is left, 0 is center, and 1 is right
//    what is in common with index 0, 3, 6 ?
//    or 1, 4, 7, or  2, 5, 8, ?

//    they all have the same modulo (ostatak) when divided by 3.

    var modulo = index % 3;
//    if modulo is 0 they are left, if it is 1 they are in the center, and for 2 they are right
    if (modulo == 0) {
      x = -1;
    } else if (modulo == 1) {
      x = 0;
    } else {
      x = 1;
    }

    return Alignment(x, y);
  }

//  when number is tapped we have to switch 2 numbers inside the number list
  _onNumberTaped(int selectedNumber) {
//    first we find the index of both numbers. The selected number and 9 as empty number
    var selectedIndex = numbers.indexOf(selectedNumber);
    var indexOfNine = numbers.indexOf(9);

//    we check in available positions if selected number can change with 9?
    bool canChange = availablePositions[indexOfNine].any(
        (NumberPosition numberPosition) =>
            numberPosition.index == selectedIndex);
    if (canChange) {
//      if it can change we call setState to update UI
      _exchangeNumbers(selectedNumber);
    }
  }

  _onNumberDragged(AxisDirection direction, int number) {
    var indexOfNumber = numbers.indexOf(number);
    var indexOf9 = numbers.indexOf(9);

    List<NumberPosition> positionsAvailable = availablePositions[indexOfNumber];

    var directionalCheckPassed = positionsAvailable.any((numberPosition) =>
        numberPosition.index == indexOf9 &&
        numberPosition.direction == direction);
    if (directionalCheckPassed) {
      _exchangeNumbers(number);
    }
  }

  void _exchangeNumbers(int selectedNumber) {
    return setState(() {
      var selectedIndex = numbers.indexOf(selectedNumber);
      var indexOfNine = numbers.indexOf(9);

//        we remove both of them from the list.
//      then we call the one that was in the bigger index, and insert it at smaller index
//      after that the number that was in smaller index is inserted at bigger index
//      and the numbers are switched. ccalling setState will calculate new alignments,
//      so UI will change
      numbers.remove(9);
      numbers.remove(selectedNumber);
      if (indexOfNine < selectedIndex) {
        numbers.insert(indexOfNine, selectedNumber);
        numbers.insert(selectedIndex, 9);
      } else {
        numbers.insert(selectedIndex, 9);
        numbers.insert(indexOfNine, selectedNumber);
      }
    });
  }
}

class Number extends StatelessWidget {
//  parameters that we need for this widget
  final double size;
  final int number;
  final VoidCallback onTap;
  final Function(AxisDirection direction, int number) onDrag;

  const Number({Key key, this.size, this.number, this.onTap, this.onDrag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    we check if it is number 9, cause it is different
    var is9 = number == 9;
    return GestureDetector(
      behavior: HitTestBehavior
          .opaque, // this will work for the whole container, else it only works for what you can see
      onTap: is9 ? null : onTap, // we only call the function if it is not 9
      onVerticalDragUpdate: (DragUpdateDetails options) => onDrag(
          options.delta.dy > 0 && options.delta.dy < size / 2
              ? AxisDirection.down
              : AxisDirection.up,
          number),
      onHorizontalDragUpdate: (DragUpdateDetails options) => onDrag(
          options.delta.dx > 0 && options.delta.dx < size / 2
              ? AxisDirection.right
              : AxisDirection.left,
          number),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            border: is9 ? null : Border.all(), // nice border for the numbers
            color: is9
                ? Colors.transparent
                : Colors.yellow), //9 is transparent with no border
        child: is9
            ? Container()
            : Center(
                child: Text(
                  (number).toString(), // text is a number to string
                  style: TextStyle(fontSize: 35),
                ),
              ),
      ),
    );
  }
}

class NumberPosition {
  final AxisDirection direction;
  final int index;

  const NumberPosition({
    @required this.direction,
    @required this.index,
  });
}
