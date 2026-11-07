import 'package:intl/intl.dart';

import 'constants.dart';

/// Text formatting helpers used across the UI.
class Formatters {
  const Formatters._();

  static final NumberFormat _number = NumberFormat.decimalPattern();
  static final DateFormat _dateTime = DateFormat('EEE, d MMM y • HH:mm');

  static String currency(int amount) =>
      '${_number.format(amount)} ${AppConstants.currency}';

  static String dateTime(DateTime value) => _dateTime.format(value);
}
