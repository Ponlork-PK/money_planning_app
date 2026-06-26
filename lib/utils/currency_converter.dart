import 'package:money_planning_app/utils/base_constants.dart';

/// Utility for converting between currencies.
/// Uses a fixed exchange rate: 1 USD = 4100 KHR.
class CurrencyConverter {
  CurrencyConverter._(); // prevent instantiation

  /// Convert any amount to USD.
  /// If already USD, returns the amount unchanged.
  /// If KHR, divides by the exchange rate.
  static double toUsd(double amount, String currencyCode) {
    if (currencyCode.toUpperCase().trim() == 'KHR') {
      return amount / BaseConstants.khrPerUsd;
    }
    return amount; // already USD
  }

  /// Convert any amount to KHR.
  /// If already KHR, returns the amount unchanged.
  /// If USD, multiplies by the exchange rate.
  static double toKhr(double amount, String currencyCode) {
    if (currencyCode.toUpperCase().trim() == 'USD') {
      return amount * BaseConstants.khrPerUsd;
    }
    return amount; // already KHR
  }

  /// Convert [amount] stored in [fromCurrency] to [toCurrency].
  /// Pass canonical currency codes: 'USD' or 'KHR'.
  static double convert(double amount, String fromCurrency, String toCurrency) {
    final from = fromCurrency.toUpperCase().trim();
    final to = toCurrency.toUpperCase().trim();
    if (from == to) return amount;
    // First normalise to USD, then convert to target
    final usd = toUsd(amount, from);
    if (to == 'USD') return usd;
    if (to == 'KHR') return usd * BaseConstants.khrPerUsd;
    return usd; // unknown target → return USD
  }

  /// Returns the display symbol for a currency code.
  static String symbol(String currencyCode) {
    return currencyCode.toUpperCase().trim() == 'KHR' ? '៛' : '\$';
  }
}
