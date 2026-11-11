import 'package:flutter/material.dart';

import '../data/squad.dart';
import '../models/player.dart';

class SquadScreen extends StatelessWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coach = SquadData.coach;

    return Scaffold(
      appBar: AppBar(title: const Text('Squad')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (coach != null)
                _PersonTile(
                  leading: const Icon(Icons.sports, color: Colors.white),
                  color: theme.colorScheme.primary,
                  title: coach,
                  subtitle: 'Head coach',
                ),
              for (final position in PlayerPosition.values) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                  child: Text(
                    position.label.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800,
                      color: position.color,
                    ),
                  ),
                ),
                for (final player
                    in SquadData.players.where((p) => p.position == position))
                  _PersonTile(
                    leading: Text(
                      '${player.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    color: position.color,
                    title: player.name,
                    subtitle: position.label.replaceAll('s', ''),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({
    required this.leading,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Widget leading;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: leading),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
