/// Thrown when one of the requested seats was booked by someone else.
class SeatAlreadyBookedException implements Exception {
  const SeatAlreadyBookedException();

  @override
  String toString() =>
      'One or more seats were just booked by someone else. Please choose again.';
}

/// Thrown when signing up with a phone number that already has an account.
class PhoneAlreadyRegisteredException implements Exception {
  const PhoneAlreadyRegisteredException();

  @override
  String toString() =>
      'This phone number is already registered. Please log in.';
}

/// Thrown when the phone number or password is wrong.
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();

  @override
  String toString() => 'Wrong phone number or password.';
}
