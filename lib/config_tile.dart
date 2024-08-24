import 'package:flutter/material.dart';
import 'package:magic_life/reset.dart';
import 'package:magic_life/roll.dart';

class ConfigTile extends StatelessWidget {
  const ConfigTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
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
