import 'package:get/get.dart';

class DateHelper {
  DateHelper._(); // prevent instantiation

  // ─── Khmer digit map ────────────────────────────────────────────────────────
  static const Map<String, String> _khmerDigits = {
    '0': '០',
    '1': '១',
    '2': '២',
    '3': '៣',
    '4': '៤',
    '5': '៥',
    '6': '៦',
    '7': '៧',
    '8': '៨',
    '9': '៩',
  };

  // ─── Khmer month names (1-indexed) ──────────────────────────────────────────
  static const List<String> _khmerMonths = [
    '', // placeholder so index 1 = January
    'មករា', // January
    'កុម្ភៈ', // February
    'មីនា', // March
    'មេសា', // April
    'ឧសភា', // May
    'មិថុនា', // June
    'កក្កដា', // July
    'សីហា', // August
    'កញ្ញា', // September
    'តុលា', // October
    'វិច្ឆិកា', // November
    'ធ្នូ', // December
  ];

  // ─── English month abbreviations (1-indexed) ────────────────────────────────
  static const List<String> _enMonths = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Converts an ASCII digit string to Khmer digits.
  static String toKhmerDigits(String input) =>
      input.split('').map((c) => _khmerDigits[c] ?? c).join();

  // Date formation
  static String formatDate(DateTime? date, {String fallback = '-'}) {
    if (date == null) return fallback;

    final locale = Get.locale?.languageCode ?? 'en';

    if (locale == 'km') {
      final month = _khmerMonths[date.month];
      final day = date.day.toString().padLeft(2, '0');
      final year = date.year.toString();
      // final day = toKhmerDigits(date.day.toString().padLeft(2, '0'));
      // final year = toKhmerDigits(date.year.toString());
      return '$month $day, $year';
    }

    // Default → English
    final month = _enMonths[date.month];
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$month $day, $year';
  }
}
