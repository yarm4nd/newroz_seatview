import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../data/iraq_league_fixtures.dart';
import '../models/league_match.dart';
import '../models/seat.dart';
import '../models/ticket_package.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_steps.dart';
import '../widgets/stadium_map.dart';
import 'preview_screen.dart';
import 'seats_screen.dart';

/// Step 1: choose a package, or tap a zone on the stadium map.
class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  TicketPackage? _package;
  StadiumSection? _zone;

  late final LeagueMatch? _match = _nextHomeMatch();

  /// The next Newroz home match in the fixtures list.
  static LeagueMatch? _nextHomeMatch() {
    final now = DateTime.now();
    for (final match in IraqLeagueFixtures.all) {
      if (match.isNewrozHome && match.kickoff.isAfter(now)) return match;
    }
    return null;
  }

  void _selectPackage(TicketPackage package) {
    setState(() {
      if (_package == package) {
        _package = null;
        _zone = null;
      } else {
        _package = package;
        if (_zone?.package != package) _zone = null;
      }
    });
  }

  void _selectZone(StadiumSection zone) {
    setState(() {
      _zone = zone;
      _package = zone.package;
    });
  }

  int _seatsLeft(BookingProvider booking, TicketPackage package) {
    return StadiumSection.inPackage(package)
        .fold(0, (sum, zone) => sum + booking.availableCount(zone));
  }

  String get _buttonLabel {
    final zone = _zone;
    if (zone != null) return 'Choose seats in ${zone.name}';
    if (_package != null) return 'Tap a zone on the map';
    return 'Select a package';
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final zone = _zone;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Select your package'),
        actions: [
          IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: booking.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    _MatchHeader(match: _match),
                    const SizedBox(height: 16),
                    StadiumMap(
                      selectedPackage: _package,
                      selectedZoneId: zone?.id,
                      availableIn: booking.availableCount,
                      onZoneTap: _selectZone,
                    ),
                    const SizedBox(height: 16),
                    for (final package in TicketPackage.values)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PackageCard(
                          package: package,
                          selected: _package == package,
                          seatsLeft: _seatsLeft(booking, package),
                          onTap: () => _selectPackage(package),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (booking.selectedCount > 0)
                _SelectedSummary(
                  count: booking.selectedCount,
                  total: booking.totalPrice,
                  onReview: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PreviewScreen(),
                    ),
                  ),
                ),
              const BookingSteps(current: 1),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: zone == null
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SeatsScreen(section: zone),
                          ),
                        ),
                child: Text(_buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchHeader extends StatelessWidget {
  const _MatchHeader({required this.match});

  final LeagueMatch? match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final home = match?.home ?? LeagueMatch.newroz;
    final away = match?.away ?? 'Opponent';
    final kickoff = match?.kickoff ?? AppConstants.eventDate;
    final confirmed = match?.timeConfirmed ?? true;
    final time = confirmed ? DateFormat('HH:mm').format(kickoff) : 'TBC';
    final date = DateFormat('EEE MMM d').format(kickoff).toUpperCase();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Team(name: home),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text(
                time,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                date,
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 1,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        _Team(name: away),
      ],
    );
  }
}

/// Team badge. Shows initials because no logo files are bundled yet.
class _Team extends StatelessWidget {
  const _Team({required this.name});

  final String name;

  String get _initials {
    if (name == LeagueMatch.newroz) return 'NZ';
    final words = name.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length >= 2) return (words[0][0] + words[1][0]).toUpperCase();
    return (name.length >= 2 ? name.substring(0, 2) : name).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = name == LeagueMatch.newroz ? AppColors.fire : AppColors.ink;
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.selected,
    required this.seatsLeft,
    required this.onTap,
  });

  final TicketPackage package;
  final bool selected;
  final int seatsLeft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = NumberFormat.decimalPattern().format(package.price);

    return Semantics(
      button: true,
      selected: selected,
      label: '${package.label}, $price ${AppConstants.currency}',
      child: Material(
        color: selected
            ? package.color.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    selected ? package.color : theme.colorScheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 5, color: package.color),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: package.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  package.label.toUpperCase(),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            package.description,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$seatsLeft seats left',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: package.color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          AppConstants.currency,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedSummary extends StatelessWidget {
  const _SelectedSummary({
    required this.count,
    required this.total,
    required this.onReview,
  });

  final int count;
  final int total;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final seats = count == 1 ? '1 seat' : '$count seats';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$seats • ${Formatters.currency(total)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          OutlinedButton(onPressed: onReview, child: const Text('Review')),
        ],
      ),
    );
  }
}
