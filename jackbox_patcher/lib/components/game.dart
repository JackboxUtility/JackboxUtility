import 'package:fluent_ui/fluent_ui.dart';

import '../model/usermodel/userjackboxgame.dart';

class GameCard extends StatefulWidget {
  GameCard({Key? key, required this.game}) : super(key: key);

  final UserJackboxGame game;
  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              widget.game.game.icon,
              width: 50,
              height: 50,
            ),
            title: Text(widget.game.game.name),
            subtitle: Text(widget.game.game.description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Install'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      )
    );
  }
}