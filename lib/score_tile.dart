import 'package:flutter/material.dart';
import 'package:magic_life/decrementer.dart';
import 'package:magic_life/incrementer.dart';
import 'package:magic_life/main.dart';
import 'package:magic_life/outlined_text.dart';

class ScoreTile extends StatelessWidget {
  const ScoreTile({super.key, required this.player, this.rotated = false});

  final String player;
  final bool rotated;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    assert(debugCheckHasMaterial(context));

    final GameWidgetState state = InheritedGame.of(context).data;
    final Counter counter = state.counters[player]!;
    final Color color = colors[player]!;

    return Expanded(
      child: Material(
        color: color,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: !rotated
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
            Container(
              alignment: player == playerOne
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              margin: const EdgeInsets.all(5),
              child: Opacity(
                opacity: 0.5,
                child: RotatedBox(
                  quarterTurns: player == playerOne ? 2 : 0,
                  child: Text(
                    counter.toHistoryString(),
                    style: Theme.of(context).primaryTextTheme.headlineLarge,
                  ),
                ),
              ),
            ),
            counter.mod != 0
                ? Container(
                    alignment: Alignment(0, player == playerOne ? 0.4 : -0.4),
                    margin: player == playerOne
                        ? const EdgeInsets.only(top: 40)
                        : const EdgeInsets.only(bottom: 40),
                    child: RotatedBox(
                      quarterTurns: player == playerOne ? 2 : 0,
                      child: Text(
                        counter.toModString(),
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: OutlinedText(
                data: '${counter.counter + counter.mod}',
                fontSize: width / 3,
                rotate: rotated,
                outlineColor:
                    counter.counter <= 0 ? Colors.white : Colors.black,
                textColor: counter.counter <= 0 ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
