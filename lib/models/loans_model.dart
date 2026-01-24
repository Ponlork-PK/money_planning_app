// loan_model.dart
enum PaymentStatus { paid, pending, failed }

class Loan {
  // DB
  final String? id; // uuid
  final String? userId;

  // UI
  final String name; // lender_name
  final String lenderType; // "Bank" | "Micro" | "Family"
  final double originalAmount;
  final double currentBalance;
  final double interestRate; // store percent (ex: 1.5)
  final int? termMonths;
  final DateTime startDate;
  final DateTime? endDate;
  final String currencyCode; // USD / KHR

  // Progress
  final double paidPercent; // 0.26 => 26%
  final DateTime? nextRepaymentDate;

  // Payments
  final List<LoanPayment> schedules; // unpaid
  final List<LoanPayment> histories; // paid

  const Loan({
    this.id,
    this.userId,
    required this.name,
    required this.lenderType,
    required this.originalAmount,
    required this.currentBalance,
    required this.interestRate,
    required this.termMonths,
    required this.startDate,
    required this.endDate,
    required this.currencyCode,
    required this.paidPercent,
    required this.nextRepaymentDate,
    required this.schedules,
    required this.histories,
  });

  Loan copyWith({
    String? id,
    String? userId,
    String? name,
    String? lenderType,
    double? originalAmount,
    double? currentBalance,
    double? interestRate,
    int? termMonths,
    DateTime? startDate,
    DateTime? endDate,
    String? currencyCode,
    double? paidPercent,
    DateTime? nextRepaymentDate,
    List<LoanPayment>? schedules,
    List<LoanPayment>? histories,
  }) {
    return Loan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      lenderType: lenderType ?? this.lenderType,
      originalAmount: originalAmount ?? this.originalAmount,
      currentBalance: currentBalance ?? this.currentBalance,
      interestRate: interestRate ?? this.interestRate,
      termMonths: termMonths ?? this.termMonths,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currencyCode: currencyCode ?? this.currencyCode,
      paidPercent: paidPercent ?? this.paidPercent,
      nextRepaymentDate: nextRepaymentDate ?? this.nextRepaymentDate,
      schedules: schedules ?? this.schedules,
      histories: histories ?? this.histories,
    );
  }

  // ---------- DB mapping ----------
  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is String) return DateTime.parse(v).toLocal();
    if (v is DateTime) return v.toLocal();
    return DateTime.now();
  }

  static DateTime? _parseDateNullable(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.parse(v).toLocal();
    if (v is DateTime) return v.toLocal();
    return null;
  }

  static String _labelType(String raw) {
    final x = raw.toLowerCase().trim();
    if (x == 'bank') return 'Bank';
    if (x == 'micro') return 'Micro';
    if (x == 'family') return 'Family';
    return raw; // fallback
  }

  static String _rawType(String label) {
    final x = label.toLowerCase().trim();
    if (x == 'bank') return 'bank';
    if (x == 'micro') return 'micro';
    if (x == 'family' || x == 'personal') return 'family';
    return x;
  }

  factory Loan.fromMap(Map<String, dynamic> json) {
    return Loan(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      name: (json['lender_name'] ?? '').toString(),
      lenderType: _labelType((json['lender_type'] ?? '').toString()),
      originalAmount: (json['original_amount'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (json['original_amount'] as num?)?.toDouble() ?? 0.0, // will be recalculated in controller
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0.0,
      termMonths: (json['term_months'] as num?)?.toInt(),
      startDate: _parseDate(json['start_date']),
      endDate: _parseDateNullable(json['end_date']),
      currencyCode: (json['currency_code'] ?? 'USD').toString(),
      paidPercent: 0.0, // will be recalculated in controller
      nextRepaymentDate: null, // will be recalculated in controller
      schedules: const [],
      histories: const [],
    );
  }

  Map<String, dynamic> toCreateMap({required String userId}) {
    return {
      'user_id': userId,
      'lender_type': _rawType(lenderType),
      'lender_name': name,
      'original_amount': originalAmount,
      'interest_rate': interestRate,
      'term_months': termMonths,
      'start_date': DateTime(startDate.year, startDate.month, startDate.day).toIso8601String(),
      'end_date': endDate == null
          ? null
          : DateTime(endDate!.year, endDate!.month, endDate!.day).toIso8601String(),
      'currency_code': currencyCode,
      'status': 'active',
    };
  }
}

class LoanPayment {
  final int? id; // bigserial
  final String? loanId; // uuid
  final int paymentNo; // 1..n

  final String label; // "Payment #1"
  final double amount;
  final DateTime date; // due_date
  final String currencyCode;
  final PaymentStatus status;

  const LoanPayment({
    this.id,
    this.loanId,
    required this.paymentNo,
    required this.label,
    required this.amount,
    required this.date,
    required this.currencyCode,
    required this.status,
  });

  bool get isPaid => status == PaymentStatus.paid;

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is String) return DateTime.parse(v).toLocal();
    if (v is DateTime) return v.toLocal();
    return DateTime.now();
  }

  factory LoanPayment.fromMap(Map<String, dynamic> json) {
    final paymentNo = (json['payment_no'] as num?)?.toInt() ?? 1;
    final isPaid = (json['is_paid'] as bool?) ?? false;

    return LoanPayment(
      id: (json['id'] as num?)?.toInt(),
      loanId: json['loan_id']?.toString(),
      paymentNo: paymentNo,
      label: "Payment #$paymentNo",
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: _parseDate(json['due_date']),
      currencyCode: (json['currency_code'] ?? 'USD').toString(),
      status: isPaid ? PaymentStatus.paid : PaymentStatus.pending,
    );
  }

  Map<String, dynamic> toCreateMap({
    required String userId,
    required String loanId,
  }) {
    return {
      'user_id': userId,
      'loan_id': loanId,
      'payment_no': paymentNo,
      'due_date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'amount': amount,
      'currency_code': currencyCode,
      'is_paid': status == PaymentStatus.paid,
      'paid_at': status == PaymentStatus.paid ? DateTime.now().toUtc().toIso8601String() : null,
    };
  }
}


// import 'package:money_planning_app/models/loan_payment_model.dart';

// class LoanModel {
//   final String id;
//   final String userId;
//   final String loanTypeId;
//   final String lenderName;
//   final double originalAmount;
//   final double remainingAmount;
//   final String currency;
//   final double interestRate;
//   final int loanTermMonths;
//   final DateTime startDate;
//   final DateTime? endDate;
//   final DateTime? settlementDate;
//   final String? purpose;
//   final String status; // active, settled
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final Map<String, dynamic>? loanType;
//   final List<LoanPaymentModel>? payments;

//   LoanModel({
//     required this.id,
//     required this.userId,
//     required this.loanTypeId,
//     required this.lenderName,
//     required this.originalAmount,
//     required this.remainingAmount,
//     required this.currency,
//     required this.interestRate,
//     required this.loanTermMonths,
//     required this.startDate,
//     this.endDate,
//     this.settlementDate,
//     this.purpose,
//     required this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.loanType,
//     this.payments,
//   });

//   factory LoanModel.fromMap(Map<String, dynamic> map) {
//     return LoanModel(
//       id: map['id'] ?? '',
//       userId: map['user_id'] ?? '',
//       loanTypeId: map['loan_type_id'] ?? '',
//       lenderName: map['lender_name'] ?? '',
//       originalAmount: (map['original_amount'] ?? 0).toDouble(),
//       remainingAmount: (map['remaining_amount'] ?? 0).toDouble(),
//       currency: map['currency'] ?? 'KHR',
//       interestRate: (map['interest_rate'] ?? 0).toDouble(),
//       loanTermMonths: map['loan_term_months'] ?? 0,
//       startDate: DateTime.parse(map['start_date']),
//       endDate:
//           map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
//       settlementDate: map['settlement_date'] != null
//           ? DateTime.parse(map['settlement_date'])
//           : null,
//       purpose: map['purpose'],
//       status: map['status'] ?? 'active',
//       createdAt: map['created_at'] != null
//           ? DateTime.parse(map['created_at'])
//           : null,
//       updatedAt: map['updated_at'] != null
//           ? DateTime.parse(map['updated_at'])
//           : null,
//       loanType: map['loan_types'],
//       payments: (map['loan_payments'] as List?)
//           ?.map((p) => LoanPaymentModel.fromMap(p))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'user_id': userId,
//       'loan_type_id': loanTypeId,
//       'lender_name': lenderName,
//       'original_amount': originalAmount,
//       'remaining_amount': remainingAmount,
//       'currency': currency,
//       'interest_rate': interestRate,
//       'loan_term_months': loanTermMonths,
//       'start_date': startDate.toIso8601String().split('T'),
//       'purpose': purpose,
//       'status': status,
//     };
//   }

//   int get paidPercentage {
//     if (originalAmount == 0) return 0;
//     return ((originalAmount - remainingAmount) / originalAmount * 100).toInt();
//   }
// }
