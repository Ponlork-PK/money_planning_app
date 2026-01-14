class TransactionModel {
  final String id;
  final String userId;
  final String categoryId;
  final String type; // income, expense
  final double amount;
  final String currency;
  final String title;
  final String? description;
  final String? paymentMethod;
  final DateTime transactionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? category;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.title,
    this.description,
    this.paymentMethod,
    required this.transactionDate,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      categoryId: map['category_id'] ?? '',
      type: map['type'] ?? 'expense',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'KHR',
      title: map['title'] ?? '',
      description: map['description'],
      paymentMethod: map['payment_method'],
      transactionDate: DateTime.parse(map['transaction_date']),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      category: map['categories'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'title': title,
      'description': description,
      'payment_method': paymentMethod,
      'transaction_date': transactionDate.toIso8601String().split('T'),
    };
  }
}
