import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:magic_life/config_tile.dart';
import 'package:magic_life/score_tile.dart';
import 'package:magic_life/temp_scores.dart';
import 'dart:math';

const playerOne = 'one';
const playerTwo = 'two';
const colors = {playerOne: Colors.pinkAccent, playerTwo: Colors.lightBlue};

void main() {
  runApp(const MyApp());
  KeepScreenOn.turnOn();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MLC',
      home: GameWidget(
        child: Stack(
          //alignment: const Alignment(0.6, 0.6),
          children: <Widget>[
            Scaffold(
              body: Column(
                children: <Widget>[
                  ScoreTile(player: playerOne, rotated: true),
                  ConfigTile(),
                  ScoreTile(player: playerTwo),
                ],
              ),
            ),
            TempScores(),
          ],
        ),
      ),
    );
  }
}

class InheritedGame extends InheritedWidget {
  const InheritedGame({
    super.key,
    required this.data,
    required super.child,
  });
  final GameWidgetState data;

  static InheritedGame? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedGame>();
  }

  static InheritedGame of(BuildContext context) {
    final InheritedGame? result = maybeOf(context);
    assert(result != null, 'No Game found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedGame oldWidget) {
    return true;
  }
}

class GameWidget extends StatefulWidget {
  const GameWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GameWidget> createState() => GameWidgetState();
}

class GameWidgetState extends State<GameWidget> {
  Map<String, Counter> counters = {'one': Counter(20), 'two': Counter(20)};
  RestartableTimer? _timer;
  late String startingPlayer;

  final _rng = Random();

  void increment(String player) {
    setState(() {
      counters[player]!.increment();
    });
    _resetTimer();
  }

  void decrement(String player) {
    setState(() {
      counters[player]!.decrement();
    });
    _resetTimer();
  }

  void reset() {
    setState(() {
      counters[playerOne]!.reset(20);
      counters[playerTwo]!.reset(20);
    });
  }

  void roll() {
    setState(() {
      startingPlayer = _rng.nextBool() ? playerOne : playerTwo;
    });
  }

  void _resetTimer() {
    _timer?.reset();
    _timer ??= RestartableTimer(const Duration(seconds: 2), () {
      setState(() {
        counters[playerOne]!.commit();
        counters[playerTwo]!.commit();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedGame(
      data: this,
      child: widget.child,
    );
  }
}

class Counter {
  int counter = 20;
  int mod = 0;
  List<String> _history = [];

  Counter(this.counter);

  void increment() {
    mod++;
  }

  void decrement() {
    mod--;
  }

  void reset(int num) {
    counter = num;
    _history = [];
  }

  void commit() {
    counter = counter + mod;
    if (mod != 0) {
      _history.add(toModString());
    }
    mod = 0;
  }

  String toMathString() {
    return mod >= 0
        ? '$counter + $mod  →  ${counter + mod}'
        : "$counter - ${-mod}  →  ${counter + mod}";
  }

  String toModString() {
    return mod >= 0 ? '+$mod' : mod.toString();
  }

  String toHistoryString() {
    const int show = 6;
    return _history.length > show
        ? "…, ${_history.sublist(_history.length + 1 - show).join(", ")}"
        : _history.join(", ");
  }
}
