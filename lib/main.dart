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
  double size = 0;

  Map<int, List<int>> availablePositions = {
    0: [1, 3],
    1: [0, 2, 4],
    2: [1, 5],
    3: [0, 4, 6],
    4: [1, 3, 5, 7],
    5: [2, 4, 8],
    6: [3, 7],
    7: [4, 6, 8],
    8: [5, 7]
  };

  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  void initState() {
    super.initState();
    _initSize();
  }

  void _initSize() async {
    await Future(() {});
    setState(() {
      size = MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: size ?? 0,
              height: size ?? 0,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                color: Colors.orange,
              ),
              child: Stack(
                children: _getChildren(),
              ),
            ),
            RaisedButton(
              child: Text(
                "SHUFFLE ME",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => setState(() {
                numbers.shuffle();
              }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    return numbers
        .map((numberInt) => Align(
              alignment:
                  _calculateAlignmentForIndex(numbers.indexOf(numberInt)),
              child: Number(
                key: ValueKey<int>(numberInt),
                onTap: () => _onNumberTaped(numberInt),
                number: numberInt,
                size: size / 3,
              ),
            ))
        .toList();
  }

  Alignment _calculateAlignmentForIndex(int index) {
    double x, y;
    if (index <= 2) {
      y = -1;
    } else if (index <= 5) {
      y = 0;
    } else {
      y = 1;
    }

    var factor = index % 3;
    if (factor == 0) {
      x = -1;
    } else if (factor == 1) {
      x = 0;
    } else {
      x = 1;
    }

    return Alignment(x, y);
  }

  // [1,2,3,4,5,6,7,8,9]
  // 6=> index 5
  // 9=> index 8
  // izbacimo ih
  // [1,2,3,4,5,7,8,]
  //

  _onNumberTaped(int selectedNumber) {
    var selectedIndex = numbers.indexOf(selectedNumber);
    var indexOfNine = numbers.indexOf(9);
    bool canChange = availablePositions[indexOfNine].contains(selectedIndex);
    if (canChange) {
      setState(() {
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
}

class Number extends StatelessWidget {
  final double size;
  final int number;
  final VoidCallback onTap;

  const Number({Key key, this.size, this.number, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var is9 = number == 9;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: is9 ? null : onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            border: is9 ? null : Border.all(),
            color: is9 ? Colors.transparent : Colors.yellow),
        child: is9
            ? Container()
            : Center(
                child: Text(
                  (number).toString(),
                  style: TextStyle(fontSize: 35),
                ),
              ),
      ),
    );
  }
}
