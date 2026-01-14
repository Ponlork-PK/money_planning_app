class LoanPaymentModel {
  final String id;
  final String loanId;
  final int paymentNumber;
  final double amount;
  final DateTime dueDate;
  final DateTime? paymentDate;
  final String status; // pending, paid, overdue
  final DateTime? createdAt;

  LoanPaymentModel({
    required this.id,
    required this.loanId,
    required this.paymentNumber,
    required this.amount,
    required this.dueDate,
    this.paymentDate,
    required this.status,
    this.createdAt,
  });

  factory LoanPaymentModel.fromMap(Map<String, dynamic> map) {
    return LoanPaymentModel(
      id: map['id'] ?? '',
      loanId: map['loan_id'] ?? '',
      paymentNumber: map['payment_number'] ?? 0,
      amount: (map['amount'] ?? 0).toDouble(),
      dueDate: DateTime.parse(map['due_date']),
      paymentDate: map['payment_date'] != null
          ? DateTime.parse(map['payment_date'])
          : null,
      status: map['status'] ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isOverdue =>
      status == 'pending' && DateTime.now().isAfter(dueDate);
}
