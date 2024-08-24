import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';

class StartingPlayerDialog extends StatelessWidget {
  const StartingPlayerDialog({super.key, required this.player});
  final String player;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Opacity(
          opacity: 0.3,
          child: ModalBarrier(color: Colors.grey),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors[player],
              border: Border.all(
                  color: Colors.white, width: 4, style: BorderStyle.solid),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Icon(
              player == playerOne ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.black87,
              size: 90.0,
            ),
          ),
        ),
      ],
    );
  }
}
