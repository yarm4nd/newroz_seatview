import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/translator.dart';
import '../models/ticket.dart';
import '../providers/booking_provider.dart';
import '../providers/locale_provider.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final lang = context.watch<LocaleProvider>().language;
    final tickets = booking.tickets;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'my_tickets'))),
      body: booking.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.confirmation_number_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(lang == AppLanguage.kurdish ? '\u0647\u06CC\u0686 \u0628\u0644\u06CC\u062A\u06CE\u06A9 \u0646\u06CC\u06CC\u06D5' : lang == AppLanguage.arabic ? '\u0644\u0627 \u062A\u0648\u062C\u062F \u062A\u0630\u0627\u0643\u0631 \u0628\u0639\u062F' : 'No tickets yet', style: Theme.of(context).textTheme.titleMedium),
                  ]),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: tickets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _TicketCard(ticket: tickets[index], lang: lang, onCancel: () => booking.cancelTicket(tickets[index])),
                    ),
                  ),
                ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.lang, required this.onCancel});
  final Ticket ticket;
  final AppLanguage lang;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final section = ticket.section;
    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.colorScheme.outlineVariant)),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(width: 8, color: section.color),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(Tr.text(lang, AppConstants.eventTitle), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(Tr.text(lang, Formatters.dateTime(AppConstants.eventDate)), style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),
                Text('${Tr.text(lang, section.name)} • ${Tr.text(lang, 'Row')} ${ticket.row} • ${Tr.text(lang, 'Seat')} ${ticket.seatNumber}'),
                const SizedBox(height: 4),
                Text(ticket.holderName, style: theme.textTheme.bodySmall),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text(ticket.code, style: theme.textTheme.labelMedium?.copyWith(fontFamily: 'monospace', letterSpacing: 1))),
                  Text(Tr.text(lang, Formatters.currency(ticket.price)), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
              ]),
            ),
          ),
          IconButton(onPressed: onCancel, icon: const Icon(Icons.delete_outline)),
        ]),
      ),
    );
  }
}
