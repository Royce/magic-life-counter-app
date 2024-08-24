import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';

class TempScore extends StatelessWidget {
  const TempScore({super.key, required this.player});

  final String player;

  @override
  Widget build(BuildContext context) {
    final GameWidgetState state = InheritedGame.of(context).data;
    final Counter counter = state.counters[player]!;
    final Color color = colors[player]!;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.white, width: 4, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1))
          ],
        ),
        child: RotatedBox(
          quarterTurns: player == playerTwo ? 2 : 0,
          child: Text(
            counter.toModString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
