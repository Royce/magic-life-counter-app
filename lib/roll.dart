import 'package:flutter/material.dart';
import 'package:magic_life/main.dart';
import 'package:magic_life/starting_player_dialog.dart';

class Roll extends StatelessWidget {
  const Roll({super.key});

  @override
  Widget build(BuildContext context) {
    final GameWidgetState state = InheritedGame.of(context).data;

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
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.swap_vert,
          color: Colors.white24,
          size: 40.0,
        ),
      ),
    );
  }
}
