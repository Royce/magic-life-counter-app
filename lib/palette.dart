import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';

class Palette extends StatelessWidget {
  const Palette({super.key, required this.player});
  final String player;

  @override
  Widget build(BuildContext context) {
    final GameWidgetState state = InheritedGame.of(context).data;

    return InkWell(
      onTap: () => {state.reset()},
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.palette,
          color: colors[player]!.withAlpha(200),
          size: 40.0,
        ),
      ),
    );
  }
}
