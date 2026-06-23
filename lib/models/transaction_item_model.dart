// class TransactionItemModel {
//   final String? id;
//   final String? userId;

//   final String type; // "income" | "expense"
//   final double amount;
//   final String currencyCode; // USD / KHR
//   final DateTime transactedAt;

//   final String? itemName;
//   final String? note;

//   final int? paymentMethodId;

//   // optional (input text OR joined name from backend)
//   final String? paymentMethodName;

//   const TransactionItemModel({
//     this.id,
//     this.userId,
//     required this.type,
//     required this.amount,
//     required this.currencyCode,
//     required this.transactedAt,
//     this.itemName,
//     this.note,
//     this.paymentMethodId,
//     this.paymentMethodName,
//   });

//   TransactionItemModel copyWith({
//     String? id,
//     String? userId,
//     String? type,
//     double? amount,
//     String? currencyCode,
//     DateTime? transactedAt,
//     String? itemName,
//     String? note,
//     int? paymentMethodId,
//     String? paymentMethodName,
//   }) {
//     return TransactionItemModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       type: type ?? this.type,
//       amount: amount ?? this.amount,
//       currencyCode: currencyCode ?? this.currencyCode,
//       transactedAt: transactedAt ?? this.transactedAt,
//       itemName: itemName ?? this.itemName,
//       note: note ?? this.note,
//       paymentMethodId: paymentMethodId ?? this.paymentMethodId,
//       paymentMethodName: paymentMethodName ?? this.paymentMethodName,
//     );
//   }

//   /// ✅ Use for INSERT (create)
//   Map<String, dynamic> toCreateMap({
//     required String userId,
//     int? resolvedPaymentMethodId,
//   }) {
//     return {
//       'user_id': userId,
//       'type': type,
//       'amount': amount,
//       'currency_code': currencyCode,
//       'transacted_at': transactedAt.toUtc().toIso8601String(),
//       'item_name': itemName,
//       'note': note,
//       'payment_method_id': resolvedPaymentMethodId ?? paymentMethodId,
//     };
//   }

//   /// ✅ Use for UPDATE (edit)
//   Map<String, dynamic> toUpdateMap({
//     int? resolvedPaymentMethodId,
//   }) {
//     return {
//       'type': type,
//       'amount': amount,
//       'currency_code': currencyCode,
//       'transacted_at': transactedAt.toUtc().toIso8601String(),
//       'item_name': itemName,
//       'note': note,
//       'payment_method_id': resolvedPaymentMethodId ?? paymentMethodId,
//     };
//   }

//   /// ✅ Use for FETCH (select)
//   factory TransactionItemModel.fromMap(Map<String, dynamic> json) {
//     final transactedRaw = json['transacted_at'];

//     final DateTime parsedDate = transactedRaw is String
//         ? DateTime.parse(transactedRaw).toLocal()
//         : (transactedRaw as DateTime).toLocal();

//     // support joined payment_methods(name)
//     String? pmName;
//     final pm = json['payment_methods'];
//     if (pm is Map<String, dynamic>) {
//       pmName = pm['name']?.toString();
//     }

//     return TransactionItemModel(
//       id: json['id'].toString(),
//       userId: json['user_id']?.toString(),
//       type: (json['type'] ?? '').toString(),
//       amount: (json['amount'] as num).toDouble(),
//       currencyCode: (json['currency_code'] ?? 'USD').toString(),
//       transactedAt: parsedDate,
//       itemName: json['item_name']?.toString(),
//       note: json['note']?.toString(),
//       paymentMethodId: (json['payment_method_id'] as num?)?.toInt(),
//       paymentMethodName: pmName,
//     );
//   }
// }




class TransactionItemModel {
  final String? id;
  final String? userId;

  /// DB column: transactions.type  ("income" | "expense")
  final String type;

  final double amount;
  final String currencyCode; // USD / KHR
  final DateTime transactedAt;

  final String? itemName;
  final String? note;

  /// FK -> categories.id (int8)
  final int? categoryId;

  /// FK -> payment_methods.id (int8)
  final int? paymentMethodId;

  // optional (joined name from backend)
  final String? paymentMethodName;

  // optional (joined from categories)
  final String? categoryName;
  final String? categoryIcon;

  const TransactionItemModel({
    this.id,
    this.userId,
    required this.type,
    required this.amount,
    required this.currencyCode,
    required this.transactedAt,
    this.itemName,
    this.note,
    this.categoryId,
    this.paymentMethodId,
    this.paymentMethodName,
    this.categoryName,
    this.categoryIcon,
  });

  bool get isIncome => type.toLowerCase().trim() == 'income';
  bool get isExpense => type.toLowerCase().trim() == 'expense';

  TransactionItemModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? currencyCode,
    DateTime? transactedAt,
    String? itemName,
    String? note,
    int? categoryId,
    int? paymentMethodId,
    String? paymentMethodName,
    String? categoryName,
    String? categoryIcon,
  }) {
    return TransactionItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      transactedAt: transactedAt ?? this.transactedAt,
      itemName: itemName ?? this.itemName,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethodName: paymentMethodName ?? this.paymentMethodName,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }

  // -----------------------------
  // ✅ INSERT (create)
  // -----------------------------
  Map<String, dynamic> toCreateMap({
    required String userId,
    int? resolvedPaymentMethodId,
  }) {
    return {
      'user_id': userId,

      // ✅ FIX: your DB column is `type`
      'type': type,

      'amount': amount,
      'currency_code': currencyCode,
      'transacted_at': transactedAt.toUtc().toIso8601String(),
      'item_name': itemName,
      'note': note,
      'category_id': categoryId,
      'payment_method_id': resolvedPaymentMethodId ?? paymentMethodId,
    };
  }

  // -----------------------------
  // ✅ UPDATE (edit)
  // -----------------------------
  Map<String, dynamic> toUpdateMap({
    int? resolvedPaymentMethodId,
  }) {
    return {
      // ✅ FIX: your DB column is `type`
      'type': type,

      'amount': amount,
      'currency_code': currencyCode,
      'transacted_at': transactedAt.toUtc().toIso8601String(),
      'item_name': itemName,
      'note': note,
      'category_id': categoryId,
      'payment_method_id': resolvedPaymentMethodId ?? paymentMethodId,
    };
  }

  // -----------------------------
  // ✅ FETCH (select)
  // -----------------------------
  factory TransactionItemModel.fromMap(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is String) return DateTime.parse(v).toLocal();
      if (v is DateTime) return v.toLocal();
      return DateTime.now();
    }

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    // payment_methods join: payment_methods(name)
    String? pmName;
    final pm = json['payment_methods'];
    if (pm is Map<String, dynamic>) {
      pmName = pm['name']?.toString();
    }

    // categories join: categories(id,name,icon)
    String? catName;
    String? catIcon;
    final cat = json['categories'];
    if (cat is Map<String, dynamic>) {
      catName = cat['name']?.toString();
      catIcon = cat['icon']?.toString();
    }

    // ✅ support either column name just in case:
    final typeStr = (json['type'] ?? json['transaction_type'] ?? '').toString();

    return TransactionItemModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      type: typeStr,
      amount: parseDouble(json['amount']),
      currencyCode: (json['currency_code'] ?? 'USD').toString(),
      transactedAt: parseDate(json['transacted_at']),
      itemName: json['item_name']?.toString(),
      note: json['note']?.toString(),
      categoryId: parseInt(json['category_id']),
      paymentMethodId: parseInt(json['payment_method_id']),
      paymentMethodName: pmName,
      categoryName: catName,
      categoryIcon: catIcon,
    );
  }
}
