class BaseConstants {
  BaseConstants._(); // prevent instantiation

  static const String appName = "Money Planning App";

  /// Currency conversion exchange rate
  static const double khrPerUsd = 4100.0;

  /// Shared Preferences keys
  static const String prefIsLoggedIn = "is_logged_in";
  static const String prefUserId = "user_id";
  static const String prefEmail = "email";

  /// Supabase Table names
  static const String tableTransactions = "transactions";
  static const String tableLoans = "loans";
  static const String tableLoanPayments = "loan_payments";
  static const String tableCategories = "categories";
  static const String tablePaymentMethods = "payment_methods";
}