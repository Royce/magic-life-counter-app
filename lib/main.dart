import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

const PLAYER_ONE = 'one';
const PLAYER_TWO = 'two';
const COLORS = {PLAYER_ONE: Colors.pink, PLAYER_TWO: Colors.lightBlue};

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyTree(),
    );
  }
}

class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class MyInheritedWidget extends StatefulWidget {
  MyInheritedWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited)
        .data;
  }
}

class MyInheritedWidgetState extends State<MyInheritedWidget> {
  Map<String, Counter> counters = {'one': Counter(20), 'two': Counter(20)};
  Timer _timer;
  Duration duration = const Duration(seconds: 2);
  String startingPlayer;
  var _rng = new Random();

  void increment(String player) {
    setState(() {
      counters[player].increment();
    });
    _resetTimer();
  }

  void decrement(String player) {
    setState(() {
      counters[player].decrement();
    });
    _resetTimer();
  }

  void reset() {
    setState(() {
      counters[PLAYER_ONE].reset(20);
      counters[PLAYER_TWO].reset(20);
    });
  }

  void roll() {
    setState(() {
      startingPlayer = _rng.nextBool() ? PLAYER_ONE : PLAYER_TWO;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(duration, () => _commit());
  }

  void _commit() {
    setState(() {
      counters[PLAYER_ONE].commit();
      counters[PLAYER_TWO].commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInherited(
      data: this,
      child: widget.child,
    );
  }
}

class MyTree extends StatefulWidget {
  @override
  _MyTreeState createState() => new _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  @override
  Widget build(BuildContext context) {
    return new MyInheritedWidget(
      child: new Stack(
        //alignment: const Alignment(0.6, 0.6),
        children: <Widget>[
          new Scaffold(
            body: new Column(
              children: <Widget>[
                ScoreTile(player: PLAYER_ONE, rotated: true),
                ConfigTile(),
                ScoreTile(player: PLAYER_TWO),
              ],
            ),
          ),
          new TempScores(),
        ],
      ),
    );
  }
}

class StartingPlayerDialog extends StatelessWidget {
  final String player;

  StartingPlayerDialog({Key key, this.player});

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Opacity(
          opacity: 0.3,
          child: ModalBarrier(color: Colors.grey),
        ),
        new Center(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: COLORS[player],
              border: Border.all(
                  color: Colors.white, width: 4, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Icon(
              player == PLAYER_ONE ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.black87,
              size: 90.0,
            ),
          ),
        ),
      ],
    );
  }
}

class TempScores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    final Iterable<String> players =
        state.counters.entries.where((e) => e.value.mod != 0).map((e) => e.key);

    return Center(
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: players.map((player) => TempScore(player: player)).toList(),
        ),
      ),
    );
  }
}

class TempScore extends StatelessWidget {
  TempScore({Key key, this.player}) : super(key: key);
  final String player;

  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    final Counter counter = state.counters[player];
    final Color color = COLORS[player];

    return new Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.white, width: 4, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1))
          ],
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RotatedBox(
              quarterTurns: 2,
              child: Text(
                counter.toMathString(),
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Text(
              counter.toMathString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ));
  }
}

class ScoreTile extends StatelessWidget {
  final String player;
  final bool rotated;

  ScoreTile({Key key, this.player, this.rotated = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    final Counter counter = state.counters[this.player];
    final Color color = COLORS[this.player];

    return Expanded(
      child: Material(
        color: color,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rotated
                    ? <Widget>[
                        Decrementer(player: player),
                        Incrementer(player: player),
                      ]
                    : <Widget>[
                        Incrementer(player: player),
                        Decrementer(player: player),
                      ],
              ),
            ),
            Center(
              child: RotatedBox(
                quarterTurns: rotated ? 2 : 0,
                child: Text(
                  '${counter.counter}',
                  style: Theme.of(context).textTheme.display4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Incrementer extends StatelessWidget {
  final String player;

  Incrementer({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) / 4;
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return InkWell(
      onTap: () => {state.increment(player)},
      child: Container(
        padding: EdgeInsets.all(width/2 - 5),
        child: Icon(
          Icons.add,
          color: Colors.white24,
          size: width,
        ),
      ),
    );
  }
}

class Decrementer extends StatelessWidget {
  final String player;

  Decrementer({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) / 4;
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return InkWell(
      onTap: () => {state.decrement(player)},
      child: Container(
        padding: EdgeInsets.all(width/2 - 5),
        child: Icon(
          Icons.remove,
          color: Colors.white24,
          size: width,
        ),
      ),
    );
  }
}

class ConfigTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Palette(player: PLAYER_TWO),
          Reset(),
          Roll(),
//          RotatedBox(
//            quarterTurns: 2,
//            child: Palette(player: PLAYER_ONE),
//          ),
        ],
      ),
    );
  }
}

class Reset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return InkWell(
      onTap: () => {state.reset()},
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.refresh,
          color: Colors.white24,
          size: 40.0,
        ),
      ),
    );
  }
}

class Roll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push<Widget>(
          PageRouteBuilder<Widget>(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return StartingPlayerDialog(player: state.startingPlayer);
            },
          ),
        );
        state.roll();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.swap_vert,
          color: Colors.white24,
          size: 40.0,
        ),
      ),
    );
  }
}

class Palette extends StatelessWidget {
  final String player;

  Palette({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return InkWell(
      onTap: () => {state.reset()},
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.palette,
          color: COLORS[player].withAlpha(200),
          size: 40.0,
        ),
      ),
    );
  }
}

class Counter {
  int counter = 20;
  int mod = 0;

  Counter(this.counter);

  void increment() {
    mod++;
  }

  void decrement() {
    mod--;
  }

  void reset(int num) {
    counter = num;
  }

  void commit() {
    counter = counter + mod;
    mod = 0;
  }

  String toMathString() {
    return mod >= 0
        ? '$counter + $mod  →  ${counter + mod}'
        : "$counter - ${-mod}  →  ${counter + mod}";
  }
}
