import '../models/seat.dart';

/// Which 360° photos exist in assets/panoramas/ (names without ".jpg").
class PanoramaAssets {
  const PanoramaAssets._();

  /// Add a zone id like 'M1', or a side like 'north', when you add its photo.
  static const Set<String> available = {};

  /// The zone's own photo, else its side's photo, else null.
  static String? pathFor(StadiumSection section) {
    if (available.contains(section.id)) {
      return 'assets/panoramas/${section.id}.jpg';
    }
    if (available.contains(section.side)) {
      return 'assets/panoramas/${section.side}.jpg';
    }
    return null;
  }
}
