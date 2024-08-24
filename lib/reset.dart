import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';

class Reset extends StatelessWidget {
  const Reset({super.key});

  @override
  Widget build(BuildContext context) {
    final GameWidgetState state = InheritedGame.of(context).data;

    return InkWell(
      onTap: () => {state.reset()},
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.refresh,
          color: Colors.white24,
          size: 40.0,
        ),
      ),
    );
  }
}
