class CurrencyFormatter {
  /// Formats a double amount into a currency string (e.g. 12450.0 -> $12,450.00)
  static String format(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      }
    }
    final reversedInteger = buffer.toString().split('').reversed.join('');
    return '\$$reversedInteger.$decimalPart';
  }
}
