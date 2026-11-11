import '../models/player.dart';

/// Newroz first team. EDIT THIS LIST: the names below are placeholders.
class SquadData {
  const SquadData._();

  /// Set the head coach's name, or leave null to hide it.
  static const String? coach = null;

  static const List<Player> players = [
    Player(
        number: 1, name: 'Goalkeeper 1', position: PlayerPosition.goalkeeper),
    Player(
        number: 12, name: 'Goalkeeper 2', position: PlayerPosition.goalkeeper),
    Player(number: 2, name: 'Defender 1', position: PlayerPosition.defender),
    Player(number: 3, name: 'Defender 2', position: PlayerPosition.defender),
    Player(number: 4, name: 'Defender 3', position: PlayerPosition.defender),
    Player(number: 5, name: 'Defender 4', position: PlayerPosition.defender),
    Player(
        number: 6, name: 'Midfielder 1', position: PlayerPosition.midfielder),
    Player(
        number: 8, name: 'Midfielder 2', position: PlayerPosition.midfielder),
    Player(
        number: 10, name: 'Midfielder 3', position: PlayerPosition.midfielder),
    Player(number: 7, name: 'Forward 1', position: PlayerPosition.forward),
    Player(number: 9, name: 'Forward 2', position: PlayerPosition.forward),
    Player(number: 11, name: 'Forward 3', position: PlayerPosition.forward),
  ];
}
