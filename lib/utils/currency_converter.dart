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
}
