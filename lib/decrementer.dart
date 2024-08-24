import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';

class Decrementer extends StatelessWidget {
  const Decrementer({super.key, required this.player});
  final String player;

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) / 4;
    final GameWidgetState state = InheritedGame.of(context).data;

    return InkWell(
      onTap: () => {state.decrement(player)},
      child: Container(
        padding: EdgeInsets.all(width / 3),
        child: Icon(
          Icons.remove,
          color: Colors.white24,
          size: width,
        ),
      ),
    );
  }
}
