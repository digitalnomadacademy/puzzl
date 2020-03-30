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
        child: Center(
          child: Container(
            width: size ?? 0,
            height: size ?? 0,
            color: Colors.yellow,
            child: Stack(children: _getChildren()),
          ),
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
                number: numberInt,
                size: size / 3,
              ),
            ))
        .toList();
  }

  _calculateAlignmentForIndex(int index) {
    double x, y;
    if (index <= 2) {
      y = -1;
    } else if (index <= 5) {
      y = 0;
    } else {
      y = 1;
    }

    var factor = index % 3;
    print('index $index got factor $factor');
    if (factor == 0) {
      x = -1;
    } else if (factor == 1) {
      x = 0;
    } else {
      x = 1;
    }

    return Alignment(x, y);
  }
}

class Number extends StatelessWidget {
  final double size;
  final int number;

  const Number({Key key, this.size, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(border: Border.all()),
      child: number == 9
          ? Container()
          : Center(
              child: Text(
                number.toString(),
                style: TextStyle(fontSize: 35),
              ),
            ),
    );
  }
}
