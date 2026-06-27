class DateFormatter {
  static const List<String> _spanishMonths = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  /// Formats a DateTime into a Spanish short format (e.g. "15 Oct, 08:00")
  static String formatSpanishShort(DateTime dateTime) {
    final day = dateTime.day.toString();
    final month = _spanishMonths[dateTime.month - 1];
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day $month, $hour:$minute';
  }
}
