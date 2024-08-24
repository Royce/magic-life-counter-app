import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';
import 'package:magic_life/temp_score.dart';

class TempScores extends StatelessWidget {
  const TempScores({super.key});

  @override
  Widget build(BuildContext context) {
    final GameWidgetState state = InheritedGame.of(context).data;
    final Iterable<String> players =
        state.counters.entries.where((e) => e.value.mod != 0).map((e) => e.key);

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: players.map((player) => TempScore(player: player)).toList(),
      ),
    );
  }
}
