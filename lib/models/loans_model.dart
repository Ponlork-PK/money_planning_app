// loan_model.dart

class Loan {
  // Basic info
  int? id;
  String? name;                // Micro, ACLIDA, ABA...
  String? lenderType;          // Bank, Micro, Personal
  String? category;            // All / Bank / Micro / Family, etc.
  double? originalAmount;      // 2500.00
  double? currentBalance;      // 1000.00
  double? interestRate;             // 0.015 = 1.5%
  int? termMonths;                  // 12
  DateTime? startDate;         // Jan 06, 2025
  DateTime? endDate;           // July 02, 2025

  // Progress info
  double? paidPercent;         // 0.26 => 26% Paid
  DateTime? nextRepaymentDate; // Nov 02, 2025

  // Payment schedule (future + current plan)
  List<LoanPayment>? schedules;

  // Payment history (completed payments)
  List<LoanPayment>? histories;

  // Last payment detail screen
  PaymentDetail? lastPaymentDetail;

  Loan({
    this.id,
    this.name,
    this.lenderType,
    this.category,
    this.originalAmount,
    this.currentBalance,
    this.interestRate,
    this.termMonths,
    this.startDate,
    this.endDate,
    this.paidPercent,
    this.nextRepaymentDate,
    this.schedules,
    this.histories,
    this.lastPaymentDetail,
  });
}

/// One row in Payment Schedule or Payment Histories
class LoanPayment {
  String? id;              // payment id or "Payment #1"
  String? label;           // "Payment #1", "Payment #2"...
  double? amount;          // 200.00
  DateTime? date;          // July 30, 2025
  PaymentStatus? status;   // paid / pending / failed

  LoanPayment({
    this.id,
    this.label,
    this.amount,
    this.date,
    this.status,
  });
}

enum PaymentStatus { paid, pending, failed }

/// Detailed info for "Payment Details" screen
class PaymentDetail {
  // Header
  final double amount;          // 230.00
  final bool isSuccess;         // Payment Successfully
  final String statusMessage;   // "Payment Successfully"

  // Transaction card
  final DateTime transactionDate;
  final String fromAccount;     // 0003476
  final String toAccount;       // 0008922
  final String time;            // "11:30 AM" (or store DateTime separately)

  // Amount breakdown
  final double principalPaid;   // 200.00
  final double interestPaid;    // 30.00
  double get total => principalPaid + interestPaid;

  // Purpose / note
  final String purpose;         // text in Purpose box

  PaymentDetail({
    required this.amount,
    required this.isSuccess,
    required this.statusMessage,
    required this.transactionDate,
    required this.fromAccount,
    required this.toAccount,
    required this.time,
    required this.principalPaid,
    required this.interestPaid,
    required this.purpose,
  });
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
