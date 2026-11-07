import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newroz_seatview/core/validators.dart';
import 'package:newroz_seatview/models/seat.dart';
import 'package:newroz_seatview/models/ticket.dart';
import 'package:newroz_seatview/widgets/seat_widget.dart';

void main() {
  group('Seat', () {
    test('builds a unique key', () {
      const seat = Seat(sectionId: 'N', row: 3, number: 7);
      expect(seat.key, 'N-3-7');
    });

    test('copyWith changes only the status', () {
      const seat = Seat(sectionId: 'E', row: 1, number: 2);
      final selected = seat.copyWith(status: SeatStatus.selected);
      expect(selected.isSelected, isTrue);
      expect(selected.key, seat.key);
    });
  });

  group('Ticket', () {
    test('survives a toMap / fromMap round trip', () {
      final ticket = Ticket(
        id: 1,
        code: 'NZ-TEST-1',
        sectionId: 'W',
        row: 2,
        seatNumber: 5,
        price: 25000,
        holderName: 'Ava Karim',
        phone: '+9647501234567',
        createdAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
      );
      final copy = Ticket.fromMap(ticket.toMap());
      expect(copy.seatKey, 'W-2-5');
      expect(copy.holderName, 'Ava Karim');
      expect(copy.createdAt, ticket.createdAt);
    });
  });

  group('Validators', () {
    test('name', () {
      expect(Validators.name(''), isNotNull);
      expect(Validators.name('Ava Karim'), isNull);
    });

    test('phone', () {
      expect(Validators.phone('123'), isNotNull);
      expect(Validators.phone('+964 750 123 4567'), isNull);
    });
  });

  testWidgets('booked seats ignore taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 40,
            child: SeatWidget(
              seat: const Seat(
                sectionId: 'N',
                row: 1,
                number: 1,
                status: SeatStatus.booked,
              ),
              sectionColor: Colors.blue,
              onTap: () => taps++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(SeatWidget));
    expect(taps, 0);
  });
}
