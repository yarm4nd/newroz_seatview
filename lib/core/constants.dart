/// Application-wide constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Newroz Stadium';
  static const String databaseName = 'newroz_stadium.db';
  static const String currency = 'IQD';

  /// Total seats in the stadium (must match the zones in models/seat.dart).
  static const int stadiumCapacity = 13500;

  /// Maximum number of seats a person can book in one order.
  static const int maxSeatsPerBooking = 6;

  /// Next Newroz home match shown in the app.
  static const String eventTitle = 'Newroz vs Al Karma';
  static const String eventSubtitle = 'Iraq Stars League 2026–27';
  static const String venue = 'Newroz Stadium, Sulaymaniyah';

  static final DateTime eventDate = DateTime(2026, 11, 21, 16, 0);
}
