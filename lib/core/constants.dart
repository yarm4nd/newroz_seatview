/// Application-wide constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Newroz Stadium';
  static const String databaseName = 'newroz_stadium.db';
  static const String currency = 'IQD';

  /// Maximum number of seats a person can book in one order.
  static const int maxSeatsPerBooking = 6;

  /// Event shown in the app. Change these values for each match.
  static const String eventTitle = 'Newroz SC vs Duhok FC';
  static const String eventSubtitle = 'Iraqi Stars League';
  static const String venue = 'Newroz Stadium, Sulaymaniyah';

  static final DateTime eventDate = DateTime(2026, 12, 5, 18, 0);
}
